"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/zg/.vim/bundles/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/zg/.vim/bundles/dein')
  call dein#begin('/home/zg/.vim/bundles/dein')

  " Let dein manage dein
  " Required:
  call dein#add('/home/zg/.vim/bundles/dein/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  
  " Functional Utils
  call dein#add('tpope/vim-fugitive')
  
  " Look'n'Feel
  call dein#add('Shougo/vimshell')
  call dein#add('scrooloose/nerdtree')
  call dein#add('airblade/vim-gitgutter')
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('itchyny/lightline.vim') 
  call dein#add('mhinz/vim-startify') 
  call dein#add('joshdick/onedark.vim') 
  call dein#add('equalsraf/neovim-gui-shim') 
  call dein#add('majutsushi/tagbar') 
  call dein#add('ap/vim-buftabline') 
  
  " Lang Support
  call dein#add('digitaltoad/vim-pug') 
  call dein#add('waved/vim-stylus') 
  call dein#add('') 
  call dein#add('') 

  " File Tree
  call dein#add('lambdalisue/fern.vim') 

" Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

set number relativenumber
set expandtab 
set tabstop=2
set expandtab 
set colorcolumn=110


