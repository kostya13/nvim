-- Git-интеграция
return {
  -- Git-клиент: команды :Git, :Gdiffsplit, :Gwrite и др.
  {
    "tpope/vim-fugitive",
  },
  -- Статусные знаки на полях (добавленные/изменённые/удалённые строки)
  {
    "lewis6991/gitsigns.nvim",
  },
  -- Просмотр git-лога в виде дерева коммитов (команды :Flog, :Flogsplit)
  {
    "rbong/vim-flog",
    lazy = true,
    cmd = { "Flog", "Flogsplit", "Floggit" },
    dependencies = { "tpope/vim-fugitive" },
    init = function()
      -- Формат строки коммита: дата [хеш] (ветки) {автор} тема
      -- %aN учитывает .mailmap (инициалы заданы в проектах)
      vim.g.flog_permanent_default_opts = { format = '%ad [%h] %d {%aN} %s' }
    end,
  },
  {
    "sindrets/diffview.nvim",
  },
  -- Визуализация и разрешение merge-конфликтов (подсветка <<<<<<<, навигация, выбор стороны)
  {
    "akinsho/git-conflict.nvim",
    version = "*",
    config = function()
      require("git-conflict").setup({
        default_mappings = true,   -- встроенные маппинги (co, ct, cb, c0, ]x, [x)
        default_commands = true,   -- команды :GitConflict*
        disable_diagnostics = false, -- true ломает nvim v0.12 (vim.diagnostic.disable удалён)
        highlights = { incoming = "DiffAdd", current = "DiffText" },
      })
    end,
  },
}
