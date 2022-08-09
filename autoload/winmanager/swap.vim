
function! winmanager#swap#exec(...)
  if exists('g:vim_winmanager_command_before_swap')
    silent execute g:vim_winmanager_command_before_swap
  endif

  let winid = win_getid()

  let winnrs = []
  if a:0 == 0
    let winnrs = ['1', '2']
  else
    if a:0 == 1
      let winnrs = [winnr(), a:1]
    else
      let winnrs = [a:1, a:2]
    end
  endif

  let bufnrs = []
  for nr in winnrs
    let buf = winbufnr(nr)
    if buf == -1
      execute "normal :echoerr '[" . nr . "] is not a valid number'\<CR>"
      return
    endif
    call add(bufnrs, buf)
  endfor

  call reverse(bufnrs)
  let i = 0
  let length = len(winnrs)

  while i < length
    call winmanager#go#exec(winnrs[i])
    silent execute "normal! :b! " . bufnrs[i] . "\<CR>"
    let i += 1
  endwhile

  call win_gotoid(winid)

  if exists('g:vim_winmanager_command_after_swap')
    silent execute g:vim_winmanager_command_after_swap
  endif
endfunction


