vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

opt.relativenumber = true
opt.number = true

-- tbas & indentation
opt.tabstop =  4 --4 spaces for tabs
opt.shiftwidth = 2 --2 spaces for indent width
opt.expandtab = true -- expand tabs to spaces
opt.autoindent = true --keep the same indent for the next line 

opt.wrap = true
opt.cursorline = false

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if includes mixed case in search, assumes you want case sensitive result


--theme settings
opt.termguicolors = true --addapts to the terminal color
opt.background = "dark" -- chooses the color theme if possible 

opt.signcolumn = "no" -- show the sign column so that the text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, EOL and on start of insert

--clipboard
opt.clipboard:append("unnamedplus") -- use system clipbooard as a default register

--split windows
opt.splitright = true -- split vertical window to right
opt.splitbelow = true -- split horizontal window to the bottom



