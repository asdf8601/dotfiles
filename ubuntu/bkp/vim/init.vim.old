" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/.venv/*
set wildignore+=**/venv/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*

" set ttymouse=xterm2
set mouse=
set cursorline
" set mouse=nv

if exists('g:started_by_firenvim')
  set laststatus=0
else
  set laststatus=3
endif

let loaded_matchparen = 1  " allow usage of local vimrc in projects
let mapleader = " "

let g:python3_host_prog = 'python3'
let g:loaded_python_provider = 1
let g:loaded_ruby_provider = 0
let g:loaded_perl_provider = 0

call plug#begin()

Plug 'romainl/vim-qf'
Plug 'RRethy/vim-illuminate'

Plug 'francoiscabrol/ranger.vim' | Plug 'rbgrouleff/bclose.vim'
Plug 'nvim-neorg/neorg' | Plug 'nvim-lua/plenary.nvim'
Plug 'pwntester/octo.nvim'
" Plug 'stevearc/gkeep.nvim', { 'do': ':UpdateRemotePlugins' }


Plug 'folke/noice.nvim'
Plug 'rcarriga/nvim-notify'
Plug 'MunifTanjim/nui.nvim'

if !exists('g:started_by_firenvim')
Plug 'jpalardy/vim-slime'
Plug 'Klafyvel/vim-slime-cells'
end

Plug 'akinsho/bufferline.nvim', { 'tag': 'v2.*' }
" Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}
" Plug 'psf/black', { 'branch': 'stable' }
Plug 'nvim-orgmode/orgmode'

Plug 'waylonwalker/Telegraph.nvim'
Plug 'nvim-telescope/telescope-symbols.nvim'
Plug 'tpope/vim-tbone'
" Plug 'mrjones2014/legendary.nvim'
" Plug 'liuchengxu/vista.vim'
" Plug 'phaazon/mind.nvim'
Plug 'rafalbromirski/vim-aurora'
Plug 'fatih/vim-go'

" Plug 'skanehira/denops-docker.vim'
" Plug 'vim-denops/denops.vim'
" Vim Script
" Plug 'AndrewRadev/exercism.vim'
" Plug 'jbyuki/nabla.nvim'
" Plug 'folke/trouble.nvim'
Plug 'sbdchd/neoformat'
" Plug 'alec-gibson/nvim-tetris'
" Plug 'sunjon/shade.nvim'
Plug 'tversteeg/registers.nvim', { 'branch': 'main' }

" TODO change to luasnip
" Plug 'L3MON4D3/LuaSnip'

" Plug 'ckipp01/nvim-jenkinsfile-linter'
Plug 'tmhedberg/SimpylFold'
Plug 'Konfekt/FastFold'
" Plug 'willchao612/vim-diagon'
" Plug 'aquach/vim-mediawiki-editor'
Plug 'cespare/vim-toml'
" Plug 'chipsenkbeil/distant.nvim'
Plug 'chrisbra/csv.vim'
" Plug 'chrisbra/unicode.vim'
" Plug 'christoomey/vim-tmux-navigator'
Plug 'dhruvasagar/vim-table-mode'
Plug 'gko/vim-coloresque'  " show color of an color expression (hex, rgb)
Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
Plug 'godlygeek/tabular'
Plug 'goerz/jupytext.vim'
Plug 'gyim/vim-boxdraw'
Plug 'hoob3rt/lualine.nvim'
" Plug 'hoschi/yode-nvim'

Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
Plug 'hrsh7th/cmp-nvim-lua'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}

Plug 'itchyny/calendar.vim'
" Plug 'johngrib/vim-game-code-break'
" Plug 'joom/latex-unicoder.vim'
Plug 'kristijanhusak/vim-carbon-now-sh'
Plug 'kyazdani42/nvim-web-devicons'
" Plug 'lambdalisue/suda.vim'
Plug 'lervag/vimtex'
Plug 'majutsushi/tagbar'
Plug 'lvht/tagbar-markdown'
Plug 'mattn/emmet-vim'
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'mbbill/undotree'
" Plug 'mboughaba/i3config.vim'
" Plug 'Microsoft/vscode-python'
" Plug 'mmngreco/dbee.nvim'
" Plug 'mmngreco/DrawIt'
" Plug 'mmngreco/slimux'
" Plug 'mzlogin/vim-markdown-toc', { 'for': 'markdown'}

Plug 'neovim/nvim-lspconfig'
Plug 'numToStr/Comment.nvim'
Plug 'nvie/vim-flake8'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
" Plug 'nvim-telescope/telescope-media-files.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
" Plug pangloss/vim-javascript'
" Plug 'puremourning/vimspector'

" Plug 'rcarriga/nvim-dap-ui'
" Plug 'mfussenegger/nvim-dap'

