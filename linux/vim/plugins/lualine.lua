require('lualine').setup({
    options = {
        icons_enabled = true,
        theme = 'catppuccin',
        separator = { left = '', right = ''},
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
        lualine_x = {'encoding', 'fileformat', 'filetype'},
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
