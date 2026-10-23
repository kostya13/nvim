-- Редактирование текста
return {
  -- Быстрые комментарии
  {
    "numToStr/Comment.nvim",
    lazy = false,
    config = function()
      require("Comment").setup()
    end,
  },
  -- Работа с окружающими символами (скобки, кавычки)
  {
    "kylechui/nvim-surround",
    version = "^3.0.0",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({})
    end,
  },
  -- Автозакрытие скобок и кавычек
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  {
    "jackMort/tide.nvim",
    opts = {
      animation_duration = 0
      -- optional configuration
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons"
    }
  },
  -- Быстрое перемещение по тексту
  {
    url = "https://codeberg.org/andyg/leap.nvim",
    -- Клавиши форк сам не назначает — только <Plug>. Плагин лёгкий → грузим при старте
    -- (lazy keys с rhs='<Plug>…' не работают: lazy переигрывает клавишу до загрузки).
    lazy = false,
    init = function()
      vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)", { desc = "Leap: прыжок к метке" })
      vim.keymap.set("n", "S", "<Plug>(leap-from-window)", { desc = "Leap: прыжок в другое окно" })
    end,
  },
  -- Навигация по символам кода
  {
    "stevearc/aerial.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    opts = {
      layout = {
	min_width = 30,
	default_direction = "left",
      },
      attach_mode = "global",
      backends = { "lsp", "treesitter"},
      filter_kind = {
	'Class',
	'Constructor',
	'Enum',
	'Function',
	'Interface',
	'Method',
	'Module',
	'Namespace',
	'Package',
	'Struct',
	-- 'Variable',  -- ← ИСКЛЮЧЕНА (не показывать)
	-- 'Constant',  -- ← ИСКЛЮЧЕНА
	-- 'Field',     -- ← ИСКЛЮЧЕНА
	-- 'Property',  -- ← ИСКЛЮЧЕНА
      },
      show_guides = true,
    },
  },
}