" Plug 'neomake/neomake'
" Plug 'radenling/vim-dispatch-neovim'
" Plug 'rcarriga/vim-ultest', { 'do': ':UpdateRemotePlugins' }
"
" Plug 'rhysd/reply.vim', { 'on': ['Repl', 'ReplAuto'] }
" Plug 'numtostr/FTerm.nvim'
" Plug 'sillybun/vim-repl'
"
" Plug 'ruanyl/vim-gh-line'
"
" === colorscheme
Plug 'catppuccin/nvim', {'as': 'catppuccin'}
" Plug 'gruvbox-community/gruvbox'
" Plug 'flazz/vim-colorschemes'
" Plug 'chriskempson/base16-vim'
" Plug 'sainnhe/gruvbox-material'

Plug 'sbdchd/neoformat'
" Plug 'Scuilion/markdown-drawer', { 'for': 'markdown'}
" Plug 'Shougo/neoinclude.vim', { 'for': 'cpp' }
Plug 'shumphrey/fugitive-gitlab.vim' " allow open gitlab url
" Plug 'simrat39/symbols-outline.nvim'
" Plug 'stevearc/vim-arduino', { 'for': 'ino' }
Plug 'szw/vim-maximizer'
" Plug 'thaerkh/vim-workspace'
Plug 'ThePrimeagen/git-worktree.nvim'
Plug 'ThePrimeagen/harpoon'
Plug 'ThePrimeagen/refactoring.nvim'
" Plug 'ThePrimeagen/vim-be-good'

Plug 'kristijanhusak/vim-dadbod-ui'
"
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-dadbod'  " database interface
Plug 'tpope/vim-dispatch'  " compiler + make = dispatch
Plug 'tpope/vim-fugitive'  " offers git commands in vim
Plug 'tpope/vim-markdown'
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-rhubarb'  " allow open github urls
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'  " better netrw
Plug 'tweekmonster/impsort.vim'  " color and sort imports
Plug 'tyru/open-browser.vim'
" Plug 'vim-pandoc/vim-pandoc'
" Plug 'vim-pandoc/vim-pandoc-syntax'
" Plug 'vim-test/vim-test'

" Plug 'vim-utils/vim-man'
" Plug 'vuciv/vim-bujo'  " todos
"
Plug 'wellle/targets.vim'  " text wrapper: cin,
Plug 'williamboman/nvim-lsp-installer'
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

call plug#end()



" ==== custom settings
" syntax on " Enable syntax highlighting.
" " dissabling syntax highlighting when it's a diff
" if &diff
"     syntax off
" endif

" filetype plugin indent on  " Enable file type based indentation.
" filetype plugin on

" let g:python_host_prog = $PYTHON_NEOVIM

" color theme
" https://github.com/awesome-streamers/awesome-streamerrc
" https://shorturl.at/cxUX3
" let g:my_colorscheme = "ayu"
" let g:my_colorscheme = "catppuccin"
" let g:my_colorscheme = "gruvbox"
" fun! ColorMyPencils()
"     let g:gruvbox_contrast_dark = 'hard'
"     if exists('+termguicolors')
"         let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"         let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
"     endif
"     let g:gruvbox_invert_selection='0'
"
"     set background=dark
"     if has('nvim')
"         call luaeval('vim.cmd("colorscheme " .. _A[1])', [g:my_colorscheme])
"     else
"         " TODO: What the way to use g:my_colorscheme
"         colorscheme gruvbox
"     endif
"
"     highlight ColorColumn ctermbg=0 guibg=grey
"     hi SignColumn guibg=none
"     hi CursorLineNR guibg=None
"     highlight Normal guibg=none
"
"     highlight CursorLine term=bold cterm=bold guibg=Grey40
"     highlight NonText ctermbg=none
"     highlight Normal  ctermbg=none
"
"     " highlight LineNr guifg=#ff8659
"     " highlight LineNr guifg=#aed75f
"     highlight netrwDir guifg=#5eacd3
"     highlight qfFileName guifg=#aed75f
"     highlight NonText guifg=#5eacd3
" for gruvbox
" hi tklink ctermfg=72 guifg=#689d6a cterm=bold,underline gui=bold,underline
" hi tkBrackets ctermfg=gray guifg=gray
"     hi TelescopeBorder guifg=#5eacd3
" endfun
" call ColorMyPencils()


" Vim with me
" nnoremap <leader>vwm :call ColorMyPencils()<CR>
" nnoremap <leader>vwb :let g:my_colorscheme =

nnoremap H :bp<cr>
nnoremap L :bn<cr>
nnoremap <silent> <Plug>RandNorm :read! python3 -c "import random; print(random.gauss(0, 1))"<cr> \ :call repeat#set("\<Plug>RandNorm", v:count)<cr>
nmap <C-g><C-r> <Plug>RandNorm



" tnoremap <leader>q :wqa<cr>


" underline current line
nnoremap <leader>tu <esc>Vypv$r-

" edit ini.vim
nnoremap <leader>rc <cmd>tabedit ~/.config/nvim/init.vim<CR>

" reload vimrc
nnoremap <leader><CR> <cmd>so ~/.config/nvim/init.vim<CR>

" exit from terminal mode
tnoremap <Esc> <C-\><C-n>

