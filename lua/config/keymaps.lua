local M = {}
local opts = { noremap = true, silent = true }

-- ==============================
-- General
-- ==============================
vim.keymap.set({ 'n', 'i', 'v' }, '<C-s>', function()
  vim.cmd('write')
end, { noremap = true, silent = true, desc = "Save current file" })
vim.keymap.set("n", "<leader>ci", ":e $MYVIMRC <CR>", { noremap = true, silent = true, desc = "Open nvimconfig" })
vim.keymap.set("n", "<leader>cp", ":e $HOME/.config/nvim/lua/plugins/<CR>", { noremap = true, silent = true, desc = "Open plugins dir" })
vim.keymap.set("n", "<leader>ch", ":e $HOME/.config/nvim/lua/config/keymaps.lua<CR>", { noremap = true, silent = true, desc = "Open keymaps" })
vim.keymap.set("n", "<leader>cs", ":e $HOME/.config/nvim/lua/config/settings.lua<CR>", { noremap = true, silent = true, desc = "Open settings" })
-- Закрыть текущее окно (дубль builtin <C-w>c)
vim.keymap.set("n", "<leader>w", "<C-w>c", { noremap = true, silent = true, desc = "Close window (дубль <C-w>c)" })
vim.keymap.set("n", "<C-q>", "<C-w>c", { noremap = true, silent = true, desc = "Close window" })
vim.keymap.set("n", "<leader>h", "<cmd>nohl<cr>")
vim.keymap.set('n', '<C-Right>', ':tabnext<CR>',     { noremap = true, silent = true })
vim.keymap.set('n', '<C-Left>',  ':tabprevious<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-Up>',     ':tabnew<CR>',     { noremap = true, silent = true })

-- Alt+Right → Ctrl+] (перейти к определению)
vim.keymap.set('n', '<A-Right>', '<C-]>', { noremap = true, silent = true })
-- Alt+Left → Ctrl+o (вернуться назад)
vim.keymap.set('n', '<A-Left>', '<C-o>', { noremap = true, silent = true })

-- ==============================
-- NvimTree
-- ==============================
vim.keymap.set("n", "<F1>", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<C-F1>", ":NvimTreeFindFile<CR>", { noremap = true, silent = true, desc = "NvimTree: найти текущий файл" })
-- ==============================
-- Aerial
-- ==============================
vim.keymap.set("n", "<C-F5>", "<cmd>AerialToggle!<cr>", { noremap = true, silent = true, desc = "Toggle Aerial (панель символов)" })

-- ==============================
-- Fzf
-- ==============================
vim.keymap.set('n', '<F2>', "<cmd>FzfLua files<cr>", { desc = 'Найти файлы' })
vim.keymap.set('n', '<C-F2>', "<cmd>FzfLua oldfiles<cr>", { desc = 'Недавние файлы' })
vim.keymap.set('n', '<F3>', "<cmd>FzfLua buffers<cr>", { desc = 'Буферы' })
vim.keymap.set('n', '<F4>', "<cmd>FzfLua live_grep<cr>", { desc = 'Grep (live, по мере ввода)' })
vim.keymap.set('v', '<F4>', "<cmd>FzfLua grep_visual<cr>", { desc = 'Grep по визуальному выделению' })
-- F5 в markdown: toggle оглавления (встроенный gO — loclist-окно; vim-markdown удалён).
-- gO ставит outline в loclist; признак открытого — loclist с items на табе.
-- После gO фокус в TOC-окне (filetype qf) — закрытие работает и оттуда.
-- В остальных filetype — символы документа LSP
vim.keymap.set("n", "<F5>", function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local loc = vim.fn.getloclist(win, { winid = 0, items = {} })
    if loc.winid == win and #loc.items > 0 then
      vim.api.nvim_set_current_win(win)
      vim.cmd("lclose")
      return
    end
  end
  if vim.bo.filetype == "markdown" then
    require("vim.treesitter._headings").show_toc()  -- встроенный gO (runtime)
    vim.cmd("wincmd L")  -- окно оглавления вправо
    vim.cmd("vertical resize " .. math.floor(vim.o.columns / 3))
    return
  end
  vim.cmd("FzfLua lsp_document_symbols")
end, { noremap = true, silent = true, desc = "Markdown: оглавление (toggle) / Символы документа (LSP)" })
-- F6 toggle: окно :Git открыто на текущем табе -> закрыть, иначе -> открыть
-- Признак: буфер с filetype=fugitive (v:shell_error-буфер :Git — fugitivebuf)
vim.keymap.set("n", "<F6>", function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == 'fugitive' or vim.bo[buf].filetype == 'fugitiveblame' then
      vim.api.nvim_win_close(win, false)
      return
    end
  end
  vim.cmd('Git')
end, { noremap = true, silent = true, desc = "Git-статус (:Git, toggle)" })
-- F7 toggle: Diffview открыт на любом табе -> DiffviewClose, иначе -> DiffviewOpen
-- Признак открытого Diffview: окно с буфером diffview:// (панель файлов) на любом табе
local function diffview_is_open()
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
      if vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(win)):find('^diffview://') then
        return true
      end
    end
  end
  return false
