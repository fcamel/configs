syntax on
set ignorecase
set smartcase
set ru
set nu
set showcmd
set hlsearch
set cin
set smartindent
set nobackup
set laststatus=2

hi Comment ctermfg=red
iab fdd <C-R>=strftime("%Y/%m/%d")<CR>

autocmd BufRead,BufNewFile *.sh map <F10> :% w !bash<CR>
autocmd BufRead,BufNewFile *.pl map <F10> :% w !perl<CR>
autocmd BufRead,BufNewFile *.rb map <F10> :% w !ruby<CR>
set sw=4 tabstop=4 smarttab expandtab

map t <C-w>
map ,, :tabe %<CR>
map qq :q<CR>
map qa :wind q<CR>
imap jj <ESC>
imap jf <ESC>
imap fj <ESC>

"open A_test.X if current file name is A.X
"open A.X if current file name is A_test.X
function OpenCorrespondingFile()
    let d = split(expand("%"), '_test')
    if len(d) == 1
        let name = expand("%:r") . "_test." . expand("%:e")
    else
        let name = d[0] . d[1]
    endif
    exec 'vsplit ' name
endfunction

map ,v :call OpenCorrespondingFile()<C-M>

" TODO refactor
function OpenCorrespondingFileH()
    let d = split(expand("%"), '_test')
    if len(d) == 1
        let name = expand("%:r") . "_test." . expand("%:e")
    else
        let name = d[0] . d[1]
    endif
    exec 'split ' name
endfunction

map ,h :call OpenCorrespondingFileH()<C-M>
map ,n :call OpenCorrespondingFileH()<C-M>


"autocmd BufRead,BufNewFile *.lisp so ~/.vim/ftplugin/lisp/limp.vim
filetype plugin indent on
filetype plugin on

:set foldmethod=indent

nnoremap <F12> :TlistToggle<CR>
map <F4> :vs %:s#\.cpp$#.XY_CPP_XY#:s#\.h$#.cpp#:s#.XY_CPP_XY#.h#:s#\.cc$#.h#:s#\.[cC]$#.h#<CR>

"use pydiction
let g:pydiction_location = '~/.vim/pydiction/complete-dict'

" map clipboard to the default register
set clipboard=unnamed

" temporarily highlight keyword
nmap <leader>* :syn match TempKeyword /\<<C-R>=expand("<cword>")<CR>\>/<CR>
nmap <leader>c :syn clear TempKeyword<CR>

" C/C++
function LoadCppMain()
    0r ~/.vim/template/production.cpp
    normal Gddkk
endfunction

autocmd BufNewFile *.cpp call LoadCppMain()

function LoadCMain()
    0r ~/.vim/template/production.c
    normal Gddkk
endfunction

autocmd BufNewFile *.c call LoadCMain()

"-----------------------------------------------------------
" My functions
"-----------------------------------------------------------

" Used by ShowMatched()
" Wrap the command in a function to achieve a silent call.
function! GetMatched(pattern)
    let @/ = a:pattern
    execute "g/" . a:pattern . "/p"
    execute "normal! \<c-o>"
endfunction

" Used by ShowMatched()
" Open <filename> at <line_number> in the 'right place' according to <index>
function! OpenMatchedInNewWindow(filename, line_number, index)
    if a:index >= 12
        return
    endif

    if a:index % 6 == 0
        execute "tabe +" . a:line_number . " " . a:filename
    elseif a:index % 6 == 1
        execute "vsplit +" . a:line_number . " " . a:filename
    elseif a:index % 6 == 2
        execute "normal! \<c-w>l"
        execute "split +" . a:line_number . " " . a:filename
    elseif a:index % 6 == 3
        execute "normal! \<c-w>h"
        execute "split +" . a:line_number . " " . a:filename
    elseif a:index % 6 == 4
        execute "normal! \<c-w>l"
        execute "split +" . a:line_number . " " . a:filename
    elseif a:index % 6 == 5
        execute "normal! \<c-w>h"
        execute "split +" . a:line_number . " " . a:filename
    else
        " Ignore.
    endif

    " unfold all if fold is used.
    normal zR
endfunction

" Open a new tab with at most 6 windows where each window's cursor is at
" the matched pattern in current file.
function! ShowMatched(pattern)
    redir @a
    silent call GetMatched(a:pattern)
    redir END
    let alist = split(@a, "\n")

    " Filter
    let numbers = []
    for line in alist
        if match(line, '^\s*\d\+\s') < 0
            continue
        endif

        let num = substitute(line, '^\s*\(\d\+\)\s.*', '\1', "")
        if strlen(num) == 0
            continue
        endif

        call add(numbers, num)
    endfor

    if len(numbers) <= 1
        echo "No matched or only one matched."
        return
    endif

    let i = 0
    for line_number in numbers
        call OpenMatchedInNewWindow("%", line_number, i)
        let i += 1
    endfor
endfunction

" Open a new tab to show where the word under the cursor is.
nnoremap <silent> <Leader>f :call ShowMatched("\\<" . "<c-r><c-w>" . "\\>")<CR>$N
nnoremap <silent> <Leader>F :call ShowMatched(input("Search for: "))<CR>


"-----------------------------------------------------------
" Customized setting
"-----------------------------------------------------------
so ~/.vimrc_private
