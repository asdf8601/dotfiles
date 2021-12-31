" Nice menu when typing `:find *.py`
set wildmode=longest,list,full
set wildmenu
" Ignore files
set wildignore+=*.pyc
set wildignore+=*_build/*
set wildignore+=**/coverage/*
set wildignore+=**/node_modules/*
set wildignore+=**/.venv/*
set wildignore+=**/android/*
set wildignore+=**/ios/*
set wildignore+=**/.git/*

set mouse=nv

let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()

" mmngreco
Plug 'mmngreco/dbee.nvim'
Plug 'ThePrimeagen/refactoring.nvim'
Plug 'ThePrimeagen/git-worktree.nvim'
Plug 'lambdalisue/suda.vim'

" ==== javascript
Plug 'gko/vim-coloresque'
Plug 'mattn/emmet-vim'
" Plug pangloss/vim-javascript'
Plug 'camgraff/telescope-tmux.nvim'

" ==== telescope
Plug 'nvim-lua/popup.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

Plug 'simrat39/symbols-outline.nvim'


" ==== lsp config
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/nvim-lsp-installer'
Plug 'hrsh7th/nvim-cmp'
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-nvim-lua'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-vsnip'

" ==== syntax
Plug 'vim-pandoc/vim-pandoc'
Plug 'cespare/vim-toml'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'tpope/vim-markdown'
Plug 'chazmcgarvey/vim-mermaid'
" Plug 'plasticboy/vim-markdown', { 'for': 'markdown'}
Plug 'chrisbra/csv.vim'
Plug 'dhruvasagar/vim-table-mode'
Plug 'numToStr/Comment.nvim'

" ==== thirdparty
Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'oberblastmeister/neuron.nvim'

" Plug 'numtostr/FTerm.nvim'
" Plug 'rhysd/reply.vim', { 'on': ['Repl', 'ReplAuto'] }
Plug 'chipsenkbeil/distant.nvim'
Plug 'tyru/open-browser.vim'
Plug 'mmngreco/DrawIt'
Plug 'itchyny/calendar.vim'
" Plug 'mzlogin/vim-markdown-toc', { 'for': 'markdown'}
" Plug 'Scuilion/markdown-drawer', { 'for': 'markdown'}
Plug 'chrisbra/unicode.vim'
Plug 'mmngreco/slimux'

Plug 'vim-test/vim-test'
" Plug 'rcarriga/vim-ultest', { 'do': ':UpdateRemotePlugins' }
"
Plug 'mattn/gist-vim'
Plug 'mattn/webapi-vim'
Plug 'mbbill/undotree'
Plug 'chriskempson/base16-vim'
Plug 'goerz/jupytext.vim'
Plug 'kristijanhusak/vim-carbon-now-sh'
Plug 'christoomey/vim-tmux-navigator'
" Plug 'stevearc/vim-arduino', { 'for': 'ino' }
" Plug 'blindFS/vim-taskwarrior'
Plug 'lervag/vimtex'
" Plug 'joom/latex-unicoder.vim'
Plug 'xuhdev/vim-latex-live-preview', { 'for': 'tex' }

" ==== navegation
Plug 'ThePrimeagen/harpoon'
Plug 'phaazon/hop.nvim' " easymotion like
Plug 'godlygeek/tabular'
Plug 'majutsushi/tagbar'
" Plug 'junegunn/gv.vim'  " git commit browser (git log alternative)
" Plug 'kyazdani42/nvim-tree.lua'
" Plug 'glacambre/firenvim', { 'do': { _ -> firenvim#install(0) } }
" Plug 'ervandew/supertab'
    " Plug 'mhinz/vim-grepper', { 'on': ['Grepper', '<plug>(GrepperOperator)'] }
" Plug 'liuchengxu/vista.vim'   " modern ctag
" Plug 'Konfekt/FastFold'

" ==== diagrams
Plug 'gyim/vim-boxdraw'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install_sync(v:true) }}
" Plug 'heavenshell/vim-pydocstring'  "overwrites Ctrl-L shortcut
Plug 'wfxr/minimap.vim', {'do': ':!cargo install --locked code-minimap'}

" ==== aspect
Plug 'gruvbox-community/gruvbox'
Plug 'flazz/vim-colorschemes'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'sainnhe/gruvbox-material'
Plug 'hoob3rt/lualine.nvim'

" ==== effective programming
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-fugitive'  " offers git commands in vim
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
" Plug 'tpope/vim-dadbod'  " database interface
" Plug 'kristijanhusak/vim-dadbod-ui'
Plug 'tpope/vim-dispatch'  " compiler + make = dispatch
Plug 'tpope/vim-rhubarb'  " allow open github urls
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-vinegar'
Plug 'vim-utils/vim-man'
Plug 'vuciv/vim-bujo'  " todos
Plug 'wellle/targets.vim'  " text wrapper: cin,
Plug 'thaerkh/vim-workspace'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'shumphrey/fugitive-gitlab.vim' " allow open gitlab url
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'nvie/vim-flake8'
Plug 'tweekmonster/impsort.vim'  " color and sort imports
" Plug 'neomake/neomake'
" Plug 'Shougo/neoinclude.vim', { 'for': 'cpp' }
" Plug 'radenling/vim-dispatch-neovim'
" Plug 'ruanyl/vim-gh-line'
"
" ==== debugger plugins
Plug 'puremourning/vimspector'

Plug 'szw/vim-maximizer'

" === better vimmer
Plug 'johngrib/vim-game-code-break'
Plug 'ThePrimeagen/vim-be-good'

call plug#end()



" ==== custom settings
syntax on " Enable syntax highlighting.
" dissabling syntax highlighting when it's a diff
if &diff
    syntax off
endif

" filetype plugin indent on  " Enable file type based indentation.
" filetype plugin on

let loaded_matchparen = 1  " allow usage of local vimrc in projects
let mapleader = " "
" let g:loaded_python_provider = 1
let g:python3_host_prog = 'python3'
" let g:python_host_prog = $PYTHON_NEOVIM

" color theme
" https://github.com/awesome-streamers/awesome-streamerrc
" https://shorturl.at/cxUX3
" let g:my_colorscheme = "ayu"
let g:my_colorscheme = "gruvbox"
fun! ColorMyPencils()
    let g:gruvbox_contrast_dark = 'hard'
    if exists('+termguicolors')
        let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
        let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    endif
    let g:gruvbox_invert_selection='0'

    set background=dark
    if has('nvim')
        call luaeval('vim.cmd("colorscheme " .. _A[1])', [g:my_colorscheme])
    else
        " TODO: What the way to use g:my_colorscheme
        colorscheme gruvbox
    endif

    highlight ColorColumn ctermbg=0 guibg=grey
    hi SignColumn guibg=none
    hi CursorLineNR guibg=None
    highlight Normal guibg=none

    highlight CursorLine term=bold cterm=bold guibg=Grey40
    highlight NonText ctermbg=none
    highlight Normal  ctermbg=none

    " highlight LineNr guifg=#ff8659
    " highlight LineNr guifg=#aed75f
    highlight LineNr guifg=#5eacd3
    highlight netrwDir guifg=#5eacd3
    highlight qfFileName guifg=#aed75f
    hi TelescopeBorder guifg=#5eacd
endfun
call ColorMyPencils()

" Vim with me
nnoremap <leader>vwm :call ColorMyPencils()<CR>
nnoremap <leader>vwb :let g:my_colorscheme =

nnoremap <silent> <Plug>GenerateRandom :read! python -c "import random; print(random.gauss(0, 1))"<cr> \ :call repeat#set("\<Plug>GenerateRandom", v:count)<cr>
nmap <C-g><C-r> <Plug>GenerateRandom

tnoremap <leader>q :wqa<cr>

" underline current line
nnoremap <leader>tu <esc>Vypv$r-

" edit ini.vim
nnoremap <leader>rc :tabedit ~/.config/nvim/init.vim<CR>

" reload vimrc
nnoremap <leader><CR> :so ~/.config/nvim/init.vim<CR>

" exit from terminal mode
tnoremap <Esc> <C-\><C-n>

" resize window
nnoremap <leader>+ :vertical resize +5<CR>
nnoremap <leader>- :vertical resize -5<CR>
" maximizes current window
nnoremap <leader>rp :resize 100<CR>

" add bash dead shbang!
nnoremap <leader>sh :1<cr>O#!/usr/bin/env bash<esc><C-o>

" ==== todo list
command! Gtodo noautocmd vimgrep /TODO\|FIXME\|!!!\|???\|NOBUG\|HACK\|IDEA\|TODOC\|BUG\|XXX/j **/*.{py,md,txt} | cw

