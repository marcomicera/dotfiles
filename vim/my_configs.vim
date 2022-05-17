" Tabs instead of spaces
set noexpandtab

"
" Navigation
"

set mouse=a " recognize mouse commands in all modes
set number " line numbers

"
" NERDTree
"

" Show hidden files
let NERDTreeShowHidden=1

" Always open NERDTree
autocmd VimEnter * NERDTree

" Focus on file
autocmd VimEnter * wincmd p

" Open on the left
let g:NERDTreeWinPos = "left" 

" Quit vim if NERDTree is last and only buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"
" Syntax highlighting
"

augroup twig_ft
  au!
  autocmd BufNewFile,BufRead ~/.kube/config set syntax=yaml
  autocmd BufNewFile,BufRead *Jenkinsfile set syntax=groovy
augroup END
