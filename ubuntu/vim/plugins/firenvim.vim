" ==== firefnvim
let g:firenvim_config = {
    \ 'globalSettings': {
        \ 'alt': 'all',
    \  },
    \ 'localSettings': {
        \ '.*': {
            \ 'cmdline': 'neovim',
            \ 'content': 'text',
            \ 'priority': 0,
            \ 'selector': 'textarea',
            \ 'takeover': 'always',
        \ },
     \ 'gist.github.com': { 'selector': 'textarea, *[contenteditable="true"]', 'priority': 1 }
    \ }
\ }

let fc = g:firenvim_config['localSettings']
let fc['https?://instagram.com.*'] = { 'takeover': 'never', 'priority': 1 }
let fc['https?://writeandimprove.com.*'] = { 'takeover': 'never', 'priority': 1 }
let fc['https?://twitter.com.*'] = { 'takeover': 'never', 'priority': 1 }
let fc['https://.*gmail.com.*'] = { 'takeover': 'never', 'priority': 1 }
let fc['https?://.*twitch.tv.*'] = { 'takeover': 'never', 'priority': 1 }
let fc['https?://app.shortcut.com*'] = { 'takeover': 'never', 'priority': 1 }
let fc['https?://console.cloud.google.com/bigquery*'] = { 'takeover': 'never', 'priority': 1 }

let fc['https?://.*'] = { 'takeover': 'never', 'priority': 1 }

augroup firenvim
    autocmd!
    au BufEnter github.com_*.txt set filetype=markdown
    au BufEnter txti.es_*.txt set filetype=markdown
    au BufEnter stackoverflow_*.txt filetype=markdown
augroup END
