
let s:layoutStore = {}

function! StoreBufNrs(num, nrs)
  if type(a:nrs) == v:t_number
    return v:false
  endif
  let s:layoutStore[a:num] = a:nrs
  return v:true
endfunction

function! winmanager#split#exec(num) abort
  let oldLayout = winlayout()
  let oldNum = winmanager#desc#num(oldLayout)
  let oldRange = winmanager#desc#getRange(oldNum)
  let oldBufNrs = winmanager#desc#getRangedBufNrs(oldRange)
  if oldNum > 0
    call StoreBufNrs(oldNum, oldBufNrs)
  endif

  call winmanager#go#exec(oldRange[0])

  call SplitWindow(a:num)

  let newRange = winmanager#desc#getRange(a:num)
  let i = 0
  let oldLen = len(oldBufNrs)
  let newLen = len(newRange)
  let minLen = winmanager#utils#min(oldLen, newLen)
  while i < minLen
    call winmanager#go#exec(newRange[i])
    silent execute "normal! :b " . oldBufNrs[i] . "\<CR>"
    let i += 1
  endwhile

  if newLen > oldLen
    let stored = winmanager#utils#getVal(stored)
    if winmanager#utils#isExists(stored)
      let i = oldLen
      while i < newLen
        call winmanager#go#exec(newRange[i])
        silent execute "normal! :b " . stored[i] . "\<CR>"
        let i += 1
      endwhile
    endif
  endif
  call winmanager#go#exec(newRange[0])
endfunction


function! SplitWindow(num)
  let desc = winmanager#desc#get(a:num)
  if !winmanager#utils#isExists(desc)
    execute "normal! :echo 'split to window type[" . a:num  . "] is not avaliable now'\<CR>"
    return
  endif

  silent execute "normal! :only!\<CR>"

  call Split(win_getid(), desc.layout)
endfunction

function! Split(winid, layout)
  call win_gotoid(a:winid)

  if a:layout[0] == 'leaf'
    " the end
    return
  elseif a:layout[0] == 'col'
    for i in a:layout[1][1:]
      silent execute "normal! :split\<CR>"
    endfor
    for i in a:layout[1]
      call Split(win_getid(), i)
      silent execute "normal! \<C-w>\<C-j>"
    endfor
  else
    for i in a:layout[1][1:]
      silent execute "normal! :vsplit\<CR>"
    endfor
    for i in a:layout[1]
      call Split(win_getid(), i)
      silent execute "normal! \<C-w>\<C-l>"
    endfor
  endif
endfunction


