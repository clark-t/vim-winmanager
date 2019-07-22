
function! winmanager#send#exec(winnumber)
  let winId = win_getid()
  let curBufNr = winbufnr(winId)
  call winmanager#go#exec(winnumber)
  silent execute "normal! :e " . curBufNr . "\<CR>"
  call win_gotoid(winId)
endfunction

