" ==== slimux
let g:slimux_tmux_path="/usr/local/bin/tmux"
let g:slime_target="tmux"
"let maplocalleader="\<space>"
let g:slimux_select_from_current_window = 1
let g:slimux_python_use_ipython=1
let g:slimux_python_press_enter = 1

nnoremap <Leader>e :SlimuxREPLSendLine<CR><esc>j
vnoremap <Leader>e :SlimuxREPLSendSelection<CR><esc>`[v`]<cr><ESC>
nnoremap <Leader>r :SlimuxGlobalConfigure<CR>

nnoremap <leader>cO O%%<esc>:norm gcc<cr>j
nnoremap <leader>co o%%<esc>:norm gcc<cr>k
nnoremap <leader>c- O<esc>77i-<esc>:norm gcc<cr>j

nnoremap <leader>ck ?%%<cr>
nnoremap <leader>cj /%%<cr>

nnoremap <leader>cl V/%%<cr>k:'<,'>SlimuxREPLSendSelection<cr>nn
nnoremap <leader>cc V/%%<cr>k:'<,'>SlimuxREPLSendSelection<cr>
