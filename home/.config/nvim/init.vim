set number
set cursorline
highlight clear cursorline
highlight cursorlinenr cterm=none ctermfg=black ctermbg=gray

set expandtab
set tabstop=2
set shiftwidth=2

set ignorecase
set smartcase
set wrapscan
set hlsearch
map <esc><esc> :nohlsearch<cr><esc>

set list
set listchars=tab:^-,trail:-,nbsp:%

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,cp932,sjis,euc-jp
set fileformats=unix,mac,dos

set conceallevel=0

set scrolloff=5

let g:vim_markdown_folding_disabled = 1
let g:previm_enable_realtime = 0
let g:previm_disable_default_css = 1
let g:previm_custom_css_path = '~/.local/share/resources/css/github-markdown-css/github-markdown.css'

