
let s:desc1 = {
  'split': ['leaf'],
  'range': [1]
}

let s:desc2 = {
  'split': [
    'row', [
      ['leaf'],
      ['leaf']
    ]
  ]
}

let s:desc31 = {
  'split': [
    'row', [
      ['leaf'],
      [
        'col', [
          ['leaf'],
          ['leaf']
        ]
      ]
    ]
  ]
}

let s:desc32 = {
  'split': [
    'row': [
      ['leaf'],
      ['leaf'],
      ['leaf']
    ]
  ]
}

let s:desc41 = {
  'split': [
    'row', [
      [
        'col', [
          ['leaf'],
          ['leaf']
        ]
      ],
      [
        'col', [
          ['leaf'],
          ['leaf']
        ]
      ]
    ]
  ],
  'range': [1, 3, 2, 4]
}

let s:desc42 = {
  'split': [
    'row': [
      ['leaf'],
      ['leaf'],
      [
        'col', [
          ['leaf'],
          ['leaf']
        ]
      ]
    ]
  ]
}

let s:desc51 = {
  'split': [
    'row': [
      ['leaf'],
      [
        'col', [
          ['leaf'], ['leaf']
        ]
      ],
      [
        'col', [
          ['leaf'], ['leaf']
        ]
      ]
    ]
  ],
  'range': [1, 2, 3, 4, 5]
}

let s:desc52 = {
  'split': [
    'row': [
      [
        'col', [
          ['leaf'], ['leaf']
        ]
      ],
      ['leaf'],
      [
        'col', [
          ['leaf'], ['leaf']
        ]
      ]
    ]
  ],
  'range': [3, 1, 2, 4, 5]
}

let s:desc6 = {
  'split': [
    'row': [
      [
        'col', [
          ['leaf'], ['leaf']
        ]
      ],
      [
        'col', [
          ['leaf'], ['leaf']
        ]
      ],
      [
        'col', [
          ['leaf'], ['leaf']
        ]
      ]
    ]
  ]
}

let s:desc = {
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

function! winmanager#desc(num)
  return get(s:desc, num, [])
endfunction

function! LengthOfLayout(layout)
  if layout[0] == 'leaf'
    return 1
  elseif
    return len(layout[1])
  endif
endfunction

function! GetItem(layout, num)
  if a:layout[0] == 'leaf'
    return a:layout
  else
    return a:layout[1][a:num]
  endif
endfunction

function! IsMatch(layout, desc)
  if a:layout[0] != a:desc[0]
    return v:false
  endif

  let l:descs = a:desc[1]
  if type(l:descs) != v:t_list
    return v:true
  endif

  let l:children = a:layout[1]
  let i = 0
  let lenOfChilren = len(l:descs)
  while i < lenOfChilren
    if !MatchLayout(l:children[i], l:descs[i])
      return v:false
    endif
    let i += 1
  endwhile

  return v:true
endfunction

function! winmanager#num()
  let layout = winlayout()

  let nums = keys(s:desc)

  for l:num in nums
    let desc = s:desc[l:num]
    if IsMatch(layout, desc['split'])
      return l:num
    endif
  endfor

  return -1
endfunction

function! winmanager#winids()
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


function! winmanager#split(num)
  let desc = winmanager#desc(a:num)
  let s:rownum = len(s:winarr)

  if s:rownum == 0
    silent execute "normal! :echo 'split [" . a:num . "] windows is not support yet.'\<CR>"
    return
  endif

  silent execute "normal! :only\<CR>"

  let s:i = 1
  while s:i < s:rownum
    silent execute "normal! :vsplit\<CR>"
    let s:i = s:i + 1
  endwhile

  let s:i = s:rownum
  while s:i > 0
    let s:colnum = s:winarr[s:i - 1]
    if s:colnum > 1
      call GoWindow(s:i)

      let s:j = s:colnum
      while s:j > 1
        silent execute "normal! :split\<CR>"
        let s:j = s:j - 1
      endwhile

    endif
    let s:i = s:i - 1
  endwhile
endfunction

function! SwapWindow(...)
  let s:winnrs = []
  if a:0 == 0
    let s:winnrs = ['1', '2']
  else
    if a:0 == 1
      let s:winnrs = [winnr(), a:1]
    else
      let s:winnrs = [a:1, a:2]
    end
  endif

  let s:bufnrs = []
  for nr in s:winnrs
    let s:buf = winbufnr(nr)
    if s:buf == -1
      execute "normal :echoerr '[" . nr . "] is not a valid number'\<CR>"
      return
    endif
    call add(s:bufnrs, s:buf)
  endfor

  call reverse(s:bufnrs)
  for nr in s:winnrs
    let i = index(s:winnrs, nr)
    call GoWindow(nr)
    silent execute "normal! :b! " . s:bufnrs[i] . "\<CR>"
  endfor
endfunction

function! GoWindow(num)
  call win_gotoid(win_getid(a:num))
endfunction