" resize window
nnoremap <leader>+ :vertical resize +10<CR>
nnoremap <leader>- :vertical resize -10<CR>

" maximizes current window
nnoremap <leader>rp :resize 100<CR>

" add bash dead shbang!
nnoremap <leader>sh :1<cr>O#!/usr/bin/env bash<esc>

" ==== todo list
command! Gtodo noautocmd vimgrep /TODO\|FIXME\|!!!\|???\|NOBUG\|HACK\|IDEA\|TODOC\|BUG\|XXX/j **/*.{py,md,txt} | cw

" task boxes
nnoremap <leader>ta I- [ ]<space><esc>
nnoremap <leader>tx :s/- \[ \?\]/- [x]/<CR>

" get help
nnoremap <leader>ghw :h <C-R>=expand("<cword>")<CR><CR>

nnoremap <leader>glg :Git log -G "def <C-r><C-w>"

" searches
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
nnoremap <leader>fw <cmd>vimgrep <cword> ./** .deps/** <cr>
nnoremap <leader>bs /<C-R>=escape(expand("<cWORD>"), "/")<CR><CR>
nnoremap <leader>u :UndotreeShow<CR>

" explore with netrw
nnoremap <leader>pv :Ex %:h<CR>

" snippets in pure vim
"
" nnoremap <Leader>ee oif err != nil {<CR>log.Fatalf("%+v\n", err)<CR>}<CR><esc>kkI<esc>
" nnoremap <Leader>cpu a%" PRIu64 "<esc>
nnoremap <leader>dow :put =strftime(\"## %A %Y-%m-%d\")<cr><esc>j
nnoremap <leader>ddt :put =strftime(\"%Y-%m-%d\ttt\tww\tbb\tcc\")<cr><esc>

" yank/paste
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
" paste last copied/yanked
nnoremap <leader>pl "0p
vnoremap <leader>p "_dP
nnoremap <leader>Y y$
nnoremap <leader>YY gg"+yG

" nnoremap <leader>d "_d
" vnoremap <leader>d "_d
" yank current file's path
nnoremap <leader>yf :let @+ = expand("%:p")<cr>

fun! EmptyRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
endfun

" common typo
com! W w
cabbrev q!@ q!
cabbrev wq!@ wq!
cabbrev w2 w


" ==== theprimeagen
" https://www.youtube.com/watch?v=hSHATqh8svM

nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

inoremap , ,<c-g>u
inoremap . .<c-g>u
inoremap ! !<c-g>u
inoremap ? ?<c-g>u

inoremap <Left> <c-g>U<Left>
inoremap <Right> <c-g>U<Right>

" smart replace
nnoremap <leader>s :%s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>
nnoremap gs :%s//g<left><left>
" nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
" nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" moves selected lines down/up
"
" below is commented due to problems with {{cookiecutter}} directories
" set wildignorecase
"
" select previous selection
noremap gV `[v`]

" I don't use below very often and but I do use J to join many lines
" vnoremap J :m '>+1<CR>gv=gv
" vnoremap K :m '<-2<CR>gv=gv
" https://vi.stackexchange.com/a/14683
inoremap <c-j> <esc>:.m+1 \| startinsert<cr>
inoremap <c-k> <esc>:.m-2 \| startinsert<cr>
nnoremap <leader>k :m .-2<cr>==
nnoremap <leader>j :m .+1<cr>==

nnoremap <leader>cn :cnext<cr>
nnoremap <leader>cp :cprev<cr>
nnoremap <leader>gls :let g:_search_term = expand("%")<CR><bar>:Gclog -- %<CR>:call search(g:_search_term)<cr>
nnoremap <leader>gln :cnext<cr>:call search(g:_search_term)<cr>
nnoremap <leader>glp :cprev<cr>:call search(g:_search_term)<cr>


" sort numerically according 2nd column
nnoremap <leader>sn :'<,'>!sort -n -k 2
" Sort lines in alphabetical order
vnoremap <leader>s :'<,'>!sort -f<cr>

augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require('vim.highlight').on_yank({timeout = 40})
augroup END

augroup mmngreco
    autocmd!
    " unfold by default
    " autocmd BufRead * normal zR
    " removes spaces at the end of a line
    autocmd BufWritePre * %s/\s\+$//e
    autocmd BufWritePre *.go GoFmt
    autocmd BufEnter *.dbout norm zR

    " autocmd BufEnter,BufWinEnter,TabEnter *.rs,*.py :lua require'lsp_extensions'.inlay_hints{}
    autocmd FileType markdown setl conceallevel=2 spl=en,es
    " makefiles indentation
    autocmd FileType make setl noexpandtab shiftwidth=4 softtabstop=0

    " ==== python
    " fix wrong over indent
    " autocmd FileType python setl indentexp=GetPythonIndent(v:lnum)-4

    " remove numbers from terminal buffer
    autocmd TermOpen * setl nonumber norelativenumber

    " autocmd FileType python nnoremap <buffer> [[ ?^class\\|^\s*def<CR>
    " autocmd FileType python nnoremap <buffer> ]] /^class\\|^\s*def<CR>
augroup END

augroup black_stuff
    autocmd!
    " https://github.com/psf/black/issues/1293#issuecomment-623237094
    autocmd FileType python nnoremap <buffer> <F8> :silent !black -l79 -S %<CR><CR>
    " autocmd FileType python vnoremap <buffer> <F8> :silent !black -l79 -S %<CR><CR>
    " autocmd BufWritePre *.py :!black -l79 -S % -q
augroup end

" ==== source plugin conf
"
" source $DOTFILES/vim/plugins/distant.vim
source $DOTFILES/vim/plugins/sets.vim
source $DOTFILES/vim/plugins/netrw.vim
source $DOTFILES/vim/plugins/functions.vim

" source $DOTFILES/vim/plugins/arduino.vim
" source $DOTFILES/vim/plugins/bujo.vim
source $DOTFILES/vim/plugins/carbon.vim
source $DOTFILES/vim/plugins/commentary.vim
" source $DOTFILES/vim/plugins/dbee.vim
" source $DOTFILES/vim/plugins/drawit.vim
source $DOTFILES/vim/plugins/fugitive.vim
source $DOTFILES/vim/plugins/harpoon.vim
source $DOTFILES/vim/plugins/impsort.vim
source $DOTFILES/vim/plugins/jupytext.vim
source $DOTFILES/vim/plugins/lsp.vim
source $DOTFILES/vim/plugins/lualine.vim
source $DOTFILES/vim/plugins/markdown.vim
source $DOTFILES/vim/plugins/navegation.vim
source $DOTFILES/vim/plugins/neoformat.vim
source $DOTFILES/vim/plugins/pydocstring.vim
" source $DOTFILES/vim/plugins/slimux.vim
if !exists('g:started_by_firenvim')
    source $DOTFILES/vim/plugins/slime.vim
endif
source $DOTFILES/vim/plugins/tagbar.vim
source $DOTFILES/vim/plugins/telescope.vim
source $DOTFILES/vim/plugins/test.vim
source $DOTFILES/vim/plugins/vimspector.vim
source $DOTFILES/vim/plugins/firenvim.vim
source $DOTFILES/vim/plugins/vsnip.vim
" source $DOTFILES/vim/plugins/workspace.vim
" source $DOTFILES/vim/plugins/yode.vim

lua require'nvim-treesitter.configs'.setup { indent = { enable = false }, highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}
let g:user_emmet_settings = {
            \ 'svelte' : { 'extends' : 'html', },
            \}

nnoremap <c-s> :SymbolsOutline<cr>

command! -range -nargs=0 Space2Tab execute '<line1>,<line2>s#\(\s\+\)#\t#g'

function! Cwd() abort
    return fnamemodify(getcwd(), ':t')
endfunction


" === live preview
let g:livepreview_engine = 'xelatex'
let g:livepreview_previewer = 'evince'
" let g:vimtex_compiler_generic = 'xelatex'
let g:vimtex_compiler_latexmk_engines = {
            \ '_'                : '-xelatex',
            \}

" let g:tmux_navigator_no_mappings = 1
" nnoremap <silent> <leader>h :TmuxNavigateLeft<cr>
" nnoremap <silent> <leader>j :TmuxNavigateDown<cr>
" nnoremap <silent> <leader>k :TmuxNavigateUp<cr>
" nnoremap <silent> <leader>l :TmuxNavigateRight<cr>
" nnoremap <silent> <leader>ll :TmuxNavigatePrevious<cr>
" nnoremap  <c-t><c-s> :Telescope tmux sessions<cr>
" go substitute because the default map for sleeping is silly

" format sql parse
vn <leader>sf :!sqlformat -k upper -r -<cr>

nn <leader>cal :Calendar -view=year -split=vertical -width=27 -first_day=monday<cr>
nn <leader>day :Calendar -first_day=monday<cr>

nnoremap <leader>m :MaximizerToggle!<CR>


" ============================================================================
" === diagon : diagram
" noremap <Leader>D :Diagon<Space>
" noremap <Leader>dm :Diagon Math<CR>
" noremap <Leader>ds :Diagon Sequence<CR>
" noremap <Leader>dt :Diagon Tree<CR>


" ============================================================================
" === fold
nmap zuz <Plug>(FastFoldUpdate)
let g:fastfold_savehook = 1
let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
let g:markdown_folding = 1
let g:rst_fold_enabled = 1
let g:tex_fold_enabled = 1
let g:vimsyn_folding = 'af'
let g:xml_syntax_folding = 1
let g:javaScript_fold = 1
let g:sh_fold_enabled= 7
let g:zsh_fold_enable = 1
let g:ruby_fold = 1
let g:perl_fold = 1
let g:perl_fold_blocks = 1
let g:r_syntax_folding = 1
let g:rust_fold = 1
let g:python_fold = 1
let g:php_folding = 1
let g:fortran_fold=1
let g:clojure_fold = 1
let g:baan_fold=1
augroup Fold
    autocmd!
    autocmd FileType python setlocal foldmethod=indent
augroup END

let g:SimpylFold_docstring_preview = 0
let g:SimpylFold_fold_docstring = 0
let b:SimpylFold_fold_docstring = 0
let g:SimpylFold_fold_import = 0
let b:SimpylFold_fold_import = 0
let g:SimpylFold_fold_blank = 0
let b:SimpylFold_fold_blank = 0

" ============================================================================
" " === trouble
" lua << EOF
" require("trouble").setup {
"     -- your configuration comes here
"     -- or leave it empty to use the default settings
"     -- refer to the configuration section below
"   }
" EOF
"
" nnoremap <leader>xx <cmd>TroubleToggle<cr>
" nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
" nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
" nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
" nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
" nnoremap gR <cmd>TroubleToggle lsp_references<cr>


" ============================================================================
" === shade
" lua << EOF
" require('shade').setup({
"   overlay_opacity = 50,
"   opacity_step = 1,
"   keys = {
"         brightness_up    = '<C-Up>',
"         brightness_down  = '<C-Down>',
"         toggle           = '<Leader>t',
"       }
"     })
" EOF
"
"
" nnoremap <leader>p :lua require("nabla").popup()<CR>
" nnoremap <leader>asc :let s = system(join(["asciiTeX", '"', getline('.'), '"'])) | echo s<cr>

lua << EOF
require'nvim-web-devicons'.setup {
    default = true;
    }
EOF


" === refactoring
lua << EOF
require('refactoring').setup({
prompt_func_return_type = {
    go = false,
    java = false,

    cpp = false,
    c = false,
    h = false,
    hpp = false,
    cxx = false,
    },
prompt_func_param_type = {
    go = false,
    java = false,

    cpp = false,
    c = false,
    h = false,
    hpp = false,
    cxx = false,
    },
printf_statements = {},
print_var_statements = {},
})
-- Remaps for the refactoring operations currently offered by the plugin
vim.api.nvim_set_keymap("v", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

-- Extract block doesn't need visual mode
vim.api.nvim_set_keymap("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("n", "<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], {noremap = true, silent = true, expr = false})

-- Inline variable can also pick up the identifier currently under the cursor without visual mode
vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})

EOF



lua <<EOF
require("indent_blankline").setup {
show_current_context = true,
show_current_context_start = true,
}
EOF


" === mind
" lua <<EOF
" require("mind").setup()
" EOF



" " === bufferline
" lua <<EOF
" vim.opt.termguicolors = true
" require("bufferline").setup{}
" EOF

" " === symbols-outline
" lua <<EOF
" require("symbols-outline").setup()
" EOF

" === catputccin
" let g:catppuccin_flavour = "frappe" " latte, frappe, macchiato, mocha
" let g:catppuccin_flavour = "macchiato" " latte, frappe, macchiato, mocha
let g:catppuccin_flavour = "mocha" " latte, frappe, macchiato, mocha

lua << EOF
-- require("catppuccin").setup()
require("catppuccin").setup({
    transparent_background = false,
    term_colors = false,
    compile = {
        enabled = false,
        path = vim.fn.stdpath("cache") .. "/catppuccin",
    },
    dim_inactive = {
        enabled = false,
        shade = "dark",
        percentage = 0.15,
    },
    styles = {
    comments = {},
    conditionals = {},
    loops = {},
    functions = {},
    keywords = {},
    strings = {},
    variables = {},
    numbers = {},
    booleans = {},
    properties = {},
    types = {},
    operators = {},
    },
    integrations = {
    -- For various plugins integrations see https://github.com/catppuccin/nvim#integrations
        treesitter = true,
    },
    color_overrides = {},
    highlight_overrides = {},
})
EOF

" colorscheme
set termguicolors
colorscheme catppuccin

" let g:gruvbox_material_foreground = 'original'
" let g:gruvbox_material_background = 'hard'
" let g:gruvbox_material_better_performance = 1
" let g:gruvbox_material_disable_italic_comment = 1
" let g:gruvbox_material_enable_bold = 0
" let g:gruvbox_material_transparent_background = 1
" colorscheme gruvbox-material
" :lua require'lualine'.setup {options = {theme = 'gruvbox-material'}}
" highlight ColorColumn ctermbg=0 guibg=grey
" hi SignColumn guibg=none
" hi CursorLineNR guibg=None
" highlight Normal guibg=none
" highlight CursorLine term=bold cterm=bold guibg=Grey40
" highlight NonText ctermbg=none
" highlight Normal  ctermbg=none
" highlight LineNr guifg=#5eacd3
" " highlight LineNr guifg=#ff8659
" " highlight LineNr guifg=#aed75f
" highlight netrwDir guifg=#5eacd3
" highlight qfFileName guifg=#aed75f
" highlight NonText guifg=#5eacd3
" " for gruvbox
" hi tklink ctermfg=72 guifg=#689d6a cterm=bold,underline gui=bold,underline
" hi tkBrackets ctermfg=gray guifg=gray
" hi TelescopeBorder guifg=#5eacd3


lua <<EOF
vim.notify = require("notify")
EOF


" lua <<EOF
" require'bufferline'.setup{
"     highlights = {
"         buffer_selected = {
"             bold = false,
"             italic = false,
"         },
"         numbers_selected = {
"             bold = false,
"             italic = false,
"         },
"         diagnostic_selected = {
"             bold = false,
"             italic = false,
"         },
"         hint_selected = {
"             bold = false,
"             italic = false,
"         },
"         hint_diagnostic_selected = {
"             bold = false,
"             italic = false,
"         },
"         info_selected = {
"             bold = false,
"             italic = false,
"         },
"         info_diagnostic_selected = {
"             bold = false,
"             italic = false,
"         },
"         warning_selected = {
"             bold = false,
"             italic = false,
"         },
"         warning_diagnostic_selected = {
"             bold = false,
"             italic = false,
"         },
"         error_selected = {
"             bold = false,
"             italic = false,
"         },
"         error_diagnostic_selected = {
"             bold = false,
"             italic = false,
"         },
"         duplicate_selected = {
"             italic = false,
"         },
"         duplicate_visible = {
"             italic = false
"         },
"         duplicate = {
"             italic = false
"         },
"         pick_selected = {
"             bold = false,
"             italic = false,
"         },
"         pick_visible = {
"             bold = false,
"             italic = false,
"         },
"         pick = {
"             bold = false,
"             italic = false,
"         },
"     };
" }
" EOF
"

" === repl
" let g:repl_predefine_python = {
"             \   'np': 'import numpy as np',
"             \   'pd': 'import pandas as pd',
"             \   'plt': 'from matplotlib import pyplot as plt'
"             \   }
" let g:repl_cursor_down = 1
" let g:repl_python_automerge = 1
" " let g:repl_ipython_version = '7'
" let g:repl_output_copy_to_register = "t"
" let g:repl_position = 3
" " let g:repl_python_pre_launch_command = 'source .autoenv'
" nnoremap <leader>tr :REPLToggle<cr>
" nnoremap <leader>e :REPLSendSession<cr>
" autocmd Filetype python nnoremap <F1> <Esc>:REPLDebugStopAtCurrentLine<cr>
" autocmd Filetype python nnoremap <F2> <Esc>:REPLPDBN<cr>
" autocmd Filetype python nnoremap <F3> <Esc>:REPLPDBS<cr>
"
" let g:repl_sendvariable_template = {
"             \ 'python': 'print(<input>)',
"             \ 'ipython': 'print(<input>)',
"             \ 'ptpython': 'print(<input>)',
"             \ }
" let g:repl_program = {
" 			\	'python': ['python'],
" 			\	'default': ['bash']
" 			\	}
"
"
autocmd! FileType dbui nmap <buffer> <leader>w <Plug>(DBUI_SaveQuery)
autocmd! FileType dbui setl nonumber norelativenumber
nnoremap <leader>sq <Plug>(DBUI_SaveQuery)
" nnoremap <silent> `` :nohlsearch<CR>:call minimap#vim#ClearColorSearch()<CR>


" init.vim
lua << EOF
-- Load custom tree-sitter grammar for org filetype
require('orgmode').setup_ts_grammar()
-- Tree-sitter configuration
require'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'org'}, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}
require('orgmode').setup({
  org_agenda_files = {'/mnt/google-drive/org/*', '~/orgs/**/*'},
  org_default_notes_file = '/mnt/google-drive/org/notes.org',
  org_hide_leading_stars = true,
})
EOF


