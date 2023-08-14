" ==== vim-workspace
let g:workspace_autosave_always = 0
let g:workspace_persist_undo_history = 1  " enabled = 1 (default), disabled = 0
let g:workspace_undodir='.undodir'
let g:workspace_session_disable_on_args = 1
let g:workspace_session_name = 'Session.vim'
nnoremap <leader>S :ToggleWorkspace<CR>
