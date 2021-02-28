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

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
"if dein#check_install()
"  call dein#install()
"endif

"End dein Scripts-------------------------

filetype
syntax enable

set number relativenumber
set expandtab
set tabstop=2
set expandtab
set ruler
set colorcolumn=110

