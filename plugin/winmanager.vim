" {{
"  @file vim-winmanager.vim
"  @author clark-t(clarktanglei@163.com)
" }}

if exists('loaded_vim_winmanager')
  finish
endif

let loaded_vim_winmanager = 1

" window fast selection
nnoremap <silent> <Leader>1 :call winmanager#go#exec(1)<CR>
nnoremap <silent> <Leader>2 :call winmanager#go#exec(2)<CR>
nnoremap <silent> <Leader>3 :call winmanager#go#exec(3)<CR>
nnoremap <silent> <Leader>4 :call winmanager#go#exec(4)<CR>
nnoremap <silent> <Leader>5 :call winmanager#go#exec(5)<CR>
nnoremap <silent> <Leader>6 :call winmanager#go#exec(6)<CR>

command -nargs=* Split :call winmanager#split#main(<f-args>)
command -nargs=* SP :call winmanager#split#main(<f-args>)
command -nargs=* Sp :call winmanager#split#main(<f-args>)

command -nargs=* Swap :call winmanager#swap#exec(<f-args>)
command -nargs=* SW :call winmanager#swap#exec(<f-args>)
command -nargs=* Sw :call winmanager#swap#exec(<f-args>)

command -nargs=1 Send :call winmanager#send#exec(<f-args>)
command -nargs=1 Se :call winmanager#send#exec(<f-args>)
command -nargs=1 SE :call winmanager#send#exec(<f-args>)

autocmd! VimResized * call winmanager#split#refresh()

