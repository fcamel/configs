map ; ddekpej
syntax on
"set ignorecase
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
autocmd BufRead,BufNewFile *.py map <F10> :% w !python<CR>
autocmd BufRead,BufNewFile *.py set sw=4 tabstop=4 smarttab expandtab
set sw=4 tabstop=4 smarttab expandtab

map e <C-w>
map ,, :tabe %<CR>
imap jj <ESC>
imap jf <ESC>
imap fj <ESC>

so ~/.vim/indent/*

set t_Co=256
let python_highlight_all = 1
colorscheme wombat256

set cursorline

if expand("%") =~ ".*_test\.py"
        autocmd BufNewFile *_test.py 0r ~/.vim/template/test.py
elseif expand("%") =~ ".*\.py"
        autocmd BufNewFile *.py 0r ~/.vim/template/production.py
endif

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

" Python
"imap ddd import codecode.InteractiveConsole(locals=locals()).interact()
imap ddd import IPythonIPython.Shell.IPShellEmbed()()
