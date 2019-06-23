
let s:desc1 = {
      \   'layout': ['leaf']
      \ }

let s:desc2 = {
      \   'layout': [
      \     'row', [
      \       ['leaf'],
      \       ['leaf']
      \     ]
      \   ],
      \ }

let s:desc31 = {
      \   'layout': [
      \     'row', [
      \       ['leaf'],
      \       [
      \         'col',
      \         [
      \           ['leaf'],
      \           ['leaf']
      \         ]
      \       ]
      \     ]
      \   ],
      \ }

let s:desc32 = {
      \   'layout': [
      \     'row', [
      \       ['leaf'],
      \       ['leaf'],
      \       ['leaf']
      \     ]
      \   ],
      \   'range': [2, 1, 3]
      \ }

let s:desc41 = {
      \   'layout': [
      \     'row', [
      \       ['leaf'],
      \       ['leaf'],
      \       [
      \         'col',
      \         [
      \           ['leaf'],
      \           ['leaf']
      \         ]
      \       ]
      \     ]
      \   ],
      \   'range': [2, 1, 3, 4]
      \ }

let s:desc42 = {
      \   'layout': [
      \     'row', [
      \       [
      \         'col',
      \         [
      \           ['leaf'],
      \           ['leaf']
      \         ]
      \       ],
      \       [
      \         'col',
      \         [
      \           ['leaf'],
      \           ['leaf']
      \         ]
      \       ]
      \     ]
      \   ],
      \   'range': [1, 3, 2, 4]
      \ }

let s:desc51 = {
      \   'layout': [
      \     'row', [
      \       [
      \         'col',
      \         [
      \           ['leaf'],
      \           ['leaf']
      \         ]
      \       ],
      \       ['leaf'],
      \       [
      \         'col',
      \         [
      \           ['leaf'],
      \           ['leaf']
      \         ]
      \       ]
      \     ]
      \   ],
      \   'range': [3, 1, 2, 4, 5]
      \ }

let s:desc52 = {
      \   'layout': [
      \     'row', [
      \       ['leaf'],
      \       [
      \         'col',
      \         [
      \           ['leaf'],
      \           ['leaf']
      \         ]
      \       ],
      \       [
      \         'col',
      \         [
      \           ['leaf'],
      \           ['leaf']
      \         ]
      \       ]
      \     ]
      \   ],
      \   'range': [1, 2, 3, 4, 5]
      \ }

let s:desc6 = {
      \   'layout': [
      \     'row', [
      \       [
      \         'col',
      \         [
      \           ['leaf'],
      \           ['leaf']
      \         ]
      \       ],
      \       [
      \         'col',
      \         [
      \           ['leaf'],
      \           ['leaf']
      \         ]
      \       ],
      \       [
      \         'col',
      \         [
      \           ['leaf'],
      \           ['leaf']
      \         ]
      \       ]
      \     ]
      \   ],
      \ }

let s:desc = {
      \   '1': s:desc1,
      \   '2': s:desc2,
      \   '3': s:desc31,
      \   '31': s:desc31,
      \   '32': s:desc32,
      \   '4': s:desc41,
      \   '41': s:desc41,
      \   '42': s:desc42,
      \   '5': s:desc51,
      \   '51': s:desc51,
      \   '52': s:desc52,
      \   '6': s:desc6
      \ }

function! winmanager#desc#getRange(num)
  let desc = winmanager#desc#get(a:num)

  if !winmanager#utils#isExists(desc)
    let layout = winlayout()
    let curlen = winmanager#desc#getWindowLength(layout)
    return winmanager#desc#defaultRange(curlen)
  endif

  let range = winmanager#utils#getVal(desc, 'range')
  if !winmanager#utils#isExists(range)
    let range = winmanager#desc#defaultRange(a:num)
  endif
  return range
endfunction

function! winmanager#desc#getWindowLength(layout)
  let winids = winmanager#desc#getWindowIds(layout)
  return len(winids)
endfunction

function! winmanager#desc#getRangedBufNrs(range)
  let bufnrs = []
  for i in a:range
    call add(bufnrs, winbufnr(i))
  endfor
  return bufnrs
endfunction

function! winmanager#desc#defaultRange(numb)
  let num = winmanager#utils#getMainNum(a:numb)
  let result = []
  let i = 0
  while i < num
    let i += 1
    call add(result, i)
  endwhile
  return result
endfunction

function! winmanager#desc#getWindowIds(layout)
  let ids = []
  let stack = [a:layout]
  while len(stack) > 0
    let val = stack[-1]
    let stack = stack[0:-2]

    if val[0] != 'leaf'
      let stack = stack + val[1]
    else
      call add(ids, val[1])
    endif
  endwhile

  return ids
endfunction

function! IsMatch(layout, desc)
  if a:layout[0] != a:desc[0]
    return v:false
  endif

  if len(a:desc) == 1
    return v:true
  endif

  if len(a:layout[1]) != len(a:desc[1])
    return v:false
  endif

  let i = 0

  while i < len(a:desc[1])
    if !IsMatch(a:layout[1][i], a:desc[1][i])
      return v:false
    endif
    let i += 1
  endwhile

  return v:true
endfunction

function! winmanager#desc#get(num)
  return winmanager#utils#getVal(s:desc, a:num)
endfunction

function! winmanager#desc#num(layout)
  let nums = keys(s:desc)
  let nums = winmanager#utils#sortNums(nums)
  for num in nums
    if IsMatch(a:layout, s:desc[num]['layout'])
      return num
    endif
  endfor
  return -1
endfunction

