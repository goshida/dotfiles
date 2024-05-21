
vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.fileencodings = 'utf-8', 'iso-2022-jp', 'cp932', 'euc-jp'
vim.opt.fileformats = 'unix', 'mac', 'dos'

vim.opt.number = true
vim.opt.cursorline = true

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

vim.opt.scrolloff = 5

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true
vim.opt.hlsearch = true
vim.keymap.set( 'n',  '<Esc><Esc>' , ':nohlsearch<CR>' )

vim.opt.list = true
vim.opt.listchars = {
  tab = '^-',
  trail = '-',
  nbsp = '%'
}

vim.opt.conceallevel = 0
vim.opt.concealcursor = ''

vim.opt.mouse = ''

vim.api.nvim_set_hl( 0, 'CursorLineNr', { fg="#000000", bg="#888888" } )

-- Plugins variable

-- Netrw
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3
vim.g.netrw_altv = 1
vim.g.netrw_alto = 1

-- PreVim
vim.g.vim_markdown_folding_disabled = 1
vim.g.previm_enable_realtime = 0
vim.g.previm_disable_default_css = 1
vim.g.previm_custom_css_path = '~/.local/share/resources/css/github-markdown-css/github-markdown.css'

