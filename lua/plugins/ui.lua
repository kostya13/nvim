-- Интерфейс
return {
  -- Файловый менеджер
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("nvim-tree").setup {
	-- root_dirs = { vim.fn.getcwd() },  -- ← Корневая директория
	-- respect_buf_cwd = true,  -- Следить за текущей директорией буфера
	-- Синхронизировать root дерева с cwd: при переключении проекта
	-- (neovim-project делает nvim_set_current_dir) дерево следует за cwd
	sync_root_with_cwd = true,
	filters = {
	  git_ignored = false, -- показывать gitignored (.env, .venv и т.п.); в дереве — I
	},
	view = {
	  cursorline = true,  -- ← ГЛАВНОЕ
	},
	renderer = {
	  indent_markers = {
	    enable = true,  -- ← ГЛАВНОЕ
	    inline_arrows = true,
	    icons = {
	      corner = '└',
	      edge = '│',
	      item = '│',
	      bottom = '─',
	      none = ' ',
	    },
	  },
	},
      }
    end,
  },
  -- Хлебные крошки в winbar: файл › класс › функция (позиция курсора)
  {
    "Bekaboo/dropbar.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },
  -- Статусная строка
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      sections = {
	lualine_c = { { "filename", path = 3 } },
	lualine_x = { "lsp_status", "venv-selector", "encoding", "fileformat", "filetype" },
      },
      theme = "auto", -- следует активной colorscheme (catppuccin имеет lualine-тему)
    },
  },
  -- Визуальные отступы
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = { scope = { enabled = false } },
  },
  -- Автодополнение
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")
      local keymaps = require("config.keymaps")

      cmp.setup({
	snippet = {
	  expand = function(args)
	    luasnip.lsp_expand(args.body)
	  end,
	},
	window = {
	  completion = cmp.config.window.bordered(),
	  documentation = cmp.config.window.bordered(),
	},
	mapping = keymaps.cmp_mappings,
	sources = cmp.config.sources({
	  { name = "nvim_lsp" },
	  { name = "luasnip" },
	  { name = "buffer" },
	  { name = "path" },
	}),
      })
    end,
  },
  -- Подсветка синтаксиса и парсинг кода
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    lazy = false,
    build = ":TSUpdate",
    -- Корневого модуля 'nvim-treesitter' нет — lazy не может вызвать setup(opts),
    -- поэтому opts не работают, нужен явный config
    config = function()
      -- queries/markdown из плагина перекрыты пустыми queries в
      -- ~/.config/nvim/queries/{markdown,markdown_inline}/ (первый на rtp)
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "python", "lua", "bash" },
      }
    end,
  },
  {
    "linux-cultist/venv-selector.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    ft = "python", -- Load when opening Python files
    keys = { { ",v", "<cmd>VenvSelect<cr>" } }, -- Open picker on keymap
    opts = {
      options = { picker = "fzf-lua" },
    },
  },
}
