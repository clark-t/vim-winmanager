
let s:layoutStore = {}

function! StoreBufNrs(num, nrs)
  if type(a:nrs) == v:t_number
    return v:false
  endif
  let s:layoutStore[a:num] = a:nrs
  return v:true
endfunction

function! GetStoredBufNr(num, oldNum)
  let result = winmanager#utils#getVal(s:layoutStore, a:num)
  if winmanager#utils#isExists(result)
    return result
  endif

  let allKeys = keys(s:layoutStore)
  let lenOfKeys = len(allKeys)
  if lenOfKeys == 0
    return -1
  endif
  let allKeys = winmanager#utils#sortNums(allKeys)
  call reverse(allKeys)
  let mainNum = winmanager#utils#getMainNum(a:num)
  for i in allKeys
    let storedMainNum = winmanager#utils#getMainNum(i)
    if mainNum <= storedMainNum
      return s:layoutStore[i]
    endif
  endfor

  call reverse(allKeys)
  let oldMainNum = winmanager#utils#getMainNum(a:oldNum)
  for i in allKeys
    let storedMainNum = winmanager#utils#getMainNum(i)
    if a:oldNum < storedMainNum
      return s:layoutStore[i]
    endif
  endfor
  return -1
endfunction

function! winmanager#split#main(...) abort
  if a:0 == 0
    call winmanager#split#refresh()
  else
    call winmanager#split#exec(a:1)
  endif
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
    let stored = GetStoredBufNr(a:num, oldNum)
    if winmanager#utils#isExists(stored)
      let i = oldLen
      let minLen = winmanager#utils#min(len(stored), newLen)
      while i < minLen
        call winmanager#go#exec(newRange[i])
        silent execute "normal! :b " . stored[i] . "\<CR>"
        let i += 1
      endwhile
    endif
  endif

  call winmanager#go#exec(newRange[0])
endfunction

function! winmanager#split#refresh() abort
  let layout = winlayout()
  let num = winmanager#desc#num(layout)
  call winmanager#split#exec(num)
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


