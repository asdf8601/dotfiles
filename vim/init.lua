-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.execute('!git clone https://github.com/wbthomason/packer.nvim ' .. install_path)
  vim.cmd.packadd 'packer.nvim'
end
local executable = function(x)
  return vim.fn.executable(x) == 1
end


require('packer').startup(function(use)
  -- Package manager


  -- use {
  --   "jcdickinson/wpm.nvim",
  --   config = function()
  --     require("wpm").setup({
  --     })
  --   end
  -- }
  -- Packer
  use({'mracos/mermaid.vim'})
  use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })


  use({
    "jackMort/ChatGPT.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    config = function()
      require("chatgpt").setup({
        chat = {
          keymaps = {
            close = { "jk", "kj", "<Esc>" },
            yank_last = "<C-y>",
            scroll_up = "<C-u>",
            scroll_down = "<C-d>",
            toggle_settings = "<C-o>",
            new_session = "<C-n>",
            cycle_windows = "<Tab>",
          },
        },
        popup_input = {
          submit = "<C-s>",
        },
      })
    end,
  })

  -- use({
  --   "jackMort/ChatGPT.nvim",
  --   config = function() require("chatgpt").setup({
  --    keymaps = {
  --       close = { "<C-c>" },
  --       submit = '<C-m>',
  --       yank_last = "<C-y>",
  --       yank_last_code = "<C-k>",
  --       scroll_up = "<C-u>",
  --       scroll_down = "<C-d>",
  --       toggle_settings = "<C-o>",
  --       new_session = "<C-n>",
  --       cycle_windows = "<Tab>",
  --       -- in the Sessions pane
  --       select_session = "<Space>",
  --       rename_session = "r",
  --       delete_session = "d",
  --     }
  --   }) end,
  --   requires = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim"
  --   }
  -- })

  -- use({
  -- "jackMort/ChatGPT.nvim",
  -- config = function()
  --     require("chatgpt").setup({
  --       yank_register = "+",
  --       chat_layout = {
  --         relative = "editor",
  --         position = "0%",
  --         size = {
  --           height = "100%",
  --           width = "100%",
  --         },
  --       },
  --       keymaps = {
  --           close = { "<C-c>"},
  --           yank_last = "<C-y>",
  --           yank_last_code = "<C-k>",
  --           scroll_up = "<C-u>",
  --           scroll_down = "<C-d>",
  --           toggle_settings = "<C-o>",
  --           new_session = "<C-n>",
  --           cycle_windows = "<Tab>",
  --           -- in the Sessions pane
  --           select_session = "<Space>",
  --           rename_session = "r",
  --           delete_session = "d",
  --           submit = '<C-m>',
  --         }
  --     })
  --   end,
  --   requires = {
  --     "MunifTanjim/nui.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim"
  --   }
  -- })


  use {'xiyaowong/telescope-emoji.nvim'}
  use { 'michaelb/sniprun', run = 'bash ./install.sh'}
  use {
    "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("todo-comments").setup {
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      }
    end
  }

  use "Pocco81/high-str.nvim"

  use {
    'lukas-reineke/headlines.nvim',
    config = function()
      require('headlines').setup()
    end,
  }

  use {
    'chipsenkbeil/distant.nvim',
    branch = 'v0.2',
    config = function()
      require('distant').setup {
        -- Applies Chip's personal settings to every machine you connect to
        --
        -- 1. Ensures that distant servers terminate with no connections
        -- 2. Provides navigation bindings for remote directories
        -- 3. Provides keybinding to jump into a remote file's parent directory
        -- ['*'] = require('distant.settings').chip_default()
        ['*'] = vim.tbl_deep_extend('force', require('distant.settings').chip_default(), { mode = 'ssh', })
      }
    end
  }

  use {'dhruvasagar/vim-table-mode'}

  -- use "folke/twilight.nvim"
  use {
    "folke/zen-mode.nvim",
    config = function()
      require("zen-mode").setup({
        window = {
          backdrop = 1,
        },
        plugins = {
          gitsigns = { enabled = true },
          tmux = { enabled = false },
          twilight = { enabled = false },
        },
      })
    end
  }

  use "monaqa/dial.nvim"
  use {
    "NTBBloodbath/rest.nvim",
    disable = not executable "jq",
    config = function()
      require("rest-nvim").setup()
    end,
  }

  use 'lewis6991/impatient.nvim'
  use 'nvim-treesitter/playground'

  -- [[ dap ]]
  use 'mfussenegger/nvim-dap'
  use 'mfussenegger/nvim-dap-python'
  use 'rcarriga/nvim-dap-ui'
  use 'theHamsta/nvim-dap-virtual-text'

  use 'majutsushi/tagbar'

  -- [[ copilot ]]
  -- use 'github/copilot.vim'
  use {
    "zbirenbaum/copilot.lua",
    config = function()
      require('copilot').setup()
    end,
  }

  use {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  }


  -- Github integration
  use {"pwntester/octo.nvim", disable = not executable "gh"}

  -- Sweet message committer
  use "rhysd/committia.vim"
  use "sindrets/diffview.nvim"

  -- Floating windows are awesome :)
  use {
    "rhysd/git-messenger.vim",
    keys = "<Plug>(git-messenger)",
  }

  use 'nvie/vim-flake8'

  use 'jpalardy/vim-slime'

  use 'liuchengxu/vista.vim'
  use 'romainl/vim-qf'
  use 'RRethy/vim-illuminate'

  use 'wbthomason/packer.nvim'

  -- [[ colorschemes ]]
  use 'wuelnerdotexe/vim-enfocado'
  use { "catppuccin/nvim", as = "catppuccin" }
  use { 'ishan9299/modus-theme-vim' }
  use {'navarasu/onedark.nvim'}
  use {'folke/tokyonight.nvim'}

  use 'mbbill/undotree'
  use 'szw/vim-maximizer'
  use 'ThePrimeagen/git-worktree.nvim'
  use 'ThePrimeagen/harpoon'
  use 'ThePrimeagen/refactoring.nvim'

  use 'tpope/vim-abolish'

  use 'tpope/vim-dadbod'
  use 'kristijanhusak/vim-dadbod-ui'

  use 'tpope/vim-dispatch'
  use 'tpope/vim-fugitive'
  use 'tpope/vim-markdown'
  use 'tpope/vim-obsession'
  use 'tpope/vim-repeat'
  use 'tpope/vim-rhubarb'
  use 'tpope/vim-speeddating'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-vinegar'
  use 'tweekmonster/impsort.vim'
  use 'tyru/open-browser.vim'
  use 'godlygeek/tabular'
  use 'goerz/jupytext.vim'
  use 'gyim/vim-boxdraw'
  use 'fatih/vim-go'
  use 'mattn/gist-vim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',
    },
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip', 'hrsh7th/cmp-path', 'hrsh7th/cmp-cmdline' },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'lewis6991/gitsigns.nvim'

  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }
  use {'nvim-telescope/telescope-symbols.nvim'}
  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Add custom plugins to packer from /nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, "custom.plugins")
  if has_plugins then plugins(use) end

  if is_bootstrap then
    require('packer').sync()
  end