" task boxes
nnoremap <leader>ta I- [ ]<space><esc>
nnoremap <leader>tx :s/- \[ \?\]/- [x]/<CR>

" get help
nnoremap <leader>ghw :h <C-R>=expand("<cword>")<CR><CR>
" nnoremap <leader>prw :CocSearch <C-R>=expand("<cword>")<CR><CR>

" searches
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
nnoremap <leader>yp :let @+ = expand("%:p")<cr>

fun! EmptyRegisters()
    let regs=split('abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-"', '\zs')
    for r in regs
        call setreg(r, [])
    endfor
endfun

" common typo
com! W w

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
nnoremap <leader>s :%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<left><left><left>
nnoremap gs :%s//g<left><left>
" nnoremap <expr> k (v:count > 5 ? "m'" . v:count : "") . 'k'
" nnoremap <expr> j (v:count > 5 ? "m'" . v:count : "") . 'j'

" moves selected lines down/up
"
" below is commented due to problems with {{cookiecutter}} directories
" set wildignorecase
"
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
" select previous selection
noremap gV `[v`]

" https://vi.stackexchange.com/a/14683
inoremap <c-k> <esc>:.m-2 \| startinsert<cr>
inoremap <c-j> <esc>:.m+1 \| startinsert<cr>

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
    " autocmd BufEnter,BufWinEnter,TabEnter *.rs,*.py :lua require'lsp_extensions'.inlay_hints{}
    autocmd FileType markdown setl conceallevel=2 spl=en,es
    " makefiles indentation
    autocmd FileType make setl noexpandtab shiftwidth=8 softtabstop=0

    " ==== black
    " https://github.com/psf/black/issues/1293#issuecomment-623237094
    autocmd FileType python nnoremap <buffer> <F8> :silent !black -l79 -S %<CR><CR>
    autocmd FileType python vnoremap <buffer> <F8> :silent !black -l79 -c '<,'><CR><CR>

    " remove numbers from terminal buffer
    autocmd TermOpen * setlocal nonumber norelativenumber