end
vim.keymap.set("n", "<F7>", function()
  vim.cmd(diffview_is_open() and "DiffviewClose" or "DiffviewOpen")
end, { noremap = true, silent = true, desc = "Diffview: toggle (открыт -> закрыть)" })
-- F8 toggle: flog-буфер (filetype floggraph) открыт -> gq (закрыть), иначе -> :Flog
vim.keymap.set("n", "<F8>", function()
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "floggraph" then
      vim.api.nvim_set_current_win(win)
      vim.cmd("call flog#floggraph#buf#Close()")
      return
    end
  end
  vim.cmd("Flog")
end, { noremap = true, silent = true, desc = "Git-граф лога (toggle :Flog)" })
-- В flog-окне: <Tab> = список файлов коммита под курсором (git show --name-only, без diff).
-- Окно справа (botright vert), закрывается dq. В других окнах <Tab> работает как обычно.
-- flog ставит свой buffer-local <Tab> (diff по пути) ПОСЛЕ загрузки, поэтому переопределяем
-- через FileType autocmd (buffer-local поверх flog'овского)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "floggraph",
  callback = function(args)
    vim.keymap.set("n", "<Tab>", function()
      local hash = vim.fn.matchstr(vim.fn.getline("."), [[\x\{7,\}]])
      if hash == "" then
        vim.notify("Курсор не на коммите", vim.log.levels.WARN)
        return
      end
      local flog_win = vim.api.nvim_get_current_win()
      -- fugitive не переиспользует окна для :Git show (всегда новое) — закрываем старое сами
      for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        if vim.w[win].flog_side_file_list then
          vim.w[win].flog_side_file_list = nil
          vim.api.nvim_win_close(win, false)
          break
        end
      end
      vim.cmd("botright vert Floggit show " .. hash .. " --name-only")
      vim.w.flog_side_file_list = true
      -- вернуть курсор в flog-окно (fugitive переводит фокус в своё окно)
      vim.api.nvim_set_current_win(flog_win)
    end, { buffer = args.buf, noremap = true, silent = true, desc = "Flog: файлы коммита (name-only, окно справа)" })
    -- dq: закрывает окна-списки файлов (<Tab>) + штатные временные окна flog
    vim.keymap.set("n", "dq", function()
      vim.defer_fn(function()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.w[win].flog_side_file_list then
            vim.api.nvim_win_close(win, false)
          end
        end
      end, 0)
      return "<Plug>(FlogCloseTmpWin)"
    end, { buffer = args.buf, noremap = false, silent = true, expr = true })
  end,
})
-- C-F9: история коммитов текущего файла (Diffview)
vim.keymap.set("n", "<C-F9>", "<cmd>DiffviewFileHistory %<cr>", { noremap = true, silent = true, desc = "Diffview: история текущего файла" })
-- F9: история коммитов всего репозитория (Diffview, без %)
vim.keymap.set("n", "<F9>", "<cmd>DiffviewFileHistory<cr>", { noremap = true, silent = true, desc = "Diffview: история репозитория" })
vim.keymap.set("n", "<F10>", "<cmd>PytestToggle<cr>", { noremap = true, silent = true, desc = "Pytest: дерево тестов" })
-- ==============================
-- C-F хоткеи
-- ==============================
vim.keymap.set('n', '<C-F3>', "<cmd>FzfLua commands<cr>", { desc = 'Команды' })
vim.keymap.set('n', '<C-F4>', "<cmd>FzfLua grep<cr>", { desc = 'Grep по проекту (все файлы)' })
vim.keymap.set('n', '<C-F6>', "<cmd>FzfLua git_status<cr>", { desc = 'Git: изменённые файлы' })
vim.keymap.set("n", "<C-F7>", "<cmd>Git blame<cr>", { noremap = true, silent = true, desc = "Git blame" })
vim.keymap.set("n", "<C-F8>", "<cmd>Flog -all<cr>", { noremap = true, silent = true, desc = "Git-граф: все ветки" })
vim.keymap.set('n', '<C-F10>', function() vim.diagnostic.setqflist({ severity = nil }) end, { desc = 'Диагностика workspace в quickfix' })
-- ==============================
-- LSP (fzf-lua)
-- ==============================
vim.keymap.set('n', '<leader>lr', "<cmd>FzfLua lsp_references<cr>", opts)
vim.keymap.set('n', '<leader>li', "<cmd>FzfLua lsp_implementations<cr>", opts)
vim.keymap.set('n', '<leader>ld', "<cmd>FzfLua lsp_definitions<cr>", opts)
vim.keymap.set('n', '<leader>lt', "<cmd>FzfLua lsp_typedefs<cr>", opts)
vim.keymap.set('n', '<leader>ls', "<cmd>FzfLua lsp_document_symbols<cr>", opts)
vim.keymap.set('n', '<leader>lw', "<cmd>FzfLua lsp_live_workspace_symbols<cr>", opts)