" lua <<EOF
" local noice = require("noice")
" noice.setup({
"   cmdline = {
"     enabled = true, -- enables the Noice cmdline UI
"     view = "cmdline_popup", -- view for rendering the cmdline. Change to `cmdline` to get a classic cmdline at the bottom
"     opts = {}, -- extra opts for the cmdline view. See section on views
"     ---@type table<string, CmdlineFormat>
"     format = {
"       -- conceal: (default=true) This will hide the text in the cmdline that matches the pattern.
"       -- view: (default is cmdline view)
"       -- opts: any options passed to the view
"       -- icon_hl_group: optional hl_group for the icon
"       cmdline = { pattern = "^:", icon = ":", lang = "vim" },
"       search_down = { kind = "search", pattern = "^/", icon = " ", lang = "regex" },
"       search_up = { kind = "search", pattern = "^%?", icon = " ", lang = "regex" },
"       filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
"       lua = { pattern = "^:%s*lua%s+", icon = "", lang = "lua" },
"       help = { pattern = "^:%s*h%s+", icon = "" },
"       -- lua = false, -- to disable a format, set to `false`
"     },
"   },
"
"   notify = {
"     -- Noice can be used as `vim.notify` so you can route any notification like other messages
"     -- Notification messages have their level and other properties set.
"     -- event is always "notify" and kind can be any log level as a string
"     -- The default routes will forward notifications to nvim-notify
"     -- Benefit of using Noice for this is the routing and consistent history view
"     enabled = true,
"     view = "notify",
"   },
"   lsp_progress = {
"     enabled = true,
"     -- Lsp Progress is formatted using the builtins for lsp_progress. See config.format.builtin
"     -- See the section on formatting for more details on how to customize.
"     --- @type NoiceFormat|string
"     format = "lsp_progress",
"     --- @type NoiceFormat|string
"     format_done = "lsp_progress_done",
"     throttle = 1000 / 30, -- frequency to update lsp progress message
"     view = "mini",
"   },
"   throttle = 1000 / 30, -- how frequently does Noice need to check for ui updates? This has no effect when in blocking mode.
"   ---@type NoiceConfigViews
"   views = {}, ---@see section on views
"   ---@type NoiceRouteConfig[]
"   routes = {}, --- @see section on routes
"   ---@type table<string, NoiceFilter>
"   status = {}, --- @see section on statusline components
"   ---@type NoiceFormatOptions
"   format = {}, --- @see section on formatting
" })
" EOF


