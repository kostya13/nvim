-- nohappiness
--
-- Порт VS Code темы "No Happiness in Colors" — по ЛОКАЛЬНОЙ копии пользователя:
--   ~/.vscode/extensions/notoroszbig.theme-nohappinessincolors-1.0.2/themes/nohappinessincolors.json
-- (версия 1.0.2 с локальными правками: зелёный keyword #00dd88, песочные
--  функции #d4a574, оливковое выделение, золотой курсор; НЕ серый
--  маркетплейс-вариант и не old.tmTheme — тот «LightTable»-монохром).
-- Учтены и переопределения из ~/.config/Code/User/settings.json:
--   workbench.colorCustomizations: statusBar #999999/#000000.
--
-- VS Code rgba-цвета сведены на непрозрачный фон #1A1A1A.

vim.cmd 'highlight clear'
if vim.g.syntax_on then
  vim.cmd 'syntax reset'
end
vim.g.colors_name = 'nohappiness'

local c = {
  bg        = '#1a1a1a', -- editor.background
  bg_group  = '#000000', -- editorGroup.background
  bg_line   = '#333333', -- текущая строка: исходно #222222, усилено для контраста (vscode lineHighlight в nvim слишком тусклый)
  bg_widget = '#222222', -- editorWidget.background (float-окна)
  bg_hover  = '#2a2a2a', -- list.hoverBackground / hoverHighlight
  bg_inactive = '#191919', -- tab.inactiveBackground
  bg_tab    = '#121212', -- tab.activeBackground
  sel       = '#384318', -- editor.selectionBackground #53661788 → blend
  sel_inactive = '#1d2233', -- editor.inactiveSelectionBackground
  find      = '#725b05', -- editor.findMatchBackground #886B00CC → blend
  find_hi   = '#131a2a', -- editor.findMatchHighlightBackground
  find_rng  = '#1c2a13', -- editor.findRangeHighlightBackground
  word_hi   = '#36382d', -- editor.wordHighlightBackground
  bmatch    = '#455255', -- editorBracketMatch
  fg        = '#d0d0d0', -- editor.foreground
  fg_bright = '#ffffff', -- tab.activeForeground, list.focusForeground
  fg_input  = '#cccccc', -- quickInput.foreground
  grey9     = '#999999', -- storage, атрибуты; statusBar bg (custom)
  grey8     = '#888888', -- tag; sideBarSectionHeader
  grey6     = '#666666', -- lineNr, indentGuide, sideBar.foreground
  grey4     = '#444444', -- whitespace; badge bg
  comment   = '#5a7a5a', -- comment
  green     = '#00dd88', -- keyword, keyword.control.import
  sand      = '#d4a574', -- entity.name.*, support.function, storage.type, constant.language
  str       = '#b9f6ca', -- string
  var       = '#d4d4d4', -- variable
  op        = '#d0d0d0', -- keyword.operator (= editor.foreground)
  cursor    = '#ffd700', -- editorCursor.foreground, list.highlightForeground
  quick_focus = '#14420b', -- quickInputList.focusBackground
  quick_inactive = '#162f4d', -- quickInputList.inactiveFocusBackground
  invalid_bg = '#ff3333', invalid_fg = '#f8f8f0',
  dep_bg    = '#ccaaff', dep_fg = '#ffffff',
  info      = '#6796e6',
  warn      = '#cd9731',
  error     = '#f44747',
  debug     = '#b267e6',
}

