"
" Navigation
"

set mouse=a " recognize mouse commands in all modes
set number " line numbers

"
" NERDTree
"

" Always open NERDTree
autocmd VimEnter * NERDTree

" Focus on file
autocmd VimEnter * wincmd p

" Open on the left
let g:NERDTreeWinPos = "left" 

" Quit vim if NERDTree is last and only buffer
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
