" ==== telescope
luafile $DOTFILES/vim/plugins/telescope.lua

" search only on git files
nnoremap <C-p> <cmd>lua require('telescope.builtin').git_files()<CR>
" find buffers
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<CR>
" project buffers
nnoremap <leader>pb <cmd>lua require('telescope.builtin').buffers()<CR>
" find files
nnoremap <leader>lg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap <leader>fg <cmd>lua require('telescope').mmngreco.no_preview()<CR>

" find help
nnoremap <leader>fk <cmd>lua require('telescope.builtin').keymaps()<CR>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<CR>
" nnoremap <leader>fh <cmd>Telescope help_tags<CR>
" project find
nnoremap <Leader>ff <cmd>lua require('telescope').mmngreco.find_files()<CR>
" nnoremap <leader>ff <cmd>Telescope find_files<CR>
" project search grep
nnoremap <leader>ps <cmd>lua require('telescope.builtin').grep_string({ search = vim.fn.input("Grep For > ")})<CR>
" project word
nnoremap <leader>pw <cmd>lua require('telescope.builtin').grep_string { search = vim.fn.expand("<cword>") }<CR>
" view help tags
nnoremap <leader>th <cmd>lua require('telescope.builtin').help_tags()<CR>
nnoremap <leader>sc <cmd>lua require('telescope').mmngreco.search_scio()<CR>
" search on dotfiles
nnoremap <leader>dot <cmd>lua require('telescope').mmngreco.search_dotfiles()<CR>
" mat files
nnoremap <leader>mat <cmd>lua require('telescope').mmngreco.search_matlab()<CR>

nnoremap <leader>gwt <cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>

nnoremap <leader>gc <cmd>lua require('telescope').mmngreco.git_branches()<CR>
nnoremap <leader>gsh <cmd>lua require('telescope.builtin').git_stash()<CR>