-- ==============================
-- LSP (buffer-local via LspAttach)
-- ==============================
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(ev)
    local bufnr = ev.buf
    local bopts = { noremap = true, silent = true, buffer = bufnr }

    -- 0.12 LSP-дефолты: grr (references), gri (implementation), grt (type_definition),
    -- grn (rename), gra (code_action), gO (document_symbol) — свои дубли не вешаем.
    -- gd/gD/K/C-k не входят в LSP-дефолты — маппим явно.
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bopts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bopts)
    -- K: при активной DAP-сессии — значение выражения под курсором (dap-view hover),
    -- иначе обычный LSP hover
    vim.keymap.set('n', 'K', function()
      local dap = require('dap')
      if dap.session() then
        require('dap-view').hover(vim.fn.expand('<cexpr>'))
      else
        vim.lsp.buf.hover()
      end
    end, bopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bopts)
    -- Формат: явный timeout (default 1000 может не хватить ruff на больших файлах),
    -- notify при отсутствии формат-клиента (иначе жатый «слишком рано» <leader>lf молча не работает)
    local function fmt_buf()
      local fmt = vim.lsp.get_clients({ bufnr = 0, method = 'textDocument/formatting' })
      if #fmt == 0 then
        vim.notify('Нет LSP-клиента с форматированием на этом буфере', vim.log.levels.WARN)
        return
      end
      vim.lsp.buf.format({ timeout_ms = 5000 })
    end
    vim.keymap.set('n', '<leader>lf', fmt_buf, bopts)
    vim.keymap.set('v', '<leader>lf', fmt_buf, bopts)
    vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, bopts)
    vim.keymap.set('n', ']d', vim.diagnostic.goto_next, bopts)
    vim.keymap.set('n', '<leader>dxl', vim.diagnostic.setloclist, bopts)
    vim.keymap.set('n', '<leader>dxf', vim.diagnostic.open_float, bopts)
  end,
})