end)

require('impatient')

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'n'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
-- vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
function SetColorScheme(colorscheme)

  if colorscheme == 'onedark' then
    require('onedark').setup({
      style = 'darker',
      -- style = 'warmer',
      -- style = 'deep',
      toggle_style_key = ',ts', -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
      transparent = true,  -- Show/hide background
      diagnostics = {
        darker = true, -- darker colors for diagnostic
        undercurl = true,   -- use undercurl instead of underline for diagnostics
        background = false,    -- use background color for virtual text
      },
    })
    require('onedark').load()
    vim.cmd [[colorscheme onedark]]

  elseif colorscheme == 'modus-vivendi' then
    vim.g.modus_faint_syntax = 0
    vim.g.modus_green_strings = 1
    vim.g.modus_yellow_comments = 0
    vim.g.modus_cursorline_intense = 1
    vim.g.modus_termtrans_enable = 0
    vim.cmd('colorscheme modus-vivendi')

  elseif colorscheme == 'catppuccin' then
    require("catppuccin").setup {
      flavour = "mocha", -- latte, frappe, macchiato, mocha
      term_colors = true,
      transparent_background = true,
      no_italic = true,
      no_bold = false,
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
      },
      -- color_overrides = {
      --   mocha = {
      --     base = "#000000",
      --     mantle = "#000000",
      --     crust = "#000000",
      --   },
      -- },
      -- highlight_overrides = {
      --   mocha = function(C)
      --     return {
      --       TabLineSel = { bg = C.pink },
      --       CmpBorder = { fg = C.surface2 },
      --       Pmenu = { bg = C.none },
      --       TelescopeBorder = { link = "FloatBorder" },
      --     }
      --   end,
      -- },
    }
    vim.cmd.colorscheme "catppuccin"

  elseif colorscheme == 'tokyonight' then
    vim.cmd [[colorscheme tokyonight]]

  elseif colorscheme == 'enfocado' then
    vim.g.enfocado_style = 'nature' -- Available: `nature` or `neon`.
    vim.cmd('colorscheme enfocado')

  end

  return colorscheme

end


