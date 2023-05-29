let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_enable_snippet = 'vim-vsnip'
set completeopt=menuone,noinsert,noselect

luafile $DOTFILES/vim/plugins/lsp.lua

nnoremap K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap gr <cmd>lua vim.lsp.buf.rename()<CR>

nnoremap <leader>gd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>gi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>gh :lua vim.lsp.buf.signature_help()<CR>

nnoremap <leader>gf :lua vim.lsp.buf.references()<CR>

nnoremap <leader>ga :lua vim.lsp.buf.code_action()<CR>

" nnoremap <leader>sd :lua vim.lsp.util.show_line_diagnostics(); vim.lsp.util.show_line_diagnostics()<CR>
" nnoremap <leader>vn :lua vim.lsp.diagnostic.goto_next()<CR>
" nnoremap <leader>vll :lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <leader>dq <cmd>lua vim.lsp.diagnostic.set_loclist()<CR>
nnoremap <leader>dn <cmd>lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>dp <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