-- ==============================
-- DAP — клавиши как в VS Code (Shift+F<N>; kitty keyboard protocol,
-- nvim видит честные модификаторы <S-F*>)
-- ==============================
local dap = require('dap')
-- Shift+F5: continue / запуск (как F5 в VS Code)
vim.keymap.set('n', '<S-F5>', dap.continue, opts)
-- Shift+F9: toggle breakpoint (как F9)
vim.keymap.set('n', '<S-F9>', dap.toggle_breakpoint, opts)
-- Shift+F10: step over (как F10)
vim.keymap.set('n', '<S-F10>', dap.step_over, opts)
-- Shift+F11: step into (как F11)
vim.keymap.set('n', '<S-F11>', dap.step_into, opts)
-- Shift+F12: step out (как Shift+F11)
vim.keymap.set('n', '<S-F12>', dap.step_out, opts)
-- Shift+F6: terminate сессии (остановить дебаг)
vim.keymap.set('n', '<S-F6>', dap.terminate, opts)
-- Shift+F4: панель dap-view toggle с фокусом
vim.keymap.set('n', '<S-F4>', function()
  require('dap-view').toggle()
  local winnr = require('dap-view.state').winnr
  if winnr and vim.api.nvim_win_is_valid(winnr) then
    vim.api.nvim_set_current_win(winnr)
  end
end, opts)

-- ==============================
-- Leap
-- ==============================
vim.keymap.set({ 'n', 'x', 'o' }, '<leader>s', '<Plug>(leap)')

