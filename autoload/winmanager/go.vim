
function! winmanager#go#exec(num)
  if exists('g:vim_winmanager_command_before_go')
    silent execute g:vim_winmanager_command_before_go
  endif

  call win_gotoid(win_getid(a:num))

  if exists('g:vim_winmanager_command_after_go')
    silent execute g:vim_winmanager_command_after_go
  endif
endfunction

