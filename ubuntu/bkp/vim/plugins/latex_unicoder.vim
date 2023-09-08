" ==== latex unicoder
let g:unicoder_cancel_normal = 1
let g:unicoder_cancel_insert = 1
let g:unicoder_cancel_visual = 1
nnoremap <F3> :call unicoder#start(0)<CR>
inoremap <F3> <Esc>:call unicoder#start(1)<CR>
vnoremap <F3> :<C-u>call unicoder#selection()<CR>
