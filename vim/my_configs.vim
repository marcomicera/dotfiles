" Tabs instead of spaces
set noexpandtab

"
" Navigation
"

set mouse=a " recognize mouse commands in all modes
set number " line numbers

" Set the working directory to the current file's directory
autocmd BufEnter * lcd %:p:h

"
" NERDTree
"

" Show hidden files
let NERDTreeShowHidden=1

" Start NERDTree and put the cursor back in the other window
autocmd VimEnter * NERDTree | wincmd p

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
  autocmd BufNewFile,BufRead ~/.functions set syntax=bash
  autocmd BufNewFile,BufRead ~/.aliases set syntax=bash
  autocmd BufNewFile,BufRead ~/.work set syntax=bash
augroup END
