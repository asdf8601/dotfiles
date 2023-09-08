-- Packer
-- This file can be loaded by calling `lua require('plugins')` from your init.vim
-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function()
  -- Packer can manage itself
	use('wbthomason/packer.nvim')

	use('rcarriga/nvim-notify')
	use('fatih/vim-go')
	use('sbdchd/neoformat')

	use('L3MON4D3/LuaSnip')

	use('ckipp01/nvim-jenkinsfile-linter')
	use('tmhedberg/SimpylFold')
	use('Konfekt/FastFold')
	use('cespare/vim-toml')
	use('chrisbra/csv.vim')
	use('dhruvasagar/vim-table-mode')
	use('gko/vim-coloresque')  -- show color of an color expression (hex, rgb)
	use('godlygeek/tabular')
	use('goerz/jupytext.vim')
	use('gruvbox-community/gruvbox')
	use('gyim/vim-boxdraw')
	use('hoob3rt/lualine.nvim')
	use('hrsh7th/nvim-cmp')
	    use('hrsh7th/cmp-buffer')
	    use('hrsh7th/cmp-path')
	    use('hrsh7th/cmp-nvim-lsp')
	    use('hrsh7th/cmp-nvim-lua')
	    use('hrsh7th/vim-vsnip')
	    use('hrsh7th/vim-vsnip-integ')
	-- install without yarn or npm
	use({
	    "iamcco/markdown-preview.nvim",
	    run = function() vim.fn["mkdp#util#install"]() end,
	})

	use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install", setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" }, })
	use('itchyny/calendar.vim')
	use('kristijanhusak/vim-carbon-now-sh')
	use('kyazdani42/nvim-web-devicons')
	use('lervag/vimtex')
	use('majutsushi/tagbar')
	use('mattn/emmet-vim')
	use('mattn/gist-vim')
	use('mattn/webapi-vim')
	use('mbbill/undotree')
	use('mmngreco/slimux')
	use('neovim/nvim-lspconfig')
	use('numToStr/Comment.nvim')
	use('nvie/vim-flake8')
	use('nvim-lua/plenary.nvim')
	use('nvim-lua/popup.nvim')
	use({ 'nvim-telescope/telescope.nvim', requires = {{'nvim-lua/popup.nvim'}, {'nvim-lua/plenary.nvim'}} })

	use({'nvim-telescope/telescope-fzf-native.nvim', run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' })

	use({
        'nvim-treesitter/nvim-treesitter',
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
	    })
	use('sainnhe/gruvbox-material')
	use('sbdchd/neoformat')
	use('shumphrey/fugitive-gitlab.vim') -- allow open gitlab url
	use('szw/vim-maximizer')
	use('ThePrimeagen/git-worktree.nvim')
	use('ThePrimeagen/harpoon')
	use('ThePrimeagen/refactoring.nvim')
	use('tpope/vim-abolish')
	use('tpope/vim-dadbod')  -- database interface
	use('tpope/vim-dispatch')  -- compiler + make = dispatch
	use('tpope/vim-fugitive')  -- offers git commands in vim
	use('tpope/vim-markdown')
	use('tpope/vim-obsession')
	use('tpope/vim-repeat')
	use('tpope/vim-rhubarb')  -- allow open github urls
	use('tpope/vim-speeddating')
	use('tpope/vim-surround')
	use('tpope/vim-unimpaired')
	use('tpope/vim-vinegar')  -- better netrw
	use('tyru/open-browser.vim')
	use('vim-pandoc/vim-pandoc')
	use('vim-pandoc/vim-pandoc-syntax')
	use('vim-test/vim-test')
	use('wellle/targets.vim')  -- text wrapper: cin
	use('williamboman/nvim-lsp-installer')
	use({'xuhdev/vim-latex-live-preview', ft = {'tex'} })
	use("TimUntersberger/neogit")
    use({ 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' })


end)

