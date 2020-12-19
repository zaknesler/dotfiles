so ~/.vim/plugins.vim

"--------- General ----------"
syntax on

set backspace=indent,eol,start              "Make backspace perform like any other editor
let mapleader=','                           "Change default leader to a comma instead of a backslash


"---------- Visuals ----------"
colorscheme atom-dark				                "Change the default colorscheme
set guifont=Operator\ Mono\ Book:h14		    "Set default font face and size
set linespace=10				                    "Set line spacing to a reasonable level
set number					                        "Activate line numbers

set guioptions-=l                           "Disable left-hand scrollbars
set guioptions-=L				                    "Disable left-hand scrollbars when split
set guioptions-=r				                    "Disable right-hand scrollbars
set guioptions-=R				                    "Disable right-hand scrollbars when split

set guioptions-=e				                    "Disable custom gui tabs

"Highlighting
hi vertsplit guifg=bg guibg=bg


"---------- Splits ----------"
set splitbelow					                    "Create horizontal splits below current window
set splitright					                    "Create vertical splits to the right of current window

"Shortcuts to switch window splits
nmap <C-H> <C-W><C-H>
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-L> <C-W><C-L>


"---------- Searching ----------"
set hlsearch					                      "Highlight search results
set incsearch					                      "Highlight search results whilst typing query


"---------- Mappings ----------"
"Shortcut to edit vimrc file
nmap <Leader>ev :tabedit $MYVIMRC<cr>

"Remove highlighting
nmap <Leader><space> :nohlsearch<cr>


"---------- Auto-Commands ----------"
"Automatically source the vimrc file on save
augroup autosourcing
    autocmd!
    autocmd BufWritePost .vimrc source %
augroup end


"---------- Plugin Overrides ----------"
"/
"/ CtrlP
"/
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'   "Exclude folders from results

"Allow the use of Cmd+P for CtrlP
nmap <D-p> :CtrlP<cr>

"Search for tags
nmap <D-r> :CtrlPBufTag<cr>

"Show recently used files
nmap <D-e> :CtrlPMRUFiles<cr>


"/
"/ Nerd Tree
"/
let NERDTreeHijackNetrw = 0					        "Disallow Nerdtree from hijacking hyphen

"Add shortcut for nerd tree
nmap <D-1> :NERDTreeToggle<cr>


"---------- Other ----------"
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif