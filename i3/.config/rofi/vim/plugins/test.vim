
" let test#javascript#jest#options = '--color=always'
" let test#strategy = 'harpoon'
" let g:test#harpoon_term = 5
" let test#strategy = 'vimspectorpy'

let test#python#pytest#options = '--ff -v -p no:warnings'
nnoremap <silent> <leader>tn :TestNearest<CR>
nnoremap <silent> <leader>tnp:TestNearest --pdb<CR>
nnoremap <silent> <leader>tf :TestFile<CR>
nnoremap <silent> <leader>ts :TestSuite<CR>
nnoremap <silent> <leader>tl :TestLast<CR>
nnoremap <silent> <leader>tg :TestVisit<CR>

" let g:ultest_use_pty = 1
" let g:ultest_output_on_line = 0

" augroup UltestRunner
"     au!
"     au BufWritePost test_*.py UltestNearest
" augroup END

" nmap ]t <Plug>(ultest-next-fail)
" nmap [t <Plug>(ultest-prev-fail)

" nnoremap <C-u><C-n> :UltestNearest<cr>
" nnoremap <C-u><C-t> :Ultest<cr>
" nnoremap <C-u><C-s> :UltestSummary<cr>
" nnoremap <C-u><C-o> :UltestOutput<cr>
" nnoremap <C-u><C-h> :UltestAttach<cr>


