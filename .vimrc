set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'Vimjas/vim-python-pep8-indent'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tmhedberg/SimpylFold'
Plugin 'Valloric/YouCompleteMe'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'mileszs/ack.vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'fatih/vim-go'
Plugin 'Xuyuanp/nerdtree-git-plugin'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

set visualbell
imap jk <Esc>
set encoding=utf-8
set incsearch
syntax on

" fixing gutter colors
" https://github.com/airblade/vim-gitgutter/issues/164
colorscheme solarized
set background=dark
highlight clear SignColumn
highlight GitGutterAdd ctermbg=Black
highlight GitGutterChange ctermbg=Black
highlight GitGutterDelete ctermbg=Black
highlight GitGutterChangeDelete ctermbg=Black

" line numbers
set number
set relativenumber

" tabs
filetype plugin indent on
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set fileformat=unix
set backspace=indent,eol,start

" splits
set splitbelow
set splitright

" folds (za to fold/unfold)
set foldmethod=indent
set foldlevel=99

" python
au BufNewFile,BufRead *.py
    \ set textwidth=119

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__']

" CtrlP
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|\.pyc\|target'

" YCM
let g:ycm_python_binary_path = '/Users/riskingh/.pyenv/shims/python'
autocmd FileType python nnoremap <leader>g :YcmCompleter GoToDeclaration<CR>
autocmd FileType rust nnoremap <leader>g :YcmCompleter GoToDeclaration<CR>
autocmd FileType rust nnoremap <leader>d :YcmCompleter GetDoc<CR>
let g:ycm_auto_hover=''
let g:ycm_filetype_blacklist = {'go': 1}

" gitgutter
let g:gitgutter_log=1

" custom
function! CopyRelativePath()
    let @+ = expand("%")
endfunction
nnoremap <leader>p :call CopyRelativePath()<CR>

nnoremap <leader>b :CtrlPBookmarkDir<CR>

let g:go_def_mode = 'gopls'
autocmd FileType go nnoremap <leader>g :GoDef <CR>
