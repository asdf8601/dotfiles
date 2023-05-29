" ==== nerdtree
" hi Directory guifg=#a8d2eb guibg=NONE
let NERDTreeIgnore=['__pycache__']
let NERDTreeHijackNetrw = 0
let NERDTreeShowBookmarks = 1 " Display bookmarks on startup.
nnoremap <silent> <Leader>nf :NERDTreeFind<cr>
nnoremap <leader>nt :NERDTreeToggle<Enter>
