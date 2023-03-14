lua require('yode-nvim').setup({})
vnoremap <leader>yc :YodeCreateSeditorFloating<CR>
nnoremap <leader>yc <cmd>YodeCreateSeditorFloating<CR>
map <leader>yr <cmd>YodeCreateSeditorReplace<CR>
" these commands fall back to overwritten keys when cursor is in split window
map <C-W>r :YodeLayoutShiftWinDown<CR>
map <C-W>R :YodeLayoutShiftWinUp<CR>
map <C-W>J :YodeLayoutShiftWinBottom<CR>
map <C-W>K :YodeLayoutShiftWinTop<CR>
" at the moment this is needed to have no gap for floating windows
set showtabline=2
