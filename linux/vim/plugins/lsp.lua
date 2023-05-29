-- vim.lsp.set_log_level("debug")
-- Setup nvim-cmp.
local cmp = require('cmp')

cmp.setup({
    snippet = {
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For vsnip user.
      end,
    },

    mapping = {
      ['<C-s>'] = cmp.mapping.complete({
        config = {
          sources = {
            { name = 'vsnip' }
          }
        }
      }),
      -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
      ['<C-l>'] = cmp.mapping.complete(),
      ['<C-l>'] = cmp.mapping.confirm({ select = true }),
      ['<C-e>'] = cmp.mapping.close(),
    },

    sources = {
      { name = 'nvim_lsp' },
      { name = 'vsnip' },
      { name = 'buffer' },
      { name = 'orgmode' },
      { name = 'path' },
      { name = 'nvim_lsp_signature_help' },
      { name = 'neorg' },
    }
})

-- manual installations
local function on_attach()
    -- vim.lsp.buf.remove_workspace_folder(".venv")
end

-- local function py_on_attach()
--     vim.lsp.buf.remove_workspace_folder(".venv")
-- end

-- LspInstall side
-- local lsp_installer = require("nvim-lsp-installer")
local lsp_installer_servers = require("nvim-lsp-installer.servers")


local function setup_server(server_name)
    -- print(vim.inspect(server_name))
    local server_available, requested_server = lsp_installer_servers.get_server(server_name)

    if server_available then
        -- print("on_ready: ", vim.inspect(server_name))
        requested_server:on_ready(
            function ()
                local opts = {}
                opts.on_attach = on_attach
                opts.capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

                -- if requested_server.name == "pyright" then
                --     opts.settings = { pyright = { disableLanguageServices = false, ignore = "deps" } }
                -- end

                if requested_server.name == "clangd" then
                    opts.root_dir = function() return vim.loop.cwd() end
                end
                requested_server:setup(opts)
            end
        )

    if not requested_server:is_installed() then
        -- print("installing: ", vim.inspect(server_name))
        requested_server:install()
        end
    end

end

-- local function config(_config)
--     return vim.tbl_deep_extend("force", {
--         on_attach = on_attach,
--         capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities()),
--     }, _config or {})
-- end


-- setup_server("bashls")
setup_server("bashls")
-- setup_server("clangd")
-- setup_server("clangd")
-- setup_server("cssmodules_ls")
setup_server("dockerls")
-- setup_server("efm")
-- setup_server("eslint")
-- setup_server("gopls")
setup_server("gopls")
-- setup_server("groovyls")
setup_server("html")
setup_server("jsonls")
-- setup_server("lemminx")
-- setup_server("pylsp")
setup_server("pyright")
-- setup_server("sqlls")
setup_server("sumneko_lua")
-- setup_server("texlab")
setup_server("tsserver")
setup_server("vimls")
setup_server("yamlls")


