
function! winmanager#go#exec(num)
  call win_gotoid(win_getid(a:num))
endfunction


