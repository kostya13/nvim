-- LSP-конфигурация (nvim 0.12, vim.lsp.config API)
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- pyright — типы и диагностика Python
-- vim.lsp.config('pyright', {
--   capabilities = capabilities,
--   settings = {
--     python = {
--       analysis = {
--         typeCheckingMode = 'basic',
--         autoSearchPaths = true,
--         useLibraryCodeForTypes = true,
--       },
--     },
--   },
-- })

-- pylsp — линтеры Python (pycodestyle/flake8); комплишн/hover не даёт
-- (это ruff + pyright при включении, см. закомментированные блоки ниже).
vim.lsp.config('pylsp', {
  capabilities = capabilities,
  settings = {
    pylsp = {
      plugins = {
        -- Линт: длина строки 120 (стандарт x5-репозиториев)
        pycodestyle = {
          enabled = true,
          maxLineLength = 120,
          ignore = { 'E203', 'W503' }, -- срезы по black, бинарные операторы с новой строки
        },
        -- flake8 в mason-сборке pylsp есть, но дублирует pycodestyle
        flake8 = { enabled = false },
        pyflakes = { enabled = false },  -- дублирует flake8/pyright
        mccabe = { enabled = false },    -- cyclomatic complexity — шум
        jedi_completion = { enabled = true },
        jedi_hover = { enabled = true },
        jedi_definition = { enabled = true },
        jedi_symbols = { enabled = true },
        -- Форматтеры через LSP не нужны (есть ruff)
        autopep8 = { enabled = false },
        yapf = { enabled = false },
        rope_autoimport = { enabled = false },
        rope_completion = { enabled = false },
      },
    },
  },
})

-- -- ruff — мгновенный линт + code actions (fix), не конфликтует с pyright
-- vim.lsp.config('ruff', {
--   capabilities = capabilities,
-- -- settings не задаём: ruff читает pyproject.toml/ruff.toml проекта
-- })
--
-- -- lua_ls — конфигурация nvim-конфига
-- vim.lsp.config('lua_ls', {
--   capabilities = capabilities,
--   settings = {
--     Lua = {
--       runtime = { version = 'LuaJIT' },
--       diagnostics = { globals = { 'vim' } },
--       workspace = {
--         library = vim.api.nvim_get_runtime_file('', true),
--         checkThirdParty = false,
--       },
--       telemetry = { enable = false },
--     },
--   },
-- })
--
-- -- Включить серверы (mason-lspconfig v2 не включает их сам)
-- vim.lsp.enable({ 'pyright', 'pylsp', 'ruff', 'lua_ls' })

-- C-] (tagfunc): обёртка над vim.lsp.tagfunc. Два фиксa:
-- 1) buf_request_sync теряет ответ pylsp (гонка pygls, nvim 0.12) — заменён на
--    async-запрос + vim.wait(5 c); без этого при медленном ответе nvim молча
--    падает на vim-теги: E433 No tags file + E426 Tag not found.
-- 2) pylsp (1.15.0) не резолвит `from . import X`: его definition добавляет
--    каталог документа в sys_path, и jedi теряет относительный импорт из
--    __init__.py. Fallback — прямой вызов jedi (scripts/jedi_def.py).
vim.lsp.tagfunc = function(pattern, flags)
  local bufnr = vim.api.nvim_get_current_buf()
  if flags ~= 'c' then
    return vim.lsp._tagfunc(pattern, flags) -- не goto-сценарий: workspace/symbol как обычно
  end
  -- Один async-запрос + vim.wait: buf_request_sync внутри pylsp-гонки
  -- стабильно теряет ответ (проверено на nvim 0.12), async+wait — нет.
  local result
  vim.lsp.buf_request(bufnr, 'textDocument/definition',
    function(client) return vim.lsp.util.make_position_params(0, client.offset_encoding) end,
    function(_, res) result = res end)
  vim.wait(5000, function() return result ~= nil end, 10)
  local tags = {}
  if result then
    local locs = result.range and { result } or result -- Location | Location[]
    for _, loc in ipairs(locs) do
      if loc.range then
        tags[#tags + 1] = {
          name = pattern,
          filename = vim.uri_to_fname(loc.uri),
          cmd = tostring(loc.range.start.line + 1),
        }
      end
    end
  end
  -- pylsp не резолвит `from . import X` (его use_document_path ломает jedi).
  -- Fallback: прямой вызов jedi питоном из mason-venv pylsp (там jedi уже стоит).
  local pylsp = vim.lsp.get_clients({ bufnr = bufnr, name = 'pylsp' })[1]
  local py = pylsp and pylsp.config.cmd and vim.fn.exepath(pylsp.config.cmd[1]) or nil
  if py then
    -- mason/bin/pylsp → packages/python-lsp-server/venv/bin/pylsp → venv/bin/python
    py = vim.fs.normalize(vim.fs.dirname(vim.fs.dirname(vim.fn.resolve(py))) .. '/bin/python')
    if vim.fn.filereadable(py) == 0 then py = nil end
  end
  if py then
    local row = vim.fn.line('.')
    local col = vim.fn.charcol('.') - 1
    local out = vim.system({ py, vim.fn.expand('~/.config/nvim/scripts/jedi_def.py'),
      vim.api.nvim_buf_get_name(bufnr), tostring(row), tostring(col) }):wait()
    if out.code == 0 and out.stdout ~= '' then
      local ok, defs = pcall(vim.json.decode, out.stdout)
      if ok and type(defs) == 'table' and #defs > 0 then
        local jtags = {}
        for _, d in ipairs(defs) do
          jtags[#jtags + 1] = { name = pattern, filename = d.path, cmd = tostring(d.line) }
        end
        return jtags
      end
    end
  end
  return vim.lsp._tagfunc(pattern, flags) -- и jedi пусто → обычный fallback (tags)
end
