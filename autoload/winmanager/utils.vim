
function! winmanager#utils#isExists(val)
  return type(a:val) != v:t_number || a:val != -1
endfunction

function! winmanager#utils#getVal(obj, key)
  return get(a:obj, a:key, -1)
endfunction


function! winmanager#utils#insert(arr, i, item)
  if a:i == 0
    return [a:item] + a:arr
  endif

  if a:i == len(a:arr)
    return a:arr + [a:item]
  endif

  return a:arr[:(a:i - 1)] + [a:item] + a:arr[a:i:]
endfunction

function! winmanager#utils#sortNums(nums)
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
      let mainNum = winmanager#utils#getMainNum(num)
      let mainSorted = winmanager#utils#getMainNum(sorted)

      if mainNum > mainSorted
        let result = winmanager#utils#insert(result, i, num)
        break
      elseif mainNum == mainSorted
        if num < sorted
          let result = winmanager#utils#insert(result, i, num)
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

function! winmanager#utils#getMainNum(num)
  return a:num > 10 ? (a:num - a:num % 10) / 10 : a:num
endfunction

function! winmanager#utils#min(x, y)
  return a:x > a:y ? a:y : a:x
endfunction

