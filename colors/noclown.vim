" noclown
"
" A mostly color free theme with a goal of not making your code look like a
" clown threw up.
"
" Propaganda:
" -- Visual clutter saps mental energy.
"
" * http://www.linusakesson.net/programming/syntaxhighlighting/
" * http://kyleisom.net/blog/2012/10/17/syntax-off/
" * https://www.robertmelton.com/2016/04/10/syntax-highlighting-off/
"
" PUBLIC DOMAIN
" To the extent possible under law, Berk D. Demir has waived all copyright and
" related or neighboring rights to noclown color scheme for Vim.
" This work is published from: United States.


highlight clear
if exists('syntax_on')
  syntax reset
endif
let g:colors_name = 'noclown'

" Terminals that don't support italics, resort to rendering them as standout.
" For comments and other things we italicize, this can become annoying very
" quickly.  We are going to ignore 'italic' attribute if the terminal doesn't
" know about it.
if (has('gui_running') ||
      \ has('unix') && system('tput sitm') ==# "\e[3m")
  let g:noclown_has_italics = 1
endif

let s:palette = {
      \ 'foreground' : [250, '#dcdcdc'],
      \ 'background' : [233, '#141414'],
      \ 'fade'       : [246, '#949494'],
      \ 'fade-more'  : [238, '#444444'],
      \ 'highlight'  : [230, '#ffffd7'],
      \ 'attention'  : [224, '#ffd7d7'],
      \ 'error'      : [203, '#ff5f5f'],
      \ 'special'    : [223, '#f5deb0'],
      \ 'orange'     : [209, '#f0975f'],
      \ 'dkgreen'    : [114, '#9cc48e'],
      \ 'black'      : [16,  '#000000'],
      \ }

function! s:fg(name)
  let [l:ctermfg, l:guifg] = s:palette[a:name]
  return {'ctermfg': l:ctermfg, 'guifg': l:guifg}
endfunction

function! s:bg(name)
  let [l:ctermfg, l:guifg] = s:palette[a:name]
  return {'ctermbg': l:ctermfg, 'guibg': l:guifg}
endfunction

function! s:attr(...)
  let l:alist = a:000

  if !exists('g:noclown_has_italics')
    " We're going to modify the list, so make a copy (a:* are immutable)
    let l:alist = copy(a:000)
    call filter(l:alist, "v:val !=# 'italic'")
  endif

  " l:attrs: comma separated 'l:alist' as string or if empty: 'NONE'
  let l:attrs = empty(l:alist) ? 'NONE' : join(l:alist, ',')

  return {'term': l:attrs, 'cterm': l:attrs, 'gui': l:attrs}
  "return {'cterm': l:attrs }
endfunction

" Clear every attribute to NONE to avoid inheriting from default colorscheme.
let s:hi_clear = {}
for s:key in ['term', 'cterm', 'ctermfg', 'ctermbg', 'gui', 'guifg', 'guibg']
  let s:hi_clear[s:key] = 'NONE'
endfor

function! s:Defn(group, ...)
  let l:hi_dict = copy(s:hi_clear)

  " Merge attribute group definitions to main dictionary
  for l:setting in a:000
    call extend(l:hi_dict, l:setting)
  endfor

  let l:hi_expr = 'highlight ' . a:group  . ' '
  " Convert { k1: v1, k2: v2, ..., kn: vn} dictionary to 'k1=v1 k2=v2 ... kn=vn' string
  let l:hi_expr .= join(map(items(l:hi_dict), "join(v:val, '=')"), ' ')

  execute l:hi_expr
endfunction

function! s:None(group)
  execute 'highlight ' . a:group . ' NONE'
endfunction

function! s:Link(from, to)
  call s:None(a:from)
  execute 'highlight link ' . a:from . ' ' . a:to
endfunction

" Suggested group names from naming conventions -- ':h E669'
" Оранжево-зелёные акценты поверх серой базы
call s:Defn('Comment', s:fg('fade'), s:attr('italic'))
call s:Defn('Function', s:fg('orange'))
call s:Defn('Operator', s:fg('special'))
call s:Defn('PreProc', s:fg('dkgreen')) "<- Include Define Macro PreCondit
call s:Defn('String', s:fg('dkgreen'))
call s:Defn('Character', s:fg('dkgreen'))
call s:Defn('Number', s:fg('orange'))
call s:Defn('Boolean', s:fg('orange'))
call s:Defn('Float', s:fg('orange'))
call s:Defn('Statement', s:fg('dkgreen')) "<- Conditional Repeat Label Operator Keyword Exception
call s:Defn('Type', s:fg('dkgreen')) "<- StorageClass Structure Typedef
call s:Defn('Special', s:fg('orange')) "<- SpecialChar Tag Delimiter SpecialComment Debug
" Имена классов — цветом функций
call s:Defn('@type', s:fg('orange'))
" legacy-синтаксис (когда treesitter не активен)
call s:Defn('pythonClass', s:fg('orange'))
call s:Defn('Identifier', s:fg('foreground'))
call s:Defn('Constant', s:fg('foreground'))
" self/cls и прочие переменные из treesitter — цвет базового текста
call s:Defn('@variable', s:fg('foreground'))
call s:Defn('@variable.builtin', s:fg('foreground'))
call s:Defn('Underlined', s:attr('underline'))
call s:Defn('Ignore', s:fg('fade-more'))
call s:Defn('Error', s:fg('error'))
call s:Defn('Todo', s:attr('reverse'))

" Default group names -- ':h highlight-default'
call s:Defn('Normal', s:fg('foreground'), s:bg('background'))

call s:Defn('SpecialKey', s:fg('fade'))
call s:Defn('NonText', s:fg('fade-more'))
call s:Link('LineNr', 'NonText')
call s:Link('CursorLineNr', 'SpecialKey')
call s:None('CursorLine')

call s:Defn('VertSplit', s:fg('fade'), s:bg('fade-more'))

call s:Defn('StatusLine', s:attr('reverse'))
call s:Link('StatusLineNC', 'VertSplit')
call s:Defn('StatusLineTerm', s:fg('attention'), s:attr('reverse'))
call s:Defn('StatusLineTermNC', s:fg('attention'), s:bg('fade-more'))
call s:Defn('Visual', s:attr('reverse'))
call s:Defn('MatchParen', s:fg('attention'), s:bg('fade-more'))

call s:Defn('Title', s:fg('highlight'))  " titles for output from ':set all', ':autocmd' etc.
call s:Link('Question', 'Title')
call s:Link('MoreMsg', 'Title')
call s:Link('IncSearch', 'Title')
call s:Defn('Search', s:fg('highlight'), s:attr('reverse'))
call s:Link('WildMenu', 'Search')

call s:Defn('WarningMsg', s:fg('attention'))
call s:Defn('ErrorMsg', s:fg('error'))

call s:Defn('Pmenu', s:bg('fade-more'))
call s:Defn('PMenuSel', s:fg('highlight'), s:bg('fade'))
call s:Defn('PMenuSbar', s:fg('fade'), s:bg('fade'))
call s:Defn('PMenuThumb', s:fg('fade'), s:bg('highlight'))

call s:Defn('NormalFloat', s:fg('foreground'), s:bg('black'))
call s:Defn('FloatBorder', s:fg('fade'), s:bg('black'))
call s:Link('FloatTitle', 'Title')
call s:Link('FloatFooter', 'FloatBorder')

call s:Defn('SpellBad', s:fg('attention'), s:attr('italic'))
call s:Link('SpellCap', 'Underlined')
call s:Link('SpellLocal', 'SpellCap')
call s:Link('SpellRare', 'SpellCap')

call s:Defn('Folded', s:fg('highlight'), s:bg('fade'))
call s:Defn('FoldColumn', s:fg('highlight'), s:bg('fade-more'))

call s:Defn('DiffAdd', s:attr('bold'), s:bg('fade-more'))
call s:Defn('DiffChange', s:bg('fade-more'))
call s:Defn('DiffDelete', s:fg('error'), s:bg('fade-more'))
call s:Defn('DiffText', s:bg('attention'), s:fg('background'))

" QuickFix
call s:Defn('qfFileName', s:fg('fade'))

""""
""" Unmodified groups from default group names list.
""" They retain their colorscheme from Vim's defaults.
"""
"ColorColumn	used for the columns set with 'colorcolumn'
"Conceal		placeholder characters substituted for concealed
"		text (see 'conceallevel')
"Cursor		the character under the cursor
"CursorIM	like Cursor, but used when in IME mode |CursorIM|
"CursorColumn	the screen column that the cursor is in when 'cursorcolumn' is
"		set
"Directory	directory names (and other special names in listings)
"EndOfBuffer	filler lines (~) after the last line in the buffer.
"		By default, this is highlighted like |hl-NonText|.
"SignColumn	column where |signs| are displayed
"ModeMsg		'showmode' message (e.g., "-- INSERT --")
"TabLine		tab pages line, not active tab page label
"TabLineFill	tab pages line, where there are no labels
"TabLineSel	tab pages line, active tab page label
"VisualNOS	Visual mode selection when vim is "Not Owning the Selection".
"		Only X11 Gui's |gui-x11| and |xterm-clipboard| supports this.

"""
" Highlight debugging helpers
"""
function! s:HighlightGroupChain()
  " Return the names in syntax identifier chain for the symbol under cursor.
  " Chain is a '->' delimited string of linked syntax identifier names from
  " leaf to root.
  let l:chain = []
  let l:leaf_id = synID(line('.'), col('.'), 1)
  let l:leaf_name = synIDattr(l:leaf_id, 'name')
  let l:root_name = synIDattr(synIDtrans(l:leaf_id), 'name')

  call add(l:chain, l:leaf_name)

  while len(l:chain) < 10  " highlight group linking is prone to loops
    redir => l:hi_output | execute 'silent! highlight ' . l:leaf_name | redir END
    let l:matches = matchlist(l:hi_output, '\vxxx links to (\w+)$')
    if len(l:matches) > 0
      let l:leaf_name = l:matches[1]
      call add(l:chain, l:leaf_name)
    else
      " highlight group doesn't link to anything. done following links.
      break
    endif
  endwhile

  if l:chain[-1] != l:root_name
    call add(l:chain, '...')
    call add(l:chain, l:root_name)
  endif

  return join(l:chain, '->')
endfunction

" Colors for Telescope
hi link TelescopeSelection TermCursor

" Colors for debugging (nvim-dap): яркие метки breakpoint/текущей строки
highlight DapBreakpoint          guifg=#e35b5b ctermfg=203
highlight DapBreakpointCondition guifg=#e3a13b ctermfg=215
highlight DapBreakpointRejected  guifg=#6b6b6b ctermfg=243
highlight DapLogPoint            guifg=#5bb8e3 ctermfg=75
highlight DapStopped             guifg=#ffb638 ctermfg=215 gui=bold cterm=bold
highlight debugPC                guibg=#3d3223 ctermbg=237
nmap <Plug>(noclown-echo-highlight-group-chain) :echo <SID>HighlightGroupChain()<CR>
