" ==== grepper
let g:grepper = {}
let g:grepper.tools = ['ag', 'rg', 'git']
let g:grepper.jump = 1
let g:grepper.next_tool = '<leader>g'
let g:grepper.simple_prompt = 1
let g:grepper.quickfix = 0
nnoremap <leader>* :Grepper -tool ag -cword -noprompt<cr>
nnoremap <leader>g :Grepper -tool ag<cr>
