
function StartDrawit()

    call DrawIt#DrawItStart()
    setl timeoutlen=100
    setl ve=all
    nnoremap <buffer> J :call DrawIt#DrawDown()<cr>
    nnoremap <buffer> K :call DrawIt#DrawUp()<cr>
    nnoremap <buffer> L :call DrawIt#DrawRight()<cr>
    nnoremap <buffer> H :call DrawIt#DrawLeft()<cr>
    nnoremap <buffer> JL :call DrawIt#DrawSlantDownRight()<cr>
    nnoremap <buffer> JH :call DrawIt#DrawSlantDownLeft()<cr>
    nnoremap <buffer> KL :call DrawIt#DrawSlantUpRight()<cr>
    nnoremap <buffer> KH :call DrawIt#DrawSlantUpLeft()<cr>

endfunction


function StopDrawit()

    call DrawIt#DrawItStop()
    mapclear <buffer>
    setl timeoutlen=400
    setl ve=
    unmap <buffer> J
    unmap <buffer> K
    unmap <buffer> L
    unmap <buffer> H
    unmap <buffer> JL
    unmap <buffer> JH
    unmap <buffer> KL
    unmap <buffer> KH

endfunction

nnoremap <leader>di :call StartDrawit()<cr>
nnoremap <leader>dx :call StopDrawit()<cr>