augroup END

" ==== source plugin conf
" source $DOTFILES/vim/plugins/arduino.vim
source $DOTFILES/vim/plugins/sets.vim
source $DOTFILES/vim/plugins/bujo.vim
source $DOTFILES/vim/plugins/carbon.vim
source $DOTFILES/vim/plugins/commentary.vim
source $DOTFILES/vim/plugins/dbee.vim
source $DOTFILES/vim/plugins/drawit.vim
source $DOTFILES/vim/plugins/fugitive.vim
source $DOTFILES/vim/plugins/functions.vim
source $DOTFILES/vim/plugins/harpoon.vim
source $DOTFILES/vim/plugins/impsort.vim
source $DOTFILES/vim/plugins/jupytext.vim
source $DOTFILES/vim/plugins/lsp.vim
source $DOTFILES/vim/plugins/lualine.vim
source $DOTFILES/vim/plugins/markdown.vim
source $DOTFILES/vim/plugins/navegation.vim
source $DOTFILES/vim/plugins/netrw.vim
source $DOTFILES/vim/plugins/pydocstring.vim
source $DOTFILES/vim/plugins/slimux.vim
source $DOTFILES/vim/plugins/tagbar.vim
source $DOTFILES/vim/plugins/telescope.vim
source $DOTFILES/vim/plugins/test.vim
" source $DOTFILES/vim/plugins/vimspector.vim
source $DOTFILES/vim/plugins/vsnip.vim
source $DOTFILES/vim/plugins/workspace.vim


