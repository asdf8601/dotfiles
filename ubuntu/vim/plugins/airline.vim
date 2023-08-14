" ==== airline status bar
" airline issue : bar dissapear and appears again on nerdtree or ctags win.
" https://github.com/vim-airline/vim-airline/issues/501#issuecomment-42324550
" set laststatus=2
let g:airline_highlighting_cache = 1
let g:airline_skip_empty_sections = 1
let g:lightline = {
      \ 'colorscheme': 'wombat',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }
      " \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
