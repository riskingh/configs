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
Plugin 'rust-lang/rust.vim'
Plugin 'yuezk/vim-js'
Plugin 'maxmellon/vim-jsx-pretty'


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
" set background=light
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

" rust
autocmd FileType rust nnoremap <leader>r :Cargo run<CR>

" js
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2

" md
au BufNewFile,BufRead *.md
    \ set textwidth=80

" NERDTree
map <C-n> :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$', '\.egg-info$', '__pycache__']

" CtrlP
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|\.pyc\|target'
let g:ctrlp_mruf_relative = 1

" YCM
let g:ycm_python_binary_path = '/home/risk/.pyenv/shims/python'
autocmd FileType python nnoremap <leader>g :YcmCompleter GoToDeclaration<CR>
autocmd FileType python nnoremap <leader>d :YcmCompleter GetDoc<CR>
autocmd FileType rust nnoremap <leader>g :YcmCompleter GoTo<CR>
autocmd FileType rust nnoremap <leader>d :YcmCompleter GetDoc<CR>
let g:ycm_auto_hover=''
let g:ycm_filetype_blacklist = {'go': 1, 'markdown': 1}

" gitgutter
let g:gitgutter_log=0

" custom
function! CopyRelativePath()
    let @+ = expand("%")
endfunction
nnoremap <leader>p :call CopyRelativePath()<CR>

function! CopyRelativeDirPath()
    let @+ = system("dirname " . expand("%"))
endfunction
nnoremap <leader>o :call CopyRelativeDirPath()<CR>


nnoremap <leader>b :CtrlPBookmarkDir<CR>

let g:go_def_mode = 'gopls'
let g:go_build_tags = 'wireinject'
autocmd FileType go nnoremap <leader>g :GoDef <CR>
autocmd FileType go nnoremap <leader>d :GoDoc <CR>
autocmd FileType go nnoremap <leader>a :GoAlternate <CR>

" proto
autocmd FileType proto setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab

" GPG
augroup encrypted
  au!

  " First make sure nothing is written to ~/.viminfo while editing
  " an encrypted file.
  autocmd BufReadPre,FileReadPre *.gpg set viminfo=
  " We don't want a various options which write unencrypted data to disk
  autocmd BufReadPre,FileReadPre *.gpg set noswapfile noundofile nobackup

  " Switch to binary mode to read the encrypted file
  autocmd BufReadPre,FileReadPre *.gpg set bin
  autocmd BufReadPre,FileReadPre *.gpg let ch_save = &ch|set ch=2
  " (If you use tcsh, you may need to alter this line.)
  autocmd BufReadPost,FileReadPost *.gpg '[,']!gpg --decrypt 2> /dev/null

  " Switch to normal mode for editing
  autocmd BufReadPost,FileReadPost *.gpg set nobin
  autocmd BufReadPost,FileReadPost *.gpg let &ch = ch_save|unlet ch_save
  autocmd BufReadPost,FileReadPost *.gpg execute ":doautocmd BufReadPost " . expand("%:r")

  " Convert all text to encrypted text before writing
  " (If you use tcsh, you may need to alter this line.)
  autocmd BufWritePre,FileWritePre *.gpg '[,']!gpg --default-recipient-self -ae 2>/dev/null
  " Undo the encryption so we are back in the normal text, directly
  " after the file has been written.
  autocmd BufWritePost,FileWritePost *.gpg u
augroup END

" fzf
set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf


"
" zerion stuff start
"
function! GoNewWire(typeName)
  let l:interfaceName = a:typeName
  let l:structName = 'Basic' . a:typeName

  " Insert the boilerplate code
  call append(line('.'), 'type ' . l:interfaceName . ' interface{}')
  call append(line('.') + 1, '')
  call append(line('.') + 2, 'var ' . l:structName . 'Module = wire.NewSet(')
  call append(line('.') + 3, '	New' . l:structName . ',')
  call append(line('.') + 4, '	wire.Bind(new(' . l:interfaceName . '), new(*' . l:structName . ')),')
  call append(line('.') + 5, ')')
  call append(line('.') + 6, '')
  call append(line('.') + 7, 'type ' . l:structName . ' struct{}')
  call append(line('.') + 8, '')
  call append(line('.') + 9, 'var _ ' . l:interfaceName . ' = (*' . l:structName . ')(nil)')
  call append(line('.') + 10, '')
  call append(line('.') + 11, 'func New' . l:structName . '() *' . l:structName . ' {')
  call append(line('.') + 12, '	return &' . l:structName . '{}')
  call append(line('.') + 13, '}')
endfunction

command! -nargs=1 GoNewWire call GoNewWire(<q-args>)
"
" zerion stuff end
"
