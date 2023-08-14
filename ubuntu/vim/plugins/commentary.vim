" ==== commentary
" autocmd FileType markdown setlocal commentstring=<!--\ %s\ -->
" autocmd FileType matlab setlocal commentstring=%\ %s
" autocmd FileType cfg setlocal commentstring=#\ %s
" autocmd FileType sh setlocal commentstring=#\ %s
" autocmd FileType bash setlocal commentstring=#\ %s
" autocmd FileType yaml setlocal commentstring=#\ %s
" autocmd FileType ini setlocal commentstring=#\ %s

" ==== comment.nvim
"
lua require('Comment').setup()