lua <<EOL
require"octo".setup({
  default_remote = {"upstream", "origin"}; -- order to try remotes
  ssh_aliases = {},                        -- SSH aliases. e.g. `ssh_aliases = {["github.com-work"] = "github.com"}`
  reaction_viewer_hint_icon = "";         -- marker for user reactions
  user_icon = " ";                        -- user icon
  timeline_marker = "";                   -- timeline marker
  timeline_indent = "2";                   -- timeline indentation
  right_bubble_delimiter = "";            -- bubble delimiter
  left_bubble_delimiter = "";             -- bubble delimiter
  github_hostname = "";                    -- GitHub Enterprise host
  snippet_context_lines = 4;               -- number or lines around commented lines
  issues = {
    order_by = {                           -- criteria to sort results of `Octo issue list`
      field = "CREATED_AT",                -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
      direction = "DESC"                   -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
    }
  },
  pull_requests = {
    order_by = {                           -- criteria to sort the results of `Octo pr list`
      field = "CREATED_AT",                -- either COMMENTS, CREATED_AT or UPDATED_AT (https://docs.github.com/en/graphql/reference/enums#issueorderfield)
      direction = "DESC"                   -- either DESC or ASC (https://docs.github.com/en/graphql/reference/enums#orderdirection)
    },
    always_select_remote_on_create = "false" -- always give prompt to select base remote repo when creating PRs
  },
  file_panel = {
    size = 10,                             -- changed files panel rows
    use_icons = true                       -- use web-devicons in file panel (if false, nvim-web-devicons does not need to be installed)
  },
  mappings = {
    issue = {
      close_issue = { lhs = "<space>ic", desc = "close issue" },
      reopen_issue = { lhs = "<space>io", desc = "reopen issue" },
      list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
      reload = { lhs = "<C-r>", desc = "reload issue" },
      open_in_browser = { lhs = "<C-b>", desc = "open issue in browser" },
      copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
      add_assignee = { lhs = "<space>aa", desc = "add assignee" },
      remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
      create_label = { lhs = "<space>lc", desc = "create label" },
      add_label = { lhs = "<space>la", desc = "add label" },
      remove_label = { lhs = "<space>ld", desc = "remove label" },
      goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
      add_comment = { lhs = "<space>ca", desc = "add comment" },
      delete_comment = { lhs = "<space>cd", desc = "delete comment" },
      next_comment = { lhs = "]c", desc = "go to next comment" },
      prev_comment = { lhs = "[c", desc = "go to previous comment" },
      react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
      react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
      react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
      react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
      react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
      react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
      react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
      react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
    },
    pull_request = {
      checkout_pr = { lhs = "<space>po", desc = "checkout PR" },
      merge_pr = { lhs = "<space>pm", desc = "merge commit PR" },
      squash_and_merge_pr = { lhs = "<space>psm", desc = "squash and merge PR" },
      list_commits = { lhs = "<space>pc", desc = "list PR commits" },
      list_changed_files = { lhs = "<space>pf", desc = "list PR changed files" },
      show_pr_diff = { lhs = "<space>pd", desc = "show PR diff" },
      add_reviewer = { lhs = "<space>va", desc = "add reviewer" },
      remove_reviewer = { lhs = "<space>vd", desc = "remove reviewer request" },
      close_issue = { lhs = "<space>ic", desc = "close PR" },
      reopen_issue = { lhs = "<space>io", desc = "reopen PR" },
      list_issues = { lhs = "<space>il", desc = "list open issues on same repo" },
      reload = { lhs = "<C-r>", desc = "reload PR" },
      open_in_browser = { lhs = "<C-b>", desc = "open PR in browser" },
      copy_url = { lhs = "<C-y>", desc = "copy url to system clipboard" },
      goto_file = { lhs = "gf", desc = "go to file" },
      add_assignee = { lhs = "<space>aa", desc = "add assignee" },
      remove_assignee = { lhs = "<space>ad", desc = "remove assignee" },
      create_label = { lhs = "<space>lc", desc = "create label" },
      add_label = { lhs = "<space>la", desc = "add label" },
      remove_label = { lhs = "<space>ld", desc = "remove label" },
      goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
      add_comment = { lhs = "<space>ca", desc = "add comment" },
      delete_comment = { lhs = "<space>cd", desc = "delete comment" },
      next_comment = { lhs = "]c", desc = "go to next comment" },
      prev_comment = { lhs = "[c", desc = "go to previous comment" },
      react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
      react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
      react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
      react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
      react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
      react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
      react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
      react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
    },
    review_thread = {
      goto_issue = { lhs = "<space>gi", desc = "navigate to a local repo issue" },
      add_comment = { lhs = "<space>ca", desc = "add comment" },
      add_suggestion = { lhs = "<space>sa", desc = "add suggestion" },
      delete_comment = { lhs = "<space>cd", desc = "delete comment" },
      next_comment = { lhs = "]c", desc = "go to next comment" },
      prev_comment = { lhs = "[c", desc = "go to previous comment" },
      select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
      select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      react_hooray = { lhs = "<space>rp", desc = "add/remove 🎉 reaction" },
      react_heart = { lhs = "<space>rh", desc = "add/remove ❤️ reaction" },
      react_eyes = { lhs = "<space>re", desc = "add/remove 👀 reaction" },
      react_thumbs_up = { lhs = "<space>r+", desc = "add/remove 👍 reaction" },
      react_thumbs_down = { lhs = "<space>r-", desc = "add/remove 👎 reaction" },
      react_rocket = { lhs = "<space>rr", desc = "add/remove 🚀 reaction" },
      react_laugh = { lhs = "<space>rl", desc = "add/remove 😄 reaction" },
      react_confused = { lhs = "<space>rc", desc = "add/remove 😕 reaction" },
    },
    submit_win = {
      approve_review = { lhs = "<C-a>", desc = "approve review" },
      comment_review = { lhs = "<C-m>", desc = "comment review" },
      request_changes = { lhs = "<C-r>", desc = "request changes review" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
    },
    review_diff = {
      add_review_comment = { lhs = "<space>ca", desc = "add a new review comment" },
      add_review_suggestion = { lhs = "<space>sa", desc = "add a new review suggestion" },
      focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
      toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
      next_thread = { lhs = "]t", desc = "move to next thread" },
      prev_thread = { lhs = "[t", desc = "move to previous thread" },
      select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
      select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
    },
    file_panel = {
      next_entry = { lhs = "j", desc = "move to next changed file" },
      prev_entry = { lhs = "k", desc = "move to previous changed file" },
      select_entry = { lhs = "<cr>", desc = "show selected changed file diffs" },
      refresh_files = { lhs = "R", desc = "refresh changed files panel" },
      focus_files = { lhs = "<leader>e", desc = "move focus to changed file panel" },
      toggle_files = { lhs = "<leader>b", desc = "hide/show changed files panel" },
      select_next_entry = { lhs = "]q", desc = "move to previous changed file" },
      select_prev_entry = { lhs = "[q", desc = "move to next changed file" },
      close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
      toggle_viewed = { lhs = "<leader><space>", desc = "toggle viewer viewed state" },
    }
  }
})
EOL

lua <<EOL
require('neorg').setup {
    load = {
        ["core.defaults"] = {},
        ["core.export"] = {
            config = {}
            },
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    work = "~/notes/work",
                    home = "~/notes/home",
                }
            }
        },
    }
}
EOL


