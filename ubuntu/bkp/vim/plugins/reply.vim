" ==== reply.vim
nnoremap <leader>x <cmd>ReplSend<cr>
vnoremap <leader>x <cmd>ReplSend<cr>

let g:reply_repls = {
      \   'python': ['ipython'],
      \ }