-- ==============================
-- Terminal
-- ==============================
local term_map = require("terminal.mappings")
vim.keymap.set("n", "<leader>tt", ":split term://bash<cr>")
vim.keymap.set("n", "<leader>to", term_map.toggle)
vim.keymap.set("n", "<C-F11>", term_map.toggle, { desc = "Терминал: toggle" })
vim.keymap.set("n", "<leader>tk", term_map.kill)
-- terminal.nvim подхватывает ЛЮБОЙ TermOpen-буфер, включая fzf-процессы fzf-lua
-- (sh -c "… fzf …") — они попадают в цикл <leader>t]/t[. Фильтр: удаляем из
-- active_terminals записи, чей процесс — fzf, и записи с удалённым буфером
-- (гонка TermClose → E5108 "Invalid buffer id").
local function is_fzf_term(t)
  local ok, info = pcall(vim.api.nvim_get_chan_info, t.jobid)
  if not ok or not info or not info.argv then return false end
  local a = info.argv
  return a[2] == "-c" and type(a[3]) == "string" and a[3]:find("[%w/]fzf") ~= nil
end
local function clean_terminals()
  local at = require("terminal.active_terminals")
  for _, t in ipairs(at:get_sorted_terminals()) do
    if (t.bufnr and not vim.api.nvim_buf_is_valid(t.bufnr)) or is_fzf_term(t) then
      at[t.jobid] = nil
    end
  end
end
vim.api.nvim_create_autocmd("TermOpen", {
  group = vim.api.nvim_create_augroup("terminal_nvim_filter", { clear = true }),
  callback = function(args)
    vim.defer_fn(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then return end
      local jobid = vim.b[args.buf].terminal_job_id
      if not jobid then return end
      local at = require("terminal.active_terminals")
      local t = at[jobid]
      if t and (is_fzf_term(t) or (t.bufnr and not vim.api.nvim_buf_is_valid(t.bufnr))) then
        at[jobid] = nil
      end
    end, 50)
  end,
})
-- cycle с защитой: terminal.nvim падает "Invalid buffer id", если в active_terminals
-- осталась запись с удалённым буфером (гонка TermClose / ручное bdelete).
local function safe_cycle(step)
  clean_terminals()
  if step == 1 then term_map.cycle_next() else term_map.cycle_prev() end
end
vim.keymap.set("n", "<leader>t]", function() safe_cycle(1) end, { desc = "След. терминал" })
vim.keymap.set("n", "<leader>t[", function() safe_cycle(-1) end, { desc = "Пред. терминал" })
vim.keymap.set("n", "<leader>tl", term_map.move({ open_cmd = "belowright vnew" }))
vim.keymap.set("n", "<leader>tL", term_map.move({ open_cmd = "botright vnew" }))
vim.keymap.set("n", "<leader>th", term_map.move({ open_cmd = "belowright new" }))
vim.keymap.set("n", "<leader>tH", term_map.move({ open_cmd = "botright new" }))
-- F11: терминал как <leader>tt (:split term://bash) + сразу режим ввода
vim.keymap.set("n", "<F11>", function()
  vim.cmd("split term://bash")
  vim.cmd("startinsert")
end, { noremap = true, silent = true, desc = "Терминал bash в сплите + ввод" })
-- F12: omp в новой вкладке (uv run omp)
vim.keymap.set("n", "<F12>", function()
  vim.cmd("tabnew")
  vim.cmd("terminal uv run omp")
  vim.cmd("startinsert")
end, { noremap = true, silent = true, desc = "omp в новой вкладке (uv run)" })
-- C-F12: omp на всё окно в текущем табе
local function omp_terminal(open_cmd)
  vim.cmd(open_cmd .. " | terminal uv run omp")
  vim.cmd("startinsert")
end
vim.keymap.set("n", "<C-F12>", function() omp_terminal("only") end,
  { noremap = true, silent = true, desc = "omp на всё окно (uv run)" })

-- ==============================
-- Git
-- ==============================
vim.keymap.set('n', '<leader>gc', ':GitCreateBranch<CR>', { noremap = true, silent = true, desc = "Create Git branch" })
vim.keymap.set('n', '<leader>gs', "<cmd>FzfLua git_status<cr>", { noremap = true, silent = true, desc = "Git: изменённые файлы" })
vim.keymap.set('n', '<leader>gb', "<cmd>FzfLua git_branches<cr>", { noremap = true, silent = true, desc = "Git: ветки" })
vim.keymap.set('n', '<leader>gf', ':Git fetch --prune<CR>', { noremap = true, silent = true, desc = "Git fetch --prune" })
vim.keymap.set('n', '<leader>gp', ':Git pull<CR>', { noremap = true, silent = true, desc = "Git pull" })

-- ==============================
-- CMP mappings (exported for plugins/ui.lua)
-- ==============================
local cmp = require('cmp')
M.cmp_mappings = cmp.mapping.preset.insert({
  ['<C-b>'] = cmp.mapping.scroll_docs(-4),
  ['<C-f>'] = cmp.mapping.scroll_docs(4),
  ['<C-y>'] = cmp.mapping.complete(),
  ['<C-e>'] = cmp.mapping.abort(),
  ['<CR>'] = cmp.mapping.confirm({ select = true }),
})

-- ==============================
-- Neovim Project
-- ==============================
vim.keymap.set("n", "<leader>p", "<cmd>NeovimProjectHistory<cr>", { desc = 'Проекты: недавние' })
vim.keymap.set("n", "<leader>P", "<cmd>NeovimProjectDiscover<cr>", { desc = 'Проекты: все' })

  -- Поиск по содержимому проекта
  vim.api.nvim_create_user_command('Grep', function(cmd_opts)
    require('fzf-lua').live_grep({ search = cmd_opts.args })
  end, {
    nargs = '*',
    complete = 'file',
    desc = 'Поиск по содержимому проекта с помощью fzf-lua',
  })
-- Диагностика всего проекта в quickfix
-- pyright не поддерживает workspace/diagnostics, поэтому: открыть все py-файлы
-- проекта (bufadd+bufload, без окон), собрать vim.diagnostic.get(nil) в quickfix,
-- затем закрыть созданные буферы, чтобы не засорять сессию.
vim.api.nvim_create_user_command('DiagProject', function()
  local exclude = { 'venv/**', '.venv/**', 'migrations/**', 'node_modules/**' }
  local files = vim.fn.systemlist({ 'rg', '--files', '-g', '*.py', unpack(vim.tbl_map(function(p) return '-g', '!' .. p end, exclude)) })
  if vim.v.shell_error ~= 0 or #files == 0 then
    vim.notify('py-файлы проекта не найдены', vim.log.levels.WARN)
    return
  end
  vim.notify('Сбор диагностики: ' .. #files .. ' файлов...')
  local created = {}
  local cur = vim.api.nvim_get_current_buf()
  for _, f in ipairs(files) do
    local buf = vim.fn.bufadd(f)
    if buf > 0 then
      vim.fn.bufload(buf)
      if buf ~= cur then table.insert(created, buf) end
    end
  end
  -- ожидание: pyright анализирует открытые файлы, ruff тоже; max 10 с
  vim.defer_fn(function()
    local qf = vim.diagnostic.toqflist(vim.diagnostic.get(nil))
    for _, item in ipairs(qf) do
      if item.bufnr and item.bufnr > 0 then
        item.filename = vim.fn.bufname(item.bufnr)
        item.bufnr = nil
      end
    end
    vim.fn.setqflist(qf, 'r')
    vim.fn.setqflist({}, 'r', { title = 'Диагностика проекта (' .. #qf .. ')' })
    -- закрыть созданные буферы
    for _, b in ipairs(created) do
      if vim.api.nvim_buf_is_loaded(b) then pcall(vim.api.nvim_buf_delete, b, { force = true }) end
    end
    vim.notify('Диагностика проекта: ' .. #qf .. ' записей', vim.log.levels.INFO)
    vim.cmd('copen')
  end, 10000)
end, { desc = 'Диагностика всех py-файлов проекта в quickfix' })
-- ty (Astral type checker) -> quickfix.
-- uvx ставит ty без установки в PATH; формат concise парсится errorformat'ом ниже.
vim.api.nvim_create_user_command('TyCheck', function(cmd_opts)
  local root = vim.fs.root(0, { 'pyproject.toml', 'ty.toml', '.git' }) or vim.fn.getcwd()
  local args = { 'uvx', '--system-certs', 'ty', 'check', '--output-format', 'concise', '--no-progress' }
  -- аргументы после команды заменяют пути проверки: :TyCheck lua/scripts
  vim.list_extend(args, cmd_opts.fargs)
  vim.fn.chdir(root)
  vim.opt.makeprg = table.concat(args, ' ')
  -- file:line:col: severity[rule] message; итоговая строка "Found N diagnostic(s)" — мимо
  vim.opt.errorformat = '%f:%l:%c: %m,%-GFound %\\d%\\+ diagnostic%.%#'
  vim.notify('ty: проверка ' .. root)
  vim.cmd('silent make!')
  local qf = vim.fn.getqflist()
  vim.fn.setqflist({}, 'r', {
    title = 'ty (' .. root .. '): ' .. #qf .. ' диагностик',
    items = qf,
  })
  vim.cmd('copen')
end, {
  nargs = '*',
  complete = 'dir',
  desc = 'ty type check проекта в quickfix',
})
vim.keymap.set('n', '<leader>ct', '<cmd>TyCheck<cr>', { desc = 'ty: проверка проекта' })
-- ==============================
-- Навигация окнами / ханками / буферами / терминалом
-- ==============================
-- C-h/j/k/l: переход между сплитами (в терминале — тот же переход между окнами)
local function win_nav(dir)
  return function()
    if vim.bo.buftype == 'terminal' then
      vim.cmd('stopinsert')
    end
    vim.cmd('wincmd ' .. dir)
    if vim.bo.buftype == 'terminal' then
      vim.cmd('startinsert')
    end
  end
end
for _, d in ipairs({ 'h', 'j', 'k', 'l' }) do
  vim.keymap.set({ 'n', 't' }, '<C-' .. d .. '>', win_nav(d), { noremap = true, silent = true, desc = 'Окно: ' .. d })
end
-- ]c/[c: следующий/предыдущий git-ханк (в diff-режиме — встроенный vim-переход)
local gs = package.loaded.gitsigns
vim.keymap.set('n', ']c', function()
  if vim.wo.diff then vim.cmd.normal({ ']c', bang = true }) else gs.nav_hunk('next') end
end, { noremap = true, silent = true, desc = 'Git: следующий ханк' })
vim.keymap.set('n', '[c', function()
  if vim.wo.diff then vim.cmd.normal({ '[c', bang = true }) else gs.nav_hunk('prev') end
end, { noremap = true, silent = true, desc = 'Git: предыдущий ханк' })
-- Tab/S-Tab: следующий/предыдущий буфер
vim.keymap.set('n', '<Tab>', '<cmd>bnext<cr>', { noremap = true, silent = true, desc = 'Следующий буфер' })
vim.keymap.set('n', '<S-Tab>', '<cmd>bprevious<cr>', { noremap = true, silent = true, desc = 'Предыдущий буфер' })
-- Esc в терминале: выйти в normal mode, не убивая процесс
-- vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { noremap = true, silent = true, desc = 'Терминал: normal mode' })

return M
