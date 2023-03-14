let g:neoformat_python_black = {
            \ 'exe': 'black',
            \ 'args': ['-l79'],
            \ 'replace': 1,
            \ 'stdin': 1,
            \ 'valid_exit_codes': [0, 23],
            \ 'no_append': 1,
            \ }

let g:neoformat_enabled_python = ['black']
" Enable alignment
let g:neoformat_basic_format_align = 1

" Enable tab to spaces conversion
let g:neoformat_basic_format_retab = 0

" Enable trimmming of trailing whitespace
let g:neoformat_basic_format_trim = 1

let g:neoformat_try_node_exe = 1
