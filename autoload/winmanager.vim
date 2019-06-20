
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
      \ }

let s:desc41 = {
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

let s:desc42 = {
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
      \ }

let s:desc51 = {
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

let s:desc52 = {
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

let g:gg = s:desc

function! GetWindowDesc(num)
  return get(s:desc, a:num, [])
endfunction

function! GetWindowIds()
  let s:layout = winlayout()
  let s:ids = []
  let s:stack = [s:layout]
  while len(s:stack) > 0
    let s:val = s:stack[-1]
    let s:stack = s:stack[0:-2]

    if s:val[0] != 'leaf'
      let s:stack = s:stack + s:val[1]
    else
      call add(s:ids, s:val[1])
    endif
  endwhile

  return s:ids
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


function! GetItem(...)
  let lengthOfArgs = a:0
  let layout = a:1
  let nums = a:000[1:]

  let i = 0
  while i < len(nums)
    if layout[0] == 'leaf'
      if i == 0
        let i += 1
        break
      else
        return -1
      endif
    endif
    if nums[i] < len(layout[1])
      let layout = layout[1][nums[i]]
      let i += 1
    else
      return -1
    endif
  endwhile

  if i < len(nums)
    return -1
  endif

  return layout
endfunction


function! GetDesc(num)
  return get(s:desc, a:num, {})
endfunction

function! GetNum(layout)
  let nums = keys(s:desc)
  let nums = SortNums(nums)
  for num in nums
    if IsMatch(a:layout, s:desc[num]['layout'])
      return num
    endif
  endfor
  return -1
endfunction

function! Insert(arr, i, item)
  if a:i == 0
    return [a:item] + a:arr
  endif

  if a:i == len(a:arr)
    return a:arr + [a:item]
  endif

  return a:arr[:(a:i - 1)] + [a:item] + a:arr[a:i:]
endfunction

function! SortNums(nums)
  let result = []
  for num in a:nums
    let lenOfResult = len(result)

    if lenOfResult == 0
      call add(result, num)
      continue
    endif

    let i = 0
    while i < lenOfResult
      let sorted = result[i]
      let mainNum = num > 10 ? (num - num % 10) / 10 : num
      let mainSorted = sorted > 10 ? (sorted - sorted % 10) / 10 :sorted

      if mainNum > mainSorted
        let result = Insert(result, i, num)
        break
      elseif mainNum == mainSorted
        if num < sorted
          let result = Insert(result, i, num)
          break
        endif
      endif

      let i += 1
    endwhile

    if i == lenOfResult
      call add(result, num)
    endif
  endfor

  return result
endfunction

