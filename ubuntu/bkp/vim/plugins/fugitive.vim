" === fugitive

" ==== fugitive-gitlab
" let g:fugitive_gitlab_domains = ['https://' . $GITLAB_ETS_URI]
" let g:gitlab_api_keys = {$GITLAB_PERSONAL_URI : $GITLAB_PERSONAL_TOKEN, $GITLAB_ETS_URI: $GITLAB_ETS_TOKEN}

" ==== git
" nnoremap <leader>grum :Git rebase upstream/master<CR>
" nnoremap <leader>grom :Git rebase origin/master<CR>
" nnoremap <C-g><C-l> :diffget //3<CR> " get left change
" nnoremap <C-g><C-h> :diffget //2<CR> " get right change
"
nnoremap <leader>w :Git<cr>
nnoremap <C-g><C-t> :Git push<CR>
nnoremap <C-g><C-f> :Git fetch<CR>
nnoremap <C-g><C-b> :Git pull<CR>
nnoremap <C-g> :GBrowse<cr>
vnoremap <C-g> :GBrowse<cr>
vnoremap <leader>yg :GBrowse!<cr>
nnoremap <leader>yg :GBrowse!<cr>