local hi = function(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- ── Базовые ──────────────────────────────────────────────────────────────
hi('Normal',      { fg = c.fg, bg = c.bg })
hi('NormalFloat', { fg = c.fg_input, bg = c.bg_widget })
hi('FloatBorder', { fg = c.grey6, bg = c.bg_widget })
hi('FloatTitle',  { fg = c.grey8, bg = c.bg_widget, bold = true })
hi('EndOfBuffer', { fg = c.bg, bg = c.bg })
hi('NormalNC',    { fg = c.fg, bg = c.bg })

-- ── Синтаксис (1:1 tokenColors локальной версии) ────────────────────────
hi('Comment',     { fg = c.comment, italic = true })
hi('String',      { fg = c.str })
hi('Character',   { fg = c.str })
-- constant.numeric в локальной теме не определён → дефолтный token: #c2c2b0
hi('Number',      { fg = '#c2c2b0' })
hi('Boolean',     { fg = c.sand })      -- constant.language
hi('Constant',    { fg = c.sand })      -- constant.language
hi('Identifier',  { fg = c.var })       -- variable
hi('Function',    { fg = c.sand })      -- entity.name.function
hi('Statement',   { fg = c.green })     -- keyword
hi('Keyword',     { fg = c.green })     -- keyword
hi('Conditional', { fg = c.green })
hi('Repeat',      { fg = c.green })
hi('Label',       { fg = c.green })
hi('Exception',   { fg = c.green })
hi('Operator',    { fg = c.op })        -- keyword.operator
hi('PreProc',     { fg = c.green })
hi('Include',     { fg = c.green })     -- keyword.control.import
hi('Define',      { fg = c.green })
hi('Macro',       { fg = c.green })
hi('Type',        { fg = c.sand })      -- storage.type
hi('StorageClass',{ fg = c.sand })      -- storage.type
hi('Structure',   { fg = c.sand })
hi('Typedef',     { fg = c.sand })
hi('Special',     { fg = c.sand })
hi('Tag',         { fg = c.grey8 })     -- entity.name.tag
hi('Delimiter',   { fg = c.fg })
hi('Underlined',  { fg = c.var, underline = true })
hi('Bold',        { bold = true })
hi('Italic',      { italic = true })

-- ── Редактор ─────────────────────────────────────────────────────────────
hi('Cursor',         { fg = c.bg, bg = c.cursor })
hi('CursorLine',     { bg = c.bg_line })
hi('CursorColumn',   { bg = c.bg_line })
hi('CursorLineNr',   { fg = c.cursor, bg = c.bg_line })
hi('LineNr',         { fg = c.grey6 })           -- editorLineNumber #666666
hi('Visual',         { fg = c.fg_bright, bg = c.sel }) -- selectionForeground #FFFFFF
hi('VisualNOS',      { bg = c.sel })
hi('Search',         { fg = c.fg_bright, bg = c.find })
hi('IncSearch',      { fg = c.bg, bg = c.cursor })
hi('CurSearch',      { fg = c.bg, bg = c.cursor })
hi('Substitute',     { fg = c.bg, bg = c.grey9 })
hi('MatchParen',     { fg = c.fg_bright, bg = c.bmatch })
hi('Whitespace',     { fg = c.grey4 })
hi('NonText',        { fg = c.grey4 })
hi('SpecialKey',     { fg = c.grey4 })
hi('Conceal',        { fg = c.grey6 })
hi('Directory',      { fg = c.sand })
hi('Title',          { fg = c.sand, bold = true })
hi('ErrorMsg',       { fg = c.error, bg = c.bg })
hi('WarningMsg',     { fg = c.warn, bg = c.bg })
hi('MoreMsg',        { fg = c.green, bg = c.bg })
hi('ModeMsg',        { fg = c.fg_input, bg = c.bg })
hi('Question',       { fg = c.green, bg = c.bg })
hi('SpellBad',       { fg = c.error, undercurl = true, sp = c.error })
hi('SpellCap',       { fg = c.info, undercurl = true, sp = c.info })
hi('SpellRare',      { fg = c.debug, undercurl = true, sp = c.debug })
hi('SpellLocal',     { fg = c.warn, undercurl = true, sp = c.warn })

-- ── UI-хром (workbench) ─────────────────────────────────────────────────
-- statusBar #999999/#000000 — из workbench.colorCustomizations пользователя
hi('StatusLine',   { fg = '#000000', bg = c.grey9 })
hi('StatusLineNC', { fg = c.grey6, bg = c.bg_inactive })
hi('WinBar',       { fg = c.grey6, bg = c.bg })
hi('WinBarNC',     { fg = c.grey4, bg = c.bg })
hi('WinSeparator', { fg = c.grey4, bg = c.bg })
hi('VertSplit',    { fg = c.grey4, bg = c.bg })
-- tab strip: активный #121212/#FFFFFF, неактивный #191919/#699999
hi('TabLine',      { fg = '#699999', bg = c.bg_inactive })
hi('TabLineFill',  { bg = c.bg_inactive })
hi('TabLineSel',   { fg = c.fg_bright, bg = c.bg_tab })
-- quickInput (palette) → Pmenu
hi('Pmenu',         { fg = c.fg_input, bg = c.bg })
hi('PmenuSel',      { fg = c.fg_bright, bg = c.quick_focus })
hi('PmenuSbar',     { bg = c.bg_widget })
hi('PmenuThumb',    { bg = c.grey4 })
hi('PmenuMatch',    { fg = c.cursor, bg = c.bg, bold = true })
hi('PmenuMatchSel', { fg = c.cursor, bg = c.quick_focus, bold = true })
hi('PmenuExtra',    { fg = c.grey6, bg = c.bg })
hi('PmenuExtraSel', { fg = c.grey6, bg = c.quick_focus })
hi('WildMenu',      { fg = c.fg_bright, bg = c.quick_focus })
hi('Folded',        { fg = c.grey6, bg = c.bg_widget })
hi('FoldColumn',    { fg = c.grey4, bg = c.bg })
hi('SignColumn',    { fg = c.grey4, bg = c.bg })
hi('ColorColumn',   { bg = c.bg_inactive })
hi('QuickFixLine',  { bg = c.bg_line })

-- ── Диагностика (token.*-token из темы) ─────────────────────────────────
hi('DiagnosticError',            { fg = c.error })
hi('DiagnosticWarn',             { fg = c.warn })
hi('DiagnosticInfo',             { fg = c.info })
hi('DiagnosticHint',             { fg = c.debug })
hi('DiagnosticVirtualTextError', { fg = c.error })
hi('DiagnosticVirtualTextWarn',  { fg = c.warn })
hi('DiagnosticVirtualTextInfo',  { fg = c.info })
hi('DiagnosticVirtualTextHint',  { fg = c.debug })
hi('DiagnosticUnderlineError',   { undercurl = true, sp = c.error })
hi('DiagnosticUnderlineWarn',    { undercurl = true, sp = c.warn })
hi('DiagnosticUnderlineInfo',    { undercurl = true, sp = c.info })
hi('DiagnosticUnderlineHint',    { undercurl = true, sp = c.debug })
hi('DiagnosticFloatingError',    { fg = c.error, bg = c.bg_widget })
hi('DiagnosticFloatingWarn',     { fg = c.warn, bg = c.bg_widget })
hi('DiagnosticFloatingInfo',     { fg = c.info, bg = c.bg_widget })
hi('DiagnosticFloatingHint',     { fg = c.debug, bg = c.bg_widget })
hi('DiagnosticSignError',        { fg = c.error, bg = c.bg })
hi('DiagnosticSignWarn',         { fg = c.warn, bg = c.bg })
hi('DiagnosticSignInfo',         { fg = c.info, bg = c.bg })
hi('DiagnosticSignHint',         { fg = c.debug, bg = c.bg })
hi('DiagnosticUnnecessary',      { fg = c.grey6 })

-- invalid / invalid.deprecated
hi('Error',  { fg = c.invalid_fg, bg = c.invalid_bg })
hi('Todo',   { fg = c.dep_fg, bg = c.dep_bg })

-- ── LSP/semantic tokens ─────────────────────────────────────────────────
hi('LspReferenceText',  { bg = c.word_hi })
hi('LspReferenceRead',  { bg = c.word_hi })
hi('LspReferenceWrite', { bg = c.word_hi })
hi('LspInlayHint',      { fg = c.comment, italic = true })
hi('@lsp.type.comment',   { link = 'Comment' })
hi('@lsp.type.string',    { link = 'String' })
hi('@lsp.type.number',    { link = 'Number' })
hi('@lsp.type.keyword',   { link = 'Keyword' })
hi('@lsp.type.function',  { link = 'Function' })
hi('@lsp.type.variable',  { link = 'Identifier' })
hi('@lsp.type.parameter', { link = 'Identifier' })
hi('@lsp.type.namespace', { link = 'Type' })
hi('@lsp.type.type',      { link = 'Type' })
hi('@lsp.type.class',     { link = 'Type' })
hi('@lsp.type.enum',      { link = 'Type' })
hi('@lsp.type.decorator', { link = 'Function' })

-- ── Treesitter ───────────────────────────────────────────────────────────
hi('@comment',          { link = 'Comment' })
hi('@string',           { link = 'String' })
hi('@number',           { link = 'Number' })
hi('@boolean',          { link = 'Boolean' })
hi('@constant',         { link = 'Constant' })
hi('@constant.builtin', { link = 'Boolean' })
hi('@variable',         { link = 'Identifier' })
hi('@variable.builtin', { fg = c.sand })   -- constant.language
hi('@function',         { link = 'Function' })
hi('@function.builtin', { link = 'Function' })
hi('@function.call',    { link = 'Function' })
hi('@method',           { link = 'Function' })
hi('@keyword',          { link = 'Keyword' })
hi('@keyword.import',   { fg = c.green })  -- keyword.control.import
hi('@operator',         { link = 'Operator' })
hi('@type',             { link = 'Type' })
hi('@type.builtin',     { link = 'Type' })
hi('@namespace',        { link = 'Type' })
hi('@tag',              { link = 'Tag' })
hi('@attribute',        { fg = c.grey9 })  -- entity.other.attribute-name
hi('@punctuation.bracket',   { link = 'Delimiter' })
hi('@punctuation.delimiter', { link = 'Delimiter' })
hi('markdownH1', { link = 'Title' })
hi('markdownH2', { link = 'Title' })
hi('markdownCode', { fg = c.grey6 })
hi('markdownCodeBlock', { fg = c.grey6 })

-- ── Diff/Git ─────────────────────────────────────────────────────────────
hi('diffAdded',   { fg = c.green })
hi('diffRemoved', { fg = c.error })
hi('diffChanged', { fg = c.warn })
hi('diffOldFile', { fg = c.grey6 })
hi('diffNewFile', { fg = c.fg_input })
hi('DiffAdd',     { bg = c.find_rng })
hi('DiffDelete',  { fg = c.error, bg = c.bg_inactive })
hi('DiffChange',  { bg = c.find_hi })
hi('DiffText',    { bg = c.word_hi })
hi('GitSignsAdd',    { fg = c.green })
hi('GitSignsChange', { fg = c.warn })
hi('GitSignsDelete', { fg = c.error })

-- ── Плагины ──────────────────────────────────────────────────────────────
hi('TelescopeBorder',    { link = 'FloatBorder' })
hi('TelescopeTitle',     { link = 'FloatTitle' })
hi('TelescopeSelection', { link = 'PmenuSel' })
hi('TelescopeMatching',  { fg = c.cursor, bold = true })
hi('FzfLuaBorder',       { link = 'FloatBorder' })
hi('FzfLuaTitle',        { link = 'FloatTitle' })
hi('WhichKey',           { link = 'Keyword' })
hi('WhichKeyDesc',       { link = 'Identifier' })
hi('WhichKeyGroup',      { link = 'Type' })
