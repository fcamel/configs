syntax on
set ignorecase
set ru
set nu
set showcmd
set hlsearch
set cin
set smartindent
set nobackup

hi Comment ctermfg=red
iab fdd <C-R>=strftime("%Y/%m/%d")<CR>

autocmd BufRead,BufNewFile *.sh map <F10> :% w !bash<CR>
autocmd BufRead,BufNewFile *.pl map <F10> :% w !perl<CR>
autocmd BufRead,BufNewFile *.rb map <F10> :% w !ruby<CR>
set sw=4 tabstop=4 smarttab expandtab

map t <C-w>
map ,, :tabe %<CR>
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

"use pydiction
let g:pydiction_location = '~/.vim/pydiction/complete-dict'

" map clipboard to the default register
set clipboard=unnamed

" temporarily highlight keyword 
nmap <leader>* :syn match TempKeyword /\<<C-R>=expand("<cword>")<CR>\>/<CR>
nmap <leader>c :syn clear TempKeyword<CR>
