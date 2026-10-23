-- Инструменты
return {
  -- Менеджер LSP/DAP серверов
  {
    "mason-org/mason-lspconfig.nvim",
    opts = {
     -- ensure_installed = { "lua_ls", "pyright", "pylsp", "ruff" },
    },
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "neovim/nvim-lspconfig",
    },
  },
  -- Встроенный терминал
  {
    "rebelot/terminal.nvim",
    config = function()
      require("terminal").setup()
    end,
  },
}
