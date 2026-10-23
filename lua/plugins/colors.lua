-- Цветовая схема. Переключение: :colorscheme minicode
return {
  {
    "nullkerf/minicode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      -- Курсив выключен: comments/keywords/variables поддерживаются opts,
      -- Folded/SpecialComment/@variable.parameter — хардкод в теме, гасятся autocmd-ом ниже
      styles = {
        comments  = { italic = false },
        keywords  = { bold = true, italic = false },
        variables = { italic = false },
      },
    },
    init = function()
      vim.api.nvim_create_autocmd('ColorScheme', {
        pattern = 'minicode',
        callback = function()
          -- Хардкод-italic группы (не управляются opts.styles), цвета из палитры темы:
          vim.api.nvim_set_hl(0, 'Folded', { fg = '#9b754a', bg = '#262626', italic = false })
          vim.api.nvim_set_hl(0, 'SpecialComment', { fg = '#5e5a55', italic = false })
          vim.api.nvim_set_hl(0, '@variable.parameter', { fg = '#ddd9d5', italic = false })
          -- Отладка (nvim-dap): знаки по умолчанию красятся texthl=SignColumn (невидимы).
          -- Яркие цвета поверх палитры: breakpoint — красный, текущая строка — оранжевый.
          vim.api.nvim_set_hl(0, 'DapBreakpoint',          { fg = '#e35b5b' })
          vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#e3a13b' })
          vim.api.nvim_set_hl(0, 'DapBreakpointRejected',  { fg = '#6b6b6b' })
          vim.api.nvim_set_hl(0, 'DapLogPoint',            { fg = '#5bb8e3' })
          vim.api.nvim_set_hl(0, 'DapStopped',             { fg = '#ffb638', bold = true })
          vim.api.nvim_set_hl(0, 'debugPC',                { bg = '#3d3223' })
          -- Фон #151515 вместо палитрного #1e1e1e: все группы темы с bg_base
          local BG = '#151515'
          for _, g in ipairs({
            'Normal', 'NormalNC', 'EndOfBuffer', 'SignColumn', 'LineNr', 'CursorLineNr',
            'VertSplit', 'WinSeparator', 'FoldColumn',
            'Todo', 'ErrorMsg', 'WarningMsg', 'MoreMsg', 'Question', 'MsgSeparator',
            'GitSignsAdd', 'GitSignsChange', 'GitSignsDelete',
          }) do
            local hl = vim.api.nvim_get_hl(0, { name = g })
            hl.bg = BG
            vim.api.nvim_set_hl(0, g, hl)
          end
        end,
      })
    end,
  },
}
