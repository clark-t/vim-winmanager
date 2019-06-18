
let s:desc1 = {
  'split': [1],
  'range': [1]
}

let s:desc2 = {
  'split': [1, 1],
}

let s:desc31 = {
  'split': [1, 2],
}

let s:desc32 = {
  'split': [1, 1, 1],
}

let s:desc41 = {
  'split': [2, 2],
  'range': [1, 3, 2, 4]
}

let s:desc42 = {
  'split': [1, 1, 2],
}

let s:desc51 = {
  'split': [1, 2, 2],
  'range': [1, 2, 3, 4, 5]
}

let s:desc52 = {
  'split': [2, 1, 2],
  'range': [3, 1, 2, 4, 5]
}

let s:desc6 = {
  'split': [2, 2, 2],
}

let s:windowDesc = {
  '1': s:desc1,
  '2': s:desc2,
  '3': s:desc31,
  '31': s:desc31,
  '32': s:desc32,
  '4': s:desc41,
  '41': s:desc41,
  '42': s:desc42,
  '5': s:desc51,
  '51': s:desc51,
  '52': s:desc52,
  '6': s:desc6
}

function! winmanager#getWindowDesc(num)
  return get(s:windowDesc, num, [])
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


