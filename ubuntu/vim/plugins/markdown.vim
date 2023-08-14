" " ==== markdown-syntax
" autocmd BufNewFile,BufRead *.{md,mark*} set filetype=markdown
" let g:vim_markdown_folding_disabled=1
" let g:vim_markdown_override_foldtext=0
" let g:vim_markdown_folding_level=6
" let g:vim_markdown_toc_autofit=1
" let g:vim_markdown_conceal=0
" let g:tex_conceal=""
" let g:vim_markdown_math=1
"
" " ==== markdown-preview
let g:mkdp_auto_start = 0
let g:mkdp_auto_close = 0
let g:mkdp_page_title = "${name}"
"
" ==== pandoc
" let g:pandoc#syntax#codeblocks#embeds#use = 1
" let g:pandoc#syntax#codeblocks#embeds#langs = [ 'python', 'vim', 'c', 'bash', 'sql', 'csv']
" let g:pandoc#syntax#conceal#urls = 1

" ==== tpope/markdown
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'sql']
let g:markdown_minlines = 50
