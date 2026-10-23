vim.g.mapleader = " "

require("config.settings")
require("config.lazy")
require("config.lsp")
require("config.keymaps")
vim.cmd.colorscheme("noclown")

-- Добавить пути к инструментам
if vim.fn.executable('node') == 0 then
  -- Если node не найден, добавить пути вручную
  local path = os.getenv('HOME') .. '/.nvm/versions/node/v25.2.1/bin'
  local current_path = vim.fn.getenv('PATH')
  vim.fn.setenv('PATH', current_path .. ':' .. path)
end


require('pytest-nui').setup()