lua <<EOL
-- default configuration
require('illuminate').configure({
    -- providers: provider used to get references in the buffer, ordered by priority
    providers = {
        'lsp',
        'treesitter',
        'regex',
    },
    -- delay: delay in milliseconds
    delay = 100,
    -- filetype_overrides: filetype specific overrides.
    -- The keys are strings to represent the filetype while the values are tables that
    -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
    filetype_overrides = {},
    -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
    filetypes_denylist = {
        'dirvish',
        'fugitive',
    },
    -- filetypes_allowlist: filetypes to illuminate, this is overriden by filetypes_denylist
    filetypes_allowlist = {},
    -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
    -- See `:help mode()` for possible values
    modes_denylist = {},
    -- modes_allowlist: modes to illuminate, this is overriden by modes_denylist
    -- See `:help mode()` for possible values
    modes_allowlist = {},
    -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_denylist = {},
    -- providers_regex_syntax_allowlist: syntax to illuminate, this is overriden by providers_regex_syntax_denylist
    -- Only applies to the 'regex' provider
    -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
    providers_regex_syntax_allowlist = {},
    -- under_cursor: whether or not to illuminate under the cursor
    under_cursor = true,
    -- large_file_cutoff: number of lines at which to use large_file_config
    -- The `under_cursor` option is disabled when this cutoff is hit
    large_file_cutoff = nil,
    -- large_file_config: config to use for large files (based on large_file_cutoff).
    -- Supports the same keys passed to .configure
    -- If nil, vim-illuminate will be disabled for large files.
    large_file_overrides = nil,
    -- min_count_to_highlight: minimum number of matches required to perform highlighting
    min_count_to_highlight = 1,
})
EOL