lua require'nvim-treesitter.configs'.setup { indent = { enable = true }, highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}
let g:user_emmet_settings = {
            \ 'svelte' : { 'extends' : 'html', },
            \}

nnoremap <c-s> :SymbolsOutline<cr>

command! -range -nargs=0 Space2Tab execute '<line1>,<line2>s#\(\s\+\)#\t#g'


let g:livepreview_engine = 'xelatex'
let g:livepreview_previewer = 'evince'
" let g:vimtex_compiler_generic = 'xelatex'
let g:vimtex_compiler_latexmk_engines = {
    \ '_'                : '-xelatex',
    \}

let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <leader>h :TmuxNavigateLeft<cr>
nnoremap <silent> <leader>j :TmuxNavigateDown<cr>
nnoremap <silent> <leader>k :TmuxNavigateUp<cr>
nnoremap <silent> <leader>l :TmuxNavigateRight<cr>
nnoremap <silent> <leader>ll :TmuxNavigatePrevious<cr>
nnoremap  <c-t><c-s> :Telescope tmux sessions<cr>
" go substitute because the default map for sleeping is silly


" ==== hop (easymotion like)
" TODO move to lua file
lua require'hop'.setup()
nn <leader><leader>w :HopWord<cr>


vn <leader>sf :!sqlformat -k upper -a -<cr>

nn <leader>cal :Calendar -view=year -split=vertical -width=27 -first_day=monday<cr>
nn <leader>day :Calendar -first_day=monday<cr>

" === DAP config

lua <<EOF
require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 00.25 },
    },
    size = 40,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})

local dap = require('dap')
dap.adapters.go = function(callback, config)
local stdout = vim.loop.new_pipe(false)
local handle
local pid_or_err
local port = 38697
local opts = {
    stdio = {nil, stdout},
    args = {"dap", "-l", "127.0.0.1:" .. port},
    detached = true
    }
handle, pid_or_err = vim.loop.spawn("dlv", opts, function(code)
stdout:close()
handle:close()
if code ~= 0 then
    print('dlv exited with code', code)
end
    end)
    assert(handle, 'Error running dlv: ' .. tostring(pid_or_err))
    stdout:read_start(function(err, chunk)
    assert(not err, err)
    if chunk then
        vim.schedule(function()
        require('dap.repl').append(chunk)
    end)
end
    end)
    -- Wait for delve to start
    vim.defer_fn(
    function()
        callback({type = "server", host = "127.0.0.1", port = port})
    end,
    100)
end
-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
    {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${file}"
    },
    {
            type = "go",
            name = "Debug test", -- configuration for debugging test files
            request = "launch",
            mode = "test",
            program = "${file}"
    },
    -- works with go.mod packages and sub packages
    {
            type = "go",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}"
    }
}
EOF

nn <leader>do :lua require("dapui").open()<cr>
nn <leader>dx :lua require("dapui").close()<cr>
nn <leader>dt :lua require("dapui").toggle()<cr>
nn <leader>db :lua require("dap").toggle_breakpoint()<cr>
nn <leader>dc :lua require("dap").continue()<cr>
nn <leader>dl :lua require("dap").step_into()<cr>
nn <leader>dj :lua require("dap").step_over()<cr>
vnoremap <M-k> :lua require("dapui").eval()<CR>
