vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true
-- Явный provider xclip (xsel зависает в этой среде; без g:clipboard nvim берёт xsel)
-- unnamedplus: yank/удаления идут в X11 CLIPBOARD; выделение + y → системный буфер
vim.g.clipboard = {
  name = "xclip",
  copy = {
    ["+"] = "xclip -quiet -i -selection clipboard",
    ["*"] = "xclip -quiet -i -selection primary",
  },
  paste = {
    ["+"] = "xclip -o -selection clipboard",
    ["*"] = "xclip -o -selection primary",
  },
  cache_enabled = true,
}
vim.opt.clipboard = "unnamedplus"
-- ==============================
-- UI
-- ==============================
-- Номера строк
vim.o.number = true
-- Межстрочный интервал
vim.o.linespace = 0
-- Отключить перенос строк
vim.o.wrap = false
-- Регистронезависимый поиск (/ и ?, leap и всё остальное);
-- smartcase: запрос с заглавной буквой ищет строго с учётом регистра
vim.go.ignorecase = true
vim.go.smartcase = true
-- Рамка float-окон по умолчанию (диагностика <leader>dxf, LSP hover и т.п.),
-- цвет рамки задаёт активная тема (FloatBorder); при spacecowboy — #8a6a52
vim.opt.winborder = "single"
-- Цветовая схема применяется в init.lua ПОСЛЕ require("config.lazy")
-- (плагины в lua/plugins/colors.lua должны быть загружены раньше темы)
-- Вариант-альтернатива: vim.cmd.colorscheme("monochrome") — чистый монохром
-- Убрать приветственное сообщение
vim.opt.shortmess:append "I"

-- vim.opt.termguicolors = true
-- vim.opt.updatetime = 100
-- vim.opt.lazyredraw = false
vim.opt.ttimeoutlen = 50
vim.opt.timeoutlen = 1000
vim.opt.updatetime = 100
vim.opt.mouse = 'a'

-- ==============================
-- Заголовок терминала = имя каталога проекта
-- ==============================
-- kitty-таб показывает {title} (active_tab_title_template в kitty.conf).
-- title=true + titlestring → nvim шлёт OSC 0/2; DirChanged обновляет после смены cwd.
vim.o.title = true
local function set_title()
  vim.o.titlestring = 'nvim::' .. vim.fn.fnamemodify(vim.uv.cwd() or '', ':t')
end
set_title()
vim.api.nvim_create_autocmd({ 'DirChanged', 'VimEnter' }, {
  callback = function()
    vim.schedule(set_title)
  end,
})
-- ==============================
-- Folding (treesitter): python, lua
-- ==============================
-- Фолдинг по AST (функции, классы, блоки); при открытии всё развёрнуто (foldlevel=99).
-- Свёрнутый фолд показывает исходную первую строку (def ...), а не служебный foldtext
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "lua" },
  callback = function()
    -- opt_local применяет к текущему окну (при FileType оно уже показывает буфер)
    vim.opt_local.foldmethod = "expr"
    vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt_local.foldlevel = 99
    vim.opt_local.foldtext = 'v:lua.vim.fn.getline(v:foldstart) .. "  ⋯ " .. (v:foldend - v:foldstart + 1) .. " стр."'
  end,
})
-- zX: курсор в блоке — сворачиваются только фолды ВНУТРИ этого блока (глубже его
-- уровня и в его диапазоне); соседние методы не трогаются; курсор не двигается
local function fold_keep_current_level()
  local cur = vim.fn.line(".")
  local col = vim.fn.col(".")
  local target = vim.fn.foldlevel(cur)
  if target == 0 then
    return
  end
  -- Диапазон текущего блока: если фолд открыт — от шапки до конца блока (foldlevel
  -- одинаковый на строках блока); ищем границы: от cur вверх/вниз до строки с level < target
  local start, finish = cur, cur
  while start > 1 and vim.fn.foldlevel(start - 1) >= target do
    start = start - 1
  end
  while finish < vim.fn.line("$") and vim.fn.foldlevel(finish + 1) >= target do
    finish = finish + 1
  end
  local changed = true
  while changed do
    changed = false
    for lnum = start, finish do
      if vim.fn.foldlevel(lnum) > target and vim.fn.foldclosed(lnum) == -1 then
        vim.api.nvim_win_set_cursor(0, { lnum, 0 })
        vim.cmd("normal! zc")
        changed = true
      end
    end
  end
  vim.api.nvim_win_set_cursor(0, { cur, col - 1 })
end

vim.keymap.set("n", "zX", fold_keep_current_level, { noremap = true, silent = true, desc = "Folding: закрыть всё вложенное в текущем блоке" })


vim.keymap.set("t", "<C-\\><C-\\>", "<C-\\><C-n>", { noremap = true, desc = "Exit terminal mode (двойной C-\\)" })


-- ==============================
-- Editing
-- ==============================
-- Ширина отступа (пробелы)
vim.o.shiftwidth = 2

-- ==============================
-- Splits
-- ==============================
-- Новые сплиты открываются снизу
vim.o.splitbelow = true

-- ==============================
-- Help
-- ==============================
-- Максимальная высота окна справки
vim.o.helpheight = 25

-- ==============================
-- Plugins
-- ==============================
-- Отключить встроенный тутор
vim.g.loaded_tutor_mode_plugin = 1

-- ==============================
-- Netrw
-- ==============================
-- Убрать баннер в netrw
vim.g.netrw_banner = 0.00
-- Настройки отображения буферов netrw
vim.g.netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

-- ==============================
-- Neovide (GUI-клиент)
-- ==============================
if vim.g.neovide then
  -- Отключить анимацию перемещения позиции
  vim.g.neovide_position_animation_length = 0
  -- Отключить анимацию курсора
  vim.g.neovide_cursor_animation_length = 0.00
  -- Убрать след курсора
  vim.g.neovide_cursor_trail_size = 0
  -- Отключить анимацию курсора в Insert mode
  vim.g.neovide_cursor_animate_in_insert_mode = false
  -- Отключить анимацию курсора в командной строке
  vim.g.neovide_cursor_animate_command_line = false
  -- Отключить анимацию прокрутки
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0.00
  -- Шрифт и размер
  vim.o.guifont = "JetBrainsMonoNL NF ExtraLight:h12"
end
