" ==== arduino
let g:arduino_dir=$ARDUINO_BIN
let g:arduino_args = '--verbose-upload'
let g:arduino_board = 'rduino:avr:mega:cpu=atmega2560'
let g:arduino_use_slime = 0
let g:arduino_serial_tmux = ''
let g:arduino_upload_tmux = ''
let g:arduino_serial_port = '/dev/ttyACM0'
autocmd BufNewFile,BufRead *.ino let g:airline_section_x='%{MyStatusLine()}'
" nnoremap <leader>au :ArduinoUpload<CR>
" nnoremap <leader>aU :ArduinoUploadAndSerial<CR>
let g:arduino_serial_tmux = 'split-window -d -p20'
let g:arduino_upload_tmux = 'split-window -d -p20'
nnoremap <leader>m :make!<CR>
nnoremap <leader>s :ArduinoSerial<CR>

