-- Дебаггер (Debug Adapter Protocol)
return {
  -- Ядро DAP — протокол взаимодействия с дебаггерами
  {
    "mfussenegger/nvim-dap",
    lazy = false,
    config = function()
      -- Знаки отладки: U+25B6 (треугольник) и U+F111 (fa-circle, заливной круг)
      -- — есть в JetBrainsMono Nerd Font (проверены через cmap шрифта).
      -- Переопределяют дефолты nvim-dap ('→'/'B'/'C'/'R'/'L', dap.lua:431-436).
      local signs = {
        DapStopped             = { text = "\u{25B6}", texthl = "DapStopped",             linehl = "debugPC" },
        DapBreakpoint          = { text = "\u{F111}", texthl = "DapBreakpoint",          linehl = "" },
        DapBreakpointCondition = { text = "\u{F111}", texthl = "DapBreakpointCondition", linehl = "" },
        DapBreakpointRejected  = { text = "\u{F10C}", texthl = "DapBreakpointRejected",  linehl = "" },
        DapLogPoint            = { text = "\u{F10C}", texthl = "DapLogPoint",            linehl = "" },
      }
      for name, opts in pairs(signs) do
        opts.numhl = ""
        vim.fn.sign_define(name, opts)
      end
    end,
  },
  -- Отладка Python-скриптов через debugpy
  {
    "mfussenegger/nvim-dap-python",
    lazy = false,
    config = function()
      require("dap-python").setup(vim.fn.stdpath('data') .. "/mason/packages/debugpy/venv/bin/python")
      -- table.insert(require('dap').configurations.python, {
      --   name = "Python: Django",
      --   type = "python",
      --   request = "launch",
      --   program = "${workspaceFolder}/manage.py",
      --   envFile = "${workspaceFolder}/.env",
      --   args = { "runserver", "--settings=conf.settings" },
      --   django = true,
      --   justMyCode = false,
      --   console = "integratedTerminal",
      --   env = { PYTHONUNBUFFERED = "1" },
      --  }
      require('dap').configurations.python = nil
    end,
  },
  -- Панель управления сессиями, потоками, REPL и консолью
  {
    "igorlfs/nvim-dap-view",
    opts = {
      winbar = {
        sections = { "sessions", "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
      },
      windows = {
        size = 2 / 3, -- главное окно занимает 2/3 экрана
        position = "below",
        terminal = {
          size = 0.5, -- терминал — половина от главного окна
          position = "left",
        },
      },
    },
  },
}
