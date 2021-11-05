fun! OpenScrum()
    split /home/mgreco/gitlab/mgreco/scrums/latest.md
    lcd /home/mgreco/gitlab/mgreco/scrums/
    nnoremap <buffer> q :w\|bdelete!<CR>
endfun
nnoremap <leader>tpb :silent !call OpenScrum()<cr>

fun! OpenTodo()
    vsplit /home/mgreco/.TODO.md
    lcd /home/mgreco/
    nnoremap <buffer> q :w\|bdelete!<CR>
endfun
nnoremap <leader>ttd :silent !call OpenTodo()<cr>

" ==== minimal
fun! TurnOnGuides()
    set rnu
    set nu
    set signcolumn=yes
    set colorcolumn=80
endfun

fun! TurnOffGuides()
    set nornu
    set nonu
    set signcolumn=no
    set colorcolumn=800
endfun

nnoremap <leader>ao :call TurnOnGuides()<cr>
nnoremap <leader>ae :call TurnOffGuides()<cr>

augroup minimal
    autocmd!
    autocmd FileType *\(^\(netrw\|help\)\)\@<! :call TurnOnGuides()
    autocmd FileType netrw,help :call TurnOffGuides()
augroup END

function! AsArgsClass()
    " from:
    "    aaa
    " to:
    "    self.aaa = aaa
    let @x=":s\/\\([a-z_0-9]*\\),\\?\\n\/self.\\1 = \\1\\r\/g\r:nohlsearch\r"
    @x
endfunction
vnoremap <leader>aac :<c-u>call AsArgsClass()<CR>

function! AsKwargs()
    " from:
    "    aaa
    " to:
    "     aaa=aaa,
    let @y=":s\/\\([a-z_0-9]*\\),\\?\\n\/\\1=\\1,\\r\/g\r:nohlsearch\r"
    @y
endfunction
vnoremap <leader>akw :<c-u>call AsKwargs()<CR>

function! SwapEqual()
    " from
    "     aaa = bbb
    " to
    "     bbb = aaa
    let @z=":s\/\\(\\s*\\)\\([a-z._0-9]*\\) = \\([a-z_0-9]*\\)\/\\1\\3 = \\2/g\r:nohlsearch\r"
    @z
endfunction
vnoremap <leader>swe :<c-u>call SwapEqual()<CR>

function! BuildComposer(info)
  if a:info.status != 'unchanged' || a:info.force
    !cargo build --release
    UpdateRemotePlugins
  endif
endfunction

" ==== latex
function! Latexize()
   :silent !pdflatex ./report.tex --output-directory=./tmp
   :silent !bibtex ./report
   :silent !makeindex report.idx
   :silent !pdflatex ./report.tex --output-directory=./tmp
   :redraw!
endfunction

" ==== show maps
" https://stackoverflow.com/questions/24842063/how-to-search-in-the-vim-mapping-listing
function! s:ShowMaps()
    let old_reg = getreg("a")          " save the current content of register a
    let old_reg_type = getregtype("a") " save the type of the register as well
    try
        redir @a                           " redirect output to register a
        " Get the list of all key mappings silently, satisfy "Press ENTER to continue"
        silent map | call feedkeys("\<CR>")
        redir END                          " end output redirection
        vnew                               " new buffer in vertical window
        setlocal nobuflisted noswapfile buftype=nofile bufhidden=delete"
        nnoremap <buffer> Q :bdelete!<cr>"
        put a                              " put content of register
        " Sort on 4th character column which is the key(s)
        %!sort -k1.4,1.4
    finally                              " Execute even if exception is raised
        call setreg("a", old_reg, old_reg_type) " restore register a
    endtry
endfunction

com! ShowMaps call s:ShowMaps()      " Enable :ShowMaps to call the function
nnoremap \\ :ShowMaps<CR>            " Map keys to call the function

nnoremap <leader>c :call ToggleColumnWidth()<cr>
let g:wide_column = 0
function! ToggleColumnWidth()
    if g:wide_column
        set textwidth=79
        set colorcolumn=79
        let g:wide_column = 0
    else
        set textwidth=119
        set colorcolumn=119
        let g:wide_column = 1
    endif
endfunction

