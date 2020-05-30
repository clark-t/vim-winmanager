
function! winmanager#send#exec(winnumber)
  let winId = win_getid()
  let curBufNr = winbufnr(winId)
  call winmanager#go#exec(a:winnumber)
  silent execute "normal! :b " . curBufNr . "\<CR>"
  call win_gotoid(winId)
endfunction