-- ColoringVim('modus-vivendi')
-- SetColorScheme('tokyonight')
-- SetColorScheme('onedark')
SetColorScheme('catppuccin')

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`


-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require("telescope").load_extension("emoji")
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
  extensions = {
    emoji = {
      action = function(emoji)
        -- argument emoji is a table.
        -- {name="", value="", cagegory="", description=""}

        vim.fn.setreg("*", emoji.value)
        print([[Press p or "*p to paste this emoji]] .. emoji.value)

        -- insert emoji when picked
        -- vim.api.nvim_put({ emoji.value }, 'c', false, true)
      end,
    }
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = '[F]ind current [W]ord' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })

vim.keymap.set('n', '<C-p>', builtin.git_files, {noremap = true, desc = 'Find files in git repo'})
vim.keymap.set('n', '<leader>gs', builtin.git_stash, {noremap = true, desc = 'Git stash'})

local function create_git_worktree()
  require('telescope').extensions.git_worktree.create_git_worktree()
end
vim.keymap.set('n', '<leader>gw', create_git_worktree, {noremap = true, desc = 'Git worktree'})


-- local function grep_for()
--     builtin.grep_string({ search = vim.fn.input("Grep For > ")})
-- end
-- vim.keymap.set('n', '<leader>ps', grep_for, {noremap = true})

-- local function grep_string()
--     builtin.grep_string({ search = vim.fn.expand("<cword>") })
-- end
-- vim.keymap.set('n', '<leader>pw', grep_string, {noremap = true})


local actions = require('telescope.actions')
local function search_scio()

  -- function to edit a file
  local vim_edit_prompt = function(prompt_bufnr)
    local current_picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    local prompt = current_picker:_get_prompt()
    local cwd = current_picker.cwd
    actions.close(prompt_bufnr)
    vim.api.nvim_exec(':edit ' .. cwd .. '/' .. prompt, false)
    return true
  end

  require("telescope.builtin").find_files({
    prompt_title = "< scio >",
    cwd = "~/github/mmngreco/scio",
    hidden = true,
    no_ignore = true,
    attach_mappings = function(_, map)
      map('i', '<c-n>', vim_edit_prompt)
      return true
    end
  })
end

local ignore_patterns = { "venv/", ".venv/", ".git/", "node_modules/", "*.pyc", "__.*cache.*/", "*.pkl", "*.pickle" , "*.mat"}

local function search_dotfiles()
  require("telescope.builtin").find_files({
    prompt_title = "< dotfiles >",
    cwd = "$DOTFILES",
    hidden = true,
    no_ignore = true,
  })
end

local function find_files()
  require("telescope.builtin").find_files({
    file_ignore_patterns = ignore_patterns,
    hidden = true,
    no_ignore = true,
    follow = true,
  })
end


local function git_branches()
  require("telescope.builtin").git_branches({
    attach_mappings = function(_, map)
      map('i', '<c-d>', actions.git_delete_branch)
      map('n', '<c-d>', actions.git_delete_branch)
      map('i', '<c-b>', actions.git_create_branch)
      return true
    end
  })
end

vim.keymap.set('n', '<leader>dot', search_dotfiles, {noremap = true})
vim.keymap.set('n', '<Leader>ff', find_files, {noremap = true})
vim.keymap.set('n', '<leader>gc', git_branches, {noremap = true})
vim.keymap.set('n', '<leader>sc', search_scio, {noremap = true})

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'vim', 'help'},

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gi', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })
end

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Enable the following language servers
-- Feel free to add/remove any LSPs that you want here. They will automatically be installed
local servers = {
    -- 'clangd',
    -- 'rust_analyzer',
    'pyright',
    'ruff_lsp',
    -- 'tsserver',
    -- 'lua_ls',
    -- 'gopls'
    -- 'sqlls',
}

-- Ensure the servers above are installed
require('mason-lspconfig').setup {
  ensure_installed = servers,
}

-- nvim-cmp supports additional completion capabilities
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- Turn on status information
require('fidget').setup()

-- Example custom configuration for lua
--
-- Make runtime files discoverable to the server
local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, 'lua/?.lua')
table.insert(runtime_path, 'lua/?/init.lua')

require('lspconfig').lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = { library = vim.api.nvim_get_runtime_file('', true) },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = { enable = false },
    },
  },
}

-- [[ nvim-cmp setup ]]
local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-l>'] = cmp.mapping.complete(),
    ['<C-l>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
  },
  sources = {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'copilot' },
    { name = 'buffer' },
    { name = 'path' },
    -- { name = 'neorg' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'orgmode' },
  },
}


require('illuminate').configure({
  -- providers: provider used to get references in the buffer, ordered by priority
  providers = {
    'lsp',
    'treesitter',
    'regex',
  },
  -- delay: delay in milliseconds
  delay = 10,
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
  large_file_cutoff = 3000,
  -- large_file_config: config to use for large files (based on large_file_cutoff).
  -- Supports the same keys passed to .configure
  -- If nil, vim-illuminate will be disabled for large files.
  large_file_overrides = nil,
  -- min_count_to_highlight: minimum number of matches required to perform highlighting
  min_count_to_highlight = 1,
})

-- local wpm = require("wpm")
require('lualine').setup({
  options = {
    -- theme = 'onedark',
    theme = 'catppuccin',
    icons_enabled = false,
    -- icons_enabled = true,
    -- separator = { left = '', right = ''},
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = {}
  },
  sections = {
    lualine_a = {'mode'},
    -- lualine_b = {'branch'},
    lualine_b = {'branch', 'diff'},
    lualine_c = {{'filename', path = 1}},
    -- lualine_c = {'filename'},
    lualine_x = {
      'encoding',
      'fileformat',
      'filetype',
      -- wpm.wpm,
      -- wpm.historic_graph
    },
    lualine_y = {function() return vim.fn.ObsessionStatus('Ob:ON', 'Ob:Off') end },
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {'branch'},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {''},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
})

local augroup = vim.api.nvim_create_augroup
Mgreco = augroup('mgreco', {})

local autocmd = vim.api.nvim_create_autocmd
-- local yank_group = augroup('HighlightYank', {})


autocmd({"BufWritePre"}, {
  group = Mgreco,
  pattern = "*",
  command = "%s/\\s\\+$//e",
})

autocmd({'FileType'}, {
  group = Mgreco,
  pattern = "dbui",
  command = "nmap <buffer> <leader>w <Plug>(DBUI_SaveQuery)",
})

autocmd({'FileType'}, {
  group = Mgreco,
  pattern = "markdown",
  command = "normal zR",
})

vim.keymap.set('n', '<leader>sq', '<Plug>(DBUI_SaveQuery)', {noremap = true})

autocmd({'FileType'}, {
  group = Mgreco,
  pattern = "dbui",
  command = "setl nonumber norelativenumber",
})

autocmd({'BufWritePost'}, {
  group = Mgreco,
  pattern = "~/.Xresources",
  command = "silent !xrdb <afile> > /dev/null",
})



local telescope = require('telescope')
telescope.load_extension("git_worktree")
telescope.load_extension('harpoon')


-- [[ netrw ]]
vim.g.netrw_browse_split = 0
vim.g.netrw_winsize = 25
vim.g.netrw_localrmdir='rm -r'
vim.g.netrw_browsex_viewer= 'xdg-open'
vim.g.netrw_hide = 0

vim.keymap.set('n', 'gx', '<Plug>(openbrowser-smart-search)')
vim.keymap.set('v', 'gx', '<Plug>(openbrowser-smart-search)')
vim.keymap.set('n', '<leader>dd', ':Lexplore %:p:h<CR>', {noremap = true})
vim.keymap.set('n', '<Leader>da', ':Lexplore<CR>', {noremap = true})

vim.cmd([[
if &columns < 90
let g:netrw_winsize = 50
else
let g:netrw_winsize = 30
endif

let g:netrw_keepdir = 0
let g:netrw_banner = 0
let g:netrw_list_hide = '\(^\|\s\s\)\zs\.\S\+'
let g:netrw_localcopydircmd = 'cp -r'

function! NetrwRemoveRecursive()
if &filetype ==# 'netrw'
cnoremap <buffer> <CR> rm -r<CR>
normal mu
normal mf
try
normal mx
catch
endtry
cunmap <buffer> <CR>
endif
endfunction

function! NetrwMapping()
nmap <buffer> <leader>dd :Lexplore<CR>
nmap <buffer> L <CR>:Lexplore<CR>
nmap <buffer> H u
nmap <buffer> h -^
nmap <buffer> l <CR>
nmap <buffer> . gh
nmap <buffer> <TAB> mf
nmap <buffer> <S-TAB> mF
nmap <buffer> <Leader><TAB> mu
nmap <buffer> bb mb
nmap <buffer> bd mB
nmap <buffer> bl gb
nmap <buffer> ff %:w<CR>:buffer #<CR>
nmap <buffer> fe R
nmap <buffer> fc mc
nmap <buffer> fC mtmc
nmap <buffer> fx mm
nmap <buffer> fX mtmm
nmap <buffer> f; mx
nmap <buffer> fd mtfq
nmap <buffer> FF :call NetrwRemoveRecursive()<CR>
nmap <buffer> P <C-w>z
endfunction

augroup netrw_mapping
autocmd!
autocmd filetype netrw call NetrwMapping()
augroup END
]])

-- [[ terminal ]]
-- terminal settings
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', {noremap = true})
vim.keymap.set('t', '<C-w>h', '<C-\\><C-n><C-w>h', {noremap = true})
vim.keymap.set('t', '<C-w>j', '<C-\\><C-n><C-w>j', {noremap = true})
vim.keymap.set('t', '<C-w>k', '<C-\\><C-n><C-w>k', {noremap = true})
vim.keymap.set('t', '<C-w>l', '<C-\\><C-n><C-w>l', {noremap = true})
vim.keymap.set('t', '<C-w>w', '<C-\\><C-n><C-w>w', {noremap = true})
vim.keymap.set('t', '<C-P>', '<C-\\><C-n>pi<cr>', {noremap = true})
-- vim.keymap.set('n', '<C-l>', 'i<C-l>', {noremap = true})


-- [[ LSP ]]
vim.g.completion_matching_strategy_list = { 'exact', 'substring', 'fuzzy' }
vim.g.completion_enable_snippet = 'vim-vsnip'
vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', {noremap = true})
vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.rename()<CR>', {noremap = true})
vim.keymap.set('n', '<leader>gd', ':lua vim.lsp.buf.definition()<CR>', {noremap = true})
vim.keymap.set('n', '<leader>gi', ':lua vim.lsp.buf.implementation()<CR>', {noremap = true})
vim.keymap.set('n', '<leader>gh', ':lua vim.lsp.buf.signature_help()<CR>', {noremap = true})
vim.keymap.set('n', '<leader>gf', ':lua vim.lsp.buf.references()<CR>', {noremap = true})
vim.keymap.set('n', '<leader>ga', ':lua vim.lsp.buf.code_action()<CR>', {noremap = true})
vim.keymap.set('n', '<leader>dq', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', {noremap = true})
vim.keymap.set('n', '<leader>dn', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', {noremap = true})
vim.keymap.set('n', '<leader>dp', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', {noremap = true})

-- [[ jupytext ]]
vim.g.jupytext_filetype_map = { py='python' }
vim.g.jupytext_fmt = 'py'

-- [[ harpoon ]]

function SendToHarpoon(term_num, visual)
  local goto_term = vim.g.harpoon_goto_term
  local term = require('harpoon.term')
  if visual == 1 then
    local lines = vim.fn.getline("'<", "'>")
    for _, line in ipairs(lines) do
      term.sendCommand(term_num, line)
      term.sendCommand(term_num, '\r')
    end
  else
    local line = vim.fn.getline('.')
    term.sendCommand(term_num, line)
    term.sendCommand(term_num, '\r')
  end

  if goto_term == 1 then
    term.gotoTerminal(term_num)
  end

end

vim.g.harpoon_goto_term = 0

-- send to harpoon terminal
vim.keymap.set('n', '<C-s><C-h>', ':lua SendToHarpoon(1, 0)<CR>', {noremap = true})
vim.keymap.set('v', '<C-s><C-h>', ':lua SendToHarpoon(1, 1)<CR>', {noremap = true})
-- open harpoon menu
vim.keymap.set('n', '<leader>ha', ':lua require("harpoon.ui").toggle_quick_menu()<CR>', {noremap = true})

vim.keymap.set('n', '<C-h>', ':lua require("harpoon.ui").nav_file(1)<cr>', { noremap = true } )
vim.keymap.set('n', '<C-j>', ':lua require("harpoon.ui").nav_file(2)<cr>', { noremap = true } )
vim.keymap.set('n', '<C-k>', ':lua require("harpoon.ui").nav_file(3)<cr>', { noremap = true } )
vim.keymap.set('n', '<C-l>', ':lua require("harpoon.ui").nav_file(4)<cr>', { noremap = true } )

vim.keymap.set('n', '<C-h><C-h>', ':lua require("harpoon.term").gotoTerminal(1)<cr>i', { noremap = true } )
vim.keymap.set('n', '<C-j><C-j>', ':lua require("harpoon.term").gotoTerminal(2)<cr>i', { noremap = true } )
vim.keymap.set('n', '<C-k><C-k>', ':lua require("harpoon.term").gotoTerminal(3)<cr>i', { noremap = true } )
vim.keymap.set('n', '<C-l><C-l>', ':lua require("harpoon.term").gotoTerminal(4)<cr>i', { noremap = true } )

-- add file to harpoon
vim.keymap.set('n', '<leader>hf', ':lua require("harpoon.mark").add_file()<CR>', {noremap = true})

-- add python cells
vim.keymap.set('n', '<leader>co', 'O%%<esc>:norm gcc<cr>j', {noremap = true})
vim.keymap.set('n', '<leader>cO', 'o%%<esc>:norm gcc<cr>k', {noremap = true})
vim.keymap.set('n', '<leader>c-', 'O<esc>77i-<esc>:norm gcc<cr>j', {noremap = true})
vim.keymap.set('n', 'vic', 'V?%%<cr>o/%%<cr>koj', {noremap = true})


-- markdown
vim.g.markdown_fenced_languages = { 'html', 'python', 'bash=sh', 'sql' }
vim.g.markdown_minlines = 50
-- TODO: fill this
-- vim.g.mkdp_markdown_css = ''
vim.g.mkdp_auto_start = 0
vim.g.mkdp_auto_close = 0
vim.g.mkdp_page_title = "${name}"
vim.g.mkdp_theme = 'light'

--grepper
vim.g.grepper = {}
vim.g.grepper.tools = { 'ag', 'rg', 'git' }
vim.g.grepper.jump = 1
vim.g.grepper.next_tool = '<leader>g'
vim.g.grepper.simple_prompt = 1
vim.g.grepper.quickfix = 0

vim.keymap.set('n', '<leader>*', ':Grepper -tool ag -cword -noprompt<cr>', {noremap = true})
vim.keymap.set('n', '<leader>g', ':Grepper -tool ag<cr>', {noremap = true})

-- [[ fasfold ]]

vim.g.python_folding = 1
vim.g.markdown_folding = 1
vim.g.tex_fold_enabled = 1
vim.g.vimsyn_folding = 'af'
vim.g.xml_syntax_folding = 1
vim.g.javaScript_fold = 1
vim.g.sh_fold_enabled= 7
vim.g.ruby_fold = 1
vim.g.perl_fold = 1
vim.g.perl_fold_blocks = 1
vim.g.r_syntax_folding = 1
vim.g.rust_fold = 1
vim.g.php_folding = 1
vim.g.fastfold_savehook = 1
vim.g.fastfold_fold_command_suffixes =  { 'x','X','a','A','o','O','c','C' }
vim.g.fastfold_fold_movement_commands = {']z', '[z', 'zj', 'zk'}
vim.g.fastfold_savehook = 0

vim.keymap.set('n', 'zuz', '<Plug>FastFoldUpdate', { noremap = true, desc = 'update folds' })
local Fold = vim.api.nvim_create_augroup('Fold', { clear = true })
vim.api.nvim_create_autocmd('BufWinEnter', { group=Fold, pattern='*', command='setlocal foldmethod=expr' })
-- vim.api.nvim_create_autocmd('FileType', { group=Fold, pattern='python', command='foldmethod=indent' })

vim.g.SimpylFold_docstring_preview = 0
vim.g.SimpylFold_fold_docstring = 0
vim.b.SimpylFold_fold_docstring = 0
vim.g.SimpylFold_fold_import = 0
vim.b.SimpylFold_fold_import = 0
vim.g.SimpylFold_fold_blank = 0
vim.b.SimpylFold_fold_blank = 0

-- sets
vim.o.scrollback=20000
-- vim.o.guicursor=""
-- vim.o.nohlsearch = true
-- vim.o.hidden = true
-- vim.o.noerrorbells = true
vim.o.tabstop=4
vim.o.softtabstop=4
vim.o.shiftwidth=4
vim.o.expandtab = true
vim.o.smartindent = true
-- vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
-- vim.o.noswapfile = true
-- vim.o.nobackup = true
vim.o.undodir = os.getenv("HOME") .. '/.vim/undodir'
vim.o.undofile = true
vim.o.incsearch = true
vim.o.termguicolors = true
vim.o.scrolloff=8
-- vim.o.signcolumn='no'
vim.o.cmdheight = 1
vim.o.timeoutlen = 200
vim.o.updatetime = 50
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.textwidth = 79
vim.o.cursorline = true

vim.o.colorcolumn = "80" -- works!

vim.g.python3_host_prog = 'python3'

vim.keymap.set('n', '<leader><cr>', ':source ~/.config/nvim/init.lua<cr>', {noremap = true})
vim.keymap.set('n', '<leader>rc', ':new ~/.config/nvim/init.lua<cr>', {noremap = true})

local mmngreco = vim.api.nvim_create_augroup('mmngreco', {clear = true})
-- vim.api.nvim_create_autocmd('BufWritePost', {group=mmngreco, pattern='~/.config/nvim/init.lua', command='source ~/.config/nvim/init.lua'})
-- execute '%!python -m json.tool' | w
vim.api.nvim_create_autocmd('BufRead', { group=mmngreco, pattern='*.json', command='%!python -m json.tool'})
vim.api.nvim_create_autocmd('BufWritePre', { group=mmngreco, pattern='*', command='%s/\\s\\+$//e'})
vim.api.nvim_create_autocmd('BufWritePre', { group=mmngreco, pattern='*.go', command='GoFmt'})
vim.api.nvim_create_autocmd('BufEnter', { group=mmngreco, pattern='*.dbout', command='norm zR'})
vim.api.nvim_create_autocmd('FileType', { group=mmngreco, pattern='markdown', command='setl conceallevel=2 spl=en,es'})
vim.api.nvim_create_autocmd('FileType', { group=mmngreco, pattern='make', command='setl noexpandtab shiftwidth=4 softtabstop=0'})
vim.api.nvim_create_autocmd('TermOpen', { group=mmngreco, pattern='*', command='setl nonumber norelativenumber'})
vim.api.nvim_create_autocmd('FileType', { group=mmngreco, pattern='fugitive', command='setl nonumber norelativenumber'})
vim.api.nvim_create_autocmd('FileType', { group=mmngreco, pattern='python', command='nnoremap <buffer> <F8> :silent !black -l79 -S %<CR><CR>'})

-- [[ slime ]]
vim.g.slime_cell_delimiter = [[\s*#\s*%%]]
vim.g.slime_paste_file = os.getenv("HOME") .. "/.slime_paste"
vim.g.slime_target = "tmux"
vim.g.slime_bracketed_paste = 1
vim.g.slime_dont_ask_default = 1
vim.g.slime_default_config = {socket_name="default", target_pane=":.2"}
vim.g.slime_no_mappings = 1

vim.keymap.set('n', '<leader>cv', ':SlimeConfig<cr>', {noremap = true})
vim.keymap.set('n', '<leader>ep', '<Plug>SlimeParagraphSend', {noremap = true})
-- vim.keymap.set('n', '<leader>cc', '<Plug>SlimeSendCell', {noremap = true})
vim.keymap.set('n', '<leader>ck', '<cmd>call search(g:slime_cell_delimiter, "b")<cr>', {noremap = true})
vim.keymap.set('n', '<leader>cj', '<cmd>call search(g:slime_cell_delimiter)<cr>', {noremap = true})
vim.keymap.set('n', '<leader>cv', ':SlimeConfig<cr>', {noremap = true})
vim.keymap.set('n', '<leader>e',  ':SlimeSend<cr>', {noremap = true, desc = 'send line to tmux'})
vim.keymap.set('x', '<leader>e', '<Plug>SlimeRegionSend', {noremap = true, desc = 'send line to tmux'})

vim.keymap.set('n', '<leader>ep', '<Plug>SlimeParagraphSend', {noremap = true})
vim.keymap.set('n', '<leader>cc', '<Plug>SlimeSendCell', {noremap = true})
vim.keymap.set('n', '<leader>ck', '<cmd>call search(g:slime_cell_delimiter, "b")<cr>', {noremap = true})
vim.keymap.set('n', '<leader>cj', '<cmd>call search(g:slime_cell_delimiter)<cr>', {noremap = true})

-- function to disable number and relative number
vim.g.number = 1
function ToggleNumbers()
  if vim.g.number == 1 then
    vim.g.number = 0
    vim.o.number = false
    vim.o.relativenumber = false
    vim.o.signcolumn = 'no'
  else
    vim.g.number = 1
    vim.o.number = true
    vim.o.relativenumber = true
    vim.o.signcolumn = 'yes'
  end
end

vim.keymap.set('n', 'gV', '`[v`]', {noremap = true, desc = 'select last visual selection' })
vim.keymap.set('n', '<leader>s', ':%s/<C-r><C-w>/<C-r><C-w>/gI<left><left><left>', {noremap = true, desc = 'search and replace word under cursor' })
-- vim.keymap.set('n', 'gs', ':%s//g<left><left>', {noremap = true, desc = 'search and replace' })

vim.keymap.set('i', '<C-J>', '<esc>:.m+1 | startinsert<cr>', {noremap = true, desc = 'move line down' })
vim.keymap.set('i', '<C-K>', '<esc>:.m-2 | startinsert<cr>', {noremap = true, desc = 'move line up' })

vim.keymap.set('n', '<leader>k', ':m .-2<cr>==', {noremap = true, desc = 'move line up' })
vim.keymap.set('n', '<leader>j', ':m .+1<cr>==', {noremap = true, desc = 'move line down' })

vim.keymap.set('n', '<leader>cn', ':cnext<cr>', {noremap = true, desc = 'next error' })
vim.keymap.set('n', '<leader>cp', ':cprev<cr>', {noremap = true, desc = 'previous error' })


vim.keymap.set('n', '<leader>gls',
  function ()
    Search_term = vim.fn.expand('%')
    vim.cmd('Gclog -- %')
    vim.cmd('call search("' .. Search_term .. '")')
  end,
  {noremap = true, desc = 'git log search' }
)

vim.keymap.set('n', '<leader>gln',
  function ()
    vim.cmd('cnext')
    vim.fn.search(Search_term)
  end,
  {noremap = true, desc = 'next git log search' }
)
vim.keymap.set('n', '<leader>glp',
  function ()
    vim.cmd('cprev')
    vim.fn.search(Search_term)
  end,
  {noremap = true, desc = 'previous git log search' }
)

vim.keymap.set('n', '<leader>sn', ':\'<,\'>!sort -n -k 2', {noremap = true, desc = 'sort lines numerically' })
vim.keymap.set('v', '<leader>s', ':\'<,\'>!sort -f<cr>', {noremap = true, desc = 'sort lines' })
-- vim.o.isfname:append('@-@')
-- vim.keymap.set('v', '<leader>sf', ':!sqlformat -k upper -r -<cr>', {noremap = true})
vim.keymap.set('v', '<leader>sf', ':!sqlformat  -k upper -r --indent_after_first --indent_columns -<cr>', {noremap = true})

-- to show hidden symbols characters in a file, :set list to show them.
vim.o.listchars='tab:→\\ ,space:·,nbsp:␣,trail:•,eol:¶,precedes:«,extends:»'


vim.keymap.set('n', '<leader>tu', 'yypvawr-', {noremap = true, desc = 'underline word under cursor'})
vim.keymap.set('n', '<leader>tx', ':s/\\[\\s\\?\\]/[x]/<cr>', {noremap = true, desc = 'check a box in markdown'})
vim.keymap.set('n', '<leader>t<space>', ':s/\\[x\\]/[ ]/<cr>', {noremap = true, desc = 'uncheck a box in markdown'})
vim.keymap.set('n', '<leader>ta', 'I- [ ] <esc>', {noremap = true, desc = 'append empty checkbox in markdown'})
vim.keymap.set('n', '<leader>m', ':MaximizerToggle<cr>', {noremap = true, desc = 'Maximize current window'})

-- [[ checkbox ]]
function Checkboxes()
  local line = vim.fn.line('.')
  -- local line_orig = vim.fn.getline('.')
  local checked = 0
  local total = 0

  -- find the first line of the paragraph
  while line > 1 and vim.fn.getline(line - 1) ~= '' do
    line = line - 1
  end

  while true do
    local line_text = vim.fn.getline(line)
    if line_text:match('^%s*%-%s%[[xX]%]') then
      checked = checked + 1
      total = total + 1
    elseif line_text:match('^%s*%-%s%[.%]') then
      total = total + 1
    else
      break
    end
    line = line + 1
  end

  vim.api.nvim_input("vipo<esc>A (" .. checked .. "/" .. total .. ")<esc>")
  return {checked, total}
end
-- vim.cmd('command! -nargs=0 Checkboxes lua Checkboxes()')


-- [[ fugitive ]]
vim.keymap.set("n", "<leader>w", ":Git<cr>", {noremap = true})
vim.keymap.set('n', '<C-g>', ':GBrowse<cr>', {noremap = true, desc = 'browse current file on github'})
vim.keymap.set('v', '<C-g>', ':GBrowse<cr>', {noremap = true, desc = 'browse current file and line on github'})
vim.keymap.set('n', '<C-g><C-y>', ':GBrowse!<cr>', {noremap = true, desc = 'yank github url of the current file'})
vim.keymap.set('v', '<C-g><C-y>', ':GBrowse!<cr>', {noremap = true, desc = 'yank github url of the current line'})


-- [[ refactoring ]]
-- https://github.com/ThePrimeagen/refactoring.nvim
vim.api.nvim_set_keymap("v", "<leader>re", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>rf", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Function To File')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>rv", [[ <Esc><Cmd>lua require('refactoring').refactor('Extract Variable')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})
-- Extract block doesn't need visual mode
vim.api.nvim_set_keymap("n", "<leader>rb", [[ <Cmd>lua require('refactoring').refactor('Extract Block')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("n", "<leader>rbf", [[ <Cmd>lua require('refactoring').refactor('Extract Block To File')<CR>]], {noremap = true, silent = true, expr = false})
vim.api.nvim_set_keymap("n", "<leader>ri", [[ <Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]], {noremap = true, silent = true, expr = false})


-- [[ copilot ]]
-- https://github.com/github/copilot.vim
-- vim.g.copilot_autocomplete = 1
-- vim.g.copilot_autocomplete_delay = 100
-- function ToggleCopilot()
--   if vim.g.copilot_autocomplete == 1 then
--     vim.g.copilot_autocomplete = 0
--     vim.cmd('Copilot disable')
--     print('copilot off')
--   else
--     vim.g.copilot_autocomplete = 1
--     vim.cmd('Copilot enable')
--     print('copilot on')
--   end
-- end
-- vim.keymap.set('n', '<leader>cp', ':lua toggle_copilot()<cr>', {noremap = true, desc = 'toggle copilot'})

-- [[ tagbar ]]
vim.keymap.set('n', '<leader>t', ':Tagbar<cr>', {noremap = true, desc = 'toggle tagbar'})


-- [[ dap ]]
require("dapui").setup()
require("nvim-dap-virtual-text").setup({})
require("dap-python").setup(os.getenv('HOME') .. '/.virtualenvs/debugpy/bin/python')

local dap = require('dap')
vim.keymap.set('n', '<leader>B', function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, {noremap = true, desc = 'dap set breakpoint condition'})
vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint, {noremap = true, desc = 'dap toggle breakpoint'})
vim.keymap.set('n', '<leader>dc', dap.continue, {noremap = true, desc = 'dap continue'})

vim.keymap.set('n', '<leader>dh', dap.step_out, {noremap = true, desc = 'dap step out ←'})
vim.keymap.set('n', '<leader>dl', dap.step_into, {noremap = true, desc = 'dap step into →'})
vim.keymap.set('n', '<leader>dk', dap.step_back, {noremap = true, desc = 'dap step back ↑'})
vim.keymap.set('n', '<leader>dj', dap.step_over, {noremap = true, desc = 'dap step over ↓'})

vim.keymap.set('n', '<leader>de', dap.repl.open, {noremap = true, desc = 'dap open repl'})
vim.keymap.set('n', '<leader>dr', dap.run_last, {noremap = true, desc = 'dap run last'})
vim.keymap.set('n', '<leader>dq', dap.disconnect, {noremap = true, desc = 'dap disconnect'})

-- [[ dap:ui ]]
local dapui = require('dapui')
vim.keymap.set('n', '<leader>du', dapui.toggle, {noremap = true, desc = 'toggle dap ui'})
vim.keymap.set('n', '<leader>do', dapui.open, {noremap = true, desc = 'toggle dap ui'})
vim.keymap.set('n', '<leader>dx', dapui.close, {noremap = true, desc = 'toggle dap ui'})

-- [[ luasnip ]]
require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.getenv("DOTFILES") .. "/vim/vsnip" } })

local types = require('luasnip.util.types')
luasnip.config.set_config ({
  -- This tells LuaSnip to remember to keep around the last snippet.
  -- You can jump back into it even if you move outside of the selection
  history = false,

  -- This one is cool cause if you have dynamic snippets, it updates as you type!
  updateevents = "TextChanged,TextChangedI",

  -- Autosnippets:
  enable_autosnippets = true,

  -- Crazy highlights!!
  -- #vid3
  -- ext_opts = nil,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { " « ", "NonTest" } },
      },
    },
  },
})


-- [[ luasnip:snippets ]]
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
ls.add_snippets('all', {
    s('hola', t'hola mundo!')
})

ls.add_snippets('python', {
    s('pdb', t'__import__("pdb").set_trace()')
})

ls.add_snippets('python', {
    s('pm', t'__import__("pdb").pm()')
})

vim.keymap.set('n', '<leader>zz', '<cmd>ZenMode<cr>', { noremap = true, desc = 'ZenMode toggle'})



-- create function to swap booleans values in lua
-- so we can use it in mappings
-- e.g. False -> True, True -> False, 0 -> 1, 1 -> 0, false -> true, true -> false
function SwapBool()
  -- get current word
  local value_map = {
    ['True'] = 'False',
    ['False'] = 'True',
    ['true'] = 'false',
    ['false'] = 'true',
  }

  local word = vim.fn.expand("<cword>")
  local new = value_map[word]
  -- replace current word with new word
  vim.api.nvim_command("normal ciw" .. new)
end

vim.keymap.set('n', '<leader>sb', ':lua SwapBool()<cr>', {noremap = true, desc = 'swap boolean value'})

-- common mistake: prevent create a file 2
vim.api.nvim_command('cabbrev w2 w')

-- function to convert table tab separetaed into a python dict
function TabToDict()
    vim.cmd[[:'<,'>s/\t/": "/]]
    pcall(vim.cmd, [[:'<,'>s/\t/", "/g]])
    vim.cmd[[:'<,'>s/^/"/g]]
    vim.cmd[[:'<,'>s/$/",/g]]
    pcall(vim.cmd, [[normal :'<,'>s/""/None/g']])
    pcall(vim.cmd, [[normal :'<,'>s/"TRUE"/True/g']])
    vim.api.nvim_command("normal gVVc{\r}")
    vim.api.nvim_command("normal O")
    vim.api.nvim_command("normal P}dd")
    vim.api.nvim_command("normal vi{g=")
    -- vim.api.nvim_command("normal! dd")
end

vim.keymap.set('v', '<leader>td', ':lua TabToDict()<cr>', {noremap = true, desc = 'convert table to dict'})



function ToggleSlime(back)
  if back == 'harpoon' then
    vim.keymap.set('n', '<leader>e', ':lua SendToHarpoon(1, 0)<CR>', {noremap = false})
    vim.keymap.set('v', '<leader>e', ':lua SendToHarpoon(1, 1)<CR>', {noremap = false})
    print("Using harpoon")
  elseif back == 'slime' then
    vim.keymap.set('n', '<leader>e',  ':SlimeSend<cr>', {noremap = false, desc = 'send line to tmux'})
    vim.keymap.set('x', '<leader>e', '<Plug>SlimeRegionSend', {noremap = false, desc = 'send line to tmux'})
    print("Using Slime")
  end
end

ToggleSlime('slime')


require'nvim-treesitter.configs'.setup {
  textobjects = {

    select = {
      enable = true,

      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v', -- charwise
        ['@function.outer'] = 'V', -- linewise
        ['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = true,
    },

    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },

    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = { query = "@class.outer", desc = "Next class start" },
        --
        -- You can use regex matching and/or pass a list in a "query" key to group multiple queires.
        ["]o"] = "@loop.*",
        -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
        --
        -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
        -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
        ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
        ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
      -- Below will go to either the start or the end, whichever is closer.
      -- Use if you want more granular movements
      -- Make it even more gradual by adding multiple queries and regex.
      goto_next = {
        ["]d"] = "@conditional.outer",
      },
      goto_previous = {
        ["[d"] = "@conditional.outer",
      }
    },

  },
}


-- create scratch buffer with name and open it

function CreateScratch()
  local parent = './scratch'
  if vim.fn.isdirectory(parent) == 0 then
    parent = '.'
  end
  local num = 0
  local ext = '.py'
  local file = function(n) return vim.fn.expand(parent..'/'..n..ext) end

  while (vim.fn.filereadable(file(num)) == 0) and (num <= 1000) do
    num = num + 1
  end
  vim.cmd('10new ' .. file(num))

  -- vim.bo.buftype = '__scratch__'
  -- vim.bo.filetype = 'markdown'
  -- vim.bo.bufhidden = 'wipe'
  -- vim.bo.swapfile = false
  vim.bo.modifiable = true
  vim.bo.textwidth = 0
end

vim.keymap.set('n', '<leader>ss', ':lua CreateScratch()<cr>', {noremap = true, desc = 'create scratch buffer'})

-- [[ High-str ]]
local high_str = require("high-str")

high_str.setup({
	verbosity = 0,
	saving_path = "/tmp/highstr/",
	highlight_colors = {
		-- color_id = {"bg_hex_code",<"fg_hex_code"/"smart">}
		color_0 = {"#0c0d0e", "smart"},	-- Cosmic charcoal
		color_1 = {"#e5c07b", "smart"},	-- Pastel yellow
		color_2 = {"#7FFFD4", "smart"},	-- Aqua menthe
		color_3 = {"#8A2BE2", "smart"},	-- Proton purple
		color_4 = {"#FF4500", "smart"},	-- Orange red
		color_5 = {"#008000", "smart"},	-- Office green
		color_6 = {"#0000FF", "smart"},	-- Just blue
		color_7 = {"#FFC0CB", "smart"},	-- Blush pink
		color_8 = {"#FFF9E3", "smart"},	-- Cosmic latte
		color_9 = {"#7d5c34", "smart"},	-- Fallow brown
	}
})

vim.keymap.set("v", "<leader>h", ":<c-u>HSHighlight 2<cr>", {noremap = true, desc = 'high-str'})
-- vim.keymap.set("n", "<leader>h", ":<c-u>HSHighlight 2<cr>", {noremap = true, desc = 'high-str'})

vim.keymap.set("v", "<C-c>", "\"0y", {noremap = true, desc = 'yank to clipboard'})
vim.keymap.set("n", "<C-c>", "\"0yy", {noremap = true, desc = 'yank to clipboard'})

vim.keymap.set('n', '<C-v><C-v>', '"0p', { desc = 'Paste 0 register' })
vim.keymap.set('i', '<C-v>', '<C-r>0', { desc = 'Paste 0 register' })

vim.keymap.set('n', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('v', '<leader>p', '"+p', { desc = 'Paste clipboard register' })
vim.keymap.set('n', '<leader>y', '"+yy', {noremap = true, desc = 'copy to system clipboard'})
vim.keymap.set('v', '<leader>y', '"+y', {noremap = true, desc = 'copy to system clipboard'})
vim.keymap.set('n', '<leader>yf', ':let @+ = expand("%:p")<cr>', {noremap = true, desc = 'yank filename/buffer path'})

-- local BigQuery = vim.api.nvim_create_augroup("BigQuery", {})
-- vim.api.nvim_create_autocmd({"BufEnter"}, {
-- 	group = BigQuery,
--   pattern = '*.bigquery',
--   callback = function(ev)
--     if ev.file and ev.file:match('%.bigquery$') then
--       vim.bo.filetype = 'sql'
--       print('BigQuery filetype set')
--     end
--   end,
-- })
--
-- local BQ = {
--   win_term = nil,
--   win_buf = nil,
-- }
-- vim.api.nvim_create_autocmd({"BufWritePost"}, {
--   group = BigQuery,
--   pattern = '*.bigquery',
--   callback = function(ev)
--     if ev.file and ev.file:match('%.bigquery$') then
--       if BQ.win_buf == nil then
--         BQ.win_buf = vim.api.nvim_get_current_win()
--       end
--       local buf = vim.fn.expand('%')
--       local cmd = "bq query --format sparse --nouse_legacy_sql" .. buf
--       local cmd_map = ':lua require("harpoon.term").sendCommand(12, '..cmd..')<cr>'
--       -- vim.keymap.lset('n', '<leader><cr>', ':lua harpoon.send()<cr>', {desc = 'create scratch buffer'})
--       -- vim.keymap.set('n', '<leader><cr>', ':lua require("harpoon.term").gotoTerminal(12)<cr>', { noremap = true } )
--       --
--       vim.keymap.lset('n', '<leader><cr>', cmd_map, { noremap = true } )
--
--       vim.fn.execute('vnew')
--       require("harpoon.term").gotoTerminal(12)
--       local win_term = vim.api.nvim_get_current_win()
--
--       vim.api.nvim_set_current_win(win_buf)
--       print('BigQuery filetype set')
--     end
--   end,
-- })

-- sniprun
require'sniprun'.setup({
  selected_interpreters = {},     --# use those instead of the default for the current filetype
  repl_enable = {},               --# enable REPL-like behavior for the given interpreters
  repl_disable = {},              --# disable REPL-like behavior for the given interpreters

  interpreter_options = {         --# interpreter-specific options, see docs / :SnipInfo <name>

    --# use the interpreter name as key
    GFM_original = {
      use_on_filetypes = {"markdown.pandoc"}    --# the 'use_on_filetypes' configuration key is
                                                --# available for every interpreter
    },
    Python3_original = {
        error_truncate = "auto"         --# Truncate runtime errors 'long', 'short' or 'auto'
                                        --# the hint is available for every interpreter
                                        --# but may not be always respected
    }
  },

  --# you can combo different display modes as desired and with the 'Ok' or 'Err' suffix
  --# to filter only sucessful runs (or errored-out runs respectively)
  display = {
    "Classic",                    --# display results in the command-line  area
    "VirtualTextOk",              --# display ok results as virtual text (multiline is shortened)

    -- "VirtualText",             --# display results as virtual text
    -- "TempFloatingWindow",      --# display results in a floating window
    -- "LongTempFloatingWindow",  --# same as above, but only long results. To use with VirtualText[Ok/Err]
    -- "Terminal",                --# display results in a vertical split
    -- "TerminalWithCode",        --# display results and code history in a vertical split
    -- "NvimNotify",              --# display with the nvim-notify plugin
    -- "Api"                      --# return output to a programming interface
  },

  live_display = { "VirtualTextOk" }, --# display mode used in live_mode

  display_options = {
    terminal_width = 45,       --# change the terminal display option width
    notification_timeout = 5   --# timeout for nvim_notify output
  },

  --# You can use the same keys to customize whether a sniprun producing
  --# no output should display nothing or '(no output)'
  show_no_output = {
    "Classic",
    "TempFloatingWindow",      --# implies LongTempFloatingWindow, which has no effect on its own
  },

  --# customize highlight groups (setting this overrides colorscheme)
  snipruncolors = {
    SniprunVirtualTextOk   =  {bg="#66eeff",fg="#000000",ctermbg="Cyan",cterfg="Black"},
    SniprunFloatingWinOk   =  {fg="#66eeff",ctermfg="Cyan"},
    SniprunVirtualTextErr  =  {bg="#881515",fg="#000000",ctermbg="DarkRed",cterfg="Black"},
    SniprunFloatingWinErr  =  {fg="#881515",ctermfg="DarkRed"},
  },

  live_mode_toggle='off',     --# live mode toggle, see Usage - Running for more info

  --# miscellaneous compatibility/adjustement settings
  inline_messages = 0,        --# inline_message (0/1) is a one-line way to display messages
                              --# to workaround sniprun not being able to display anything

  borders = 'single',         --# display borders around floating windows
                              --# possible values are 'none', 'single', 'double', or 'shadow'
})

-- print('SnipRun loaded')

vim.api.nvim_set_keymap('v', 'f', '<Plug>SnipRun', {silent = true})
vim.api.nvim_set_keymap('n', '<leader>f', '<Plug>SnipRunOperator', {silent = true})
vim.api.nvim_set_keymap('n', '<leader>fl', '<Plug>SnipRun', {silent = true})

-- remap ESC to kj
-- vim.api.nvim_set_keymap('i', 'hh', '<Esc>', {noremap = true})
-- vim.api.nvim_set_keymap('v', 'hh', '<Esc>', {noremap = true})
-- vim.api.nvim_set_keymap('n', 'hh', '<Esc>', {noremap = true})
-- vim.api.nvim_set_keymap('t', 'hh', '<Esc>', {noremap = true})


-- vim:ts=2 sts=2 sw=2 et
