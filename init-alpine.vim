" Minimal Neovim config for Alpine/iSH (Neovim 0.4.x compatible)
" No plugin manager, just essential settings

" --- Basic Settings ---
set number                    " Show line numbers
set relativenumber            " Relative line numbers
set mouse=a                   " Enable mouse support
set clipboard=unnamedplus     " Use system clipboard
set expandtab                 " Use spaces instead of tabs
set tabstop=2                 " Tab width
set shiftwidth=2              " Indent width
set softtabstop=2             " Tab in insert mode
set autoindent                " Auto indent
set smartindent               " Smart indent
set wrap                      " Wrap lines
set ignorecase                " Case insensitive search
set smartcase                 " But case sensitive if uppercase present
set hlsearch                  " Highlight search results
set incsearch                 " Incremental search
set scrolloff=8               " Keep 8 lines above/below cursor
set signcolumn=yes            " Always show sign column
set updatetime=300            " Faster completion
set hidden                    " Allow hidden buffers
set nobackup                  " No backup files
set nowritebackup             " No backup before overwriting
set undofile                  " Persistent undo
set termguicolors             " True color support

" --- Leader Key ---
let mapleader = " "

" --- Basic Keymaps ---
" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Clear search highlight
nnoremap <leader>h :nohlsearch<CR>

" Better indenting in visual mode
vnoremap < <gv
vnoremap > >gv

" Move text up and down
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Save with Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Quit shortcuts
nnoremap <leader>q :q<CR>
nnoremap <leader>Q :qa!<CR>

" File explorer
nnoremap <leader>e :Explore<CR>

" --- Status Line ---
set laststatus=2
set statusline=
set statusline+=\ %f
set statusline+=\ %m
set statusline+=%=
set statusline+=\ %y
set statusline+=\ %l:%c
set statusline+=\ %p%%

" --- Color Scheme ---
" Use built-in color scheme (no plugins needed)
try
  colorscheme desert
catch
  colorscheme default
endtry

" --- Auto Commands ---
augroup AutoSave
  autocmd!
  " Remove trailing whitespace on save
  autocmd BufWritePre * :%s/\s\+$//e
augroup END

" Show message that config loaded
echo "Minimal Neovim config loaded (Alpine/iSH compatible)"
