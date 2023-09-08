luafile $DOTFILES/vim/plugins/fterm.lua
nnoremap <C-f><C-g> :lua _G.__fterm_gitui()<CR>
nnoremap <C-f><C-i> :lua _G.__fterm_issues()<CR>
nnoremap <C-f><C-p> :lua _G.__fterm_pbSummary()<CR>
nnoremap <C-f><C-t> :lua require("FTerm").toggle()<CR>
nnoremap <leader>pip :lua _G.__fterm_pipInstall()<CR>
