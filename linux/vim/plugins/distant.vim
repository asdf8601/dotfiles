lua <<EOL
local actions = require('distant.nav.actions')
require('distant').setup {
    -- Any settings defined here are applied to all hosts
    ['*'] = {
        distant = {
            args = '--shutdown-after 3600',
            },
        file = {
            mappings = {
                ['-']         = actions.up,
                },
            },
        dir = {
            mappings = {
                ['<Return>']  = actions.edit,
                ['-']         = actions.up,
                ['K']         = actions.mkdir,
                ['N']         = actions.newfile,
                ['R']         = actions.rename,
                ['D']         = actions.remove,
                }
            },
        },
    ['linode'] = {
        mode = 'ssh',
        ssh = {
            user = 'root',
            port = '22'
            }
        },
}
EOL

nnoremap <leader>ssh :Distant 139.162.167.149 ssh.user=root ssh.port=22 mode=ssh<cr>
nnoremap <leader>ssh :Distant do_etl ssh.user=mgreco ssh.port=22 mode=ssh<cr>
nnoremap <leader>. :DistantOpen .<cr>
