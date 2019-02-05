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
set tabpagemax=1000
set encoding=utf8
set bs=2
set wildmenu

hi Comment ctermfg=red
iab fdd <C-R>=strftime("%Y/%m/%d")<CR>

autocmd BufRead,BufNewFile *.tpl set filetype=html

autocmd BufRead,BufNewFile *.sh map <F10> :% w !bash<CR>
autocmd BufRead,BufNewFile *.pl map <F10> :% w !perl<CR>
autocmd BufRead,BufNewFile *.rb map <F10> :% w !ruby<CR>
autocmd BufRead,BufNewFile *.go map <F10> :GoRun<CR>
augroup filetype
  au! BufRead,BufNewFile *.proto setfiletype proto
augroup end

set sw=2 tabstop=2 smarttab expandtab


let mapleader = "e"

nmap <F9> :tab sp<CR>
nmap t <C-w>
nmap ,, :tabe %<CR>
nmap qq :q<CR>
nmap qa :wind q<CR>
nmap L Lzz
nmap <leader>[ gT
nmap <leader>] gt
imap jj <ESC>
imap jf <ESC>
imap fj <ESC>

let f = expand('%')
let suffix = matchstr(f, '\.\a\+$')
let pattern = suffix . "$"
if suffix == '.cpp' || suffix == '.cc'
  nmap <leader>/ /:<C-R>=expand("<cword>")<CR>(<CR>
elseif suffix == '.go'
  nmap <leader>/ /func .*<C-R>=expand("<cword>")<CR>(<CR>
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
map ,n :call OpenCorrespondingFileH()<C-M>


"autocmd BufRead,BufNewFile *.lisp so ~/.vim/ftplugin/lisp/limp.vim
filetype plugin indent on
filetype plugin on

:set foldmethod=indent

"nnoremap <F12> :TlistToggle<CR>
nmap <F12> :TagbarToggle<CR>

" set status line
set statusline =
" File description
set statusline +=%f
" Name of the current function (needs tagbar)
set statusline +=\ >>\ %{tagbar#currenttag('%s','')}
" Total number of lines in the file
set statusline +=%=%-10L
" Line, column and percentage
set statusline +=%=%-14.(%l,%c%V%)\ %P

"use pydiction
let g:pydiction_location = '~/.vim/pydiction/complete-dict'

" map clipboard to the default register
set clipboard=unnamed


"-----------------------------------------------------------
" Colors / Highlights
"-----------------------------------------------------------

" Use 256 colors
set t_Co=256
colorscheme wombat256
" highlight current line and add marker. To return the this line, use 'l
:nnoremap <silent> <Leader>L ml:execute 'match Search /\%'.line('.').'l/'<CR>

hi KeywordTODO ctermfg=DarkGreen
:syn match KeywordTODO "TODO"

" temporarily highlight keyword
hi KeywordTemp ctermfg=white ctermbg=darkgreen
hi KeywordTemp2 ctermfg=red
hi KeywordTemp3 ctermfg=cyan
nmap <leader>* :syn match KeywordTemp /\<<C-R>=expand("<cword>")<CR>\>/<CR>
nmap <leader>( :syn match KeywordTemp2 /\<<C-R>=expand("<cword>")<CR>\>/<CR>
nmap <leader>) :syn match KeywordTemp3 /\<<C-R>=expand("<cword>")<CR>\>/<CR>
nmap <leader>c :syn clear KeywordTemp<CR>:syn clear KeywordTemp2<CR>:syn clear KeywordTemp3<CR>
nnoremap <F8> :execute ':syn match KeywordTemp /' . @/ . '/'<CR>:let @/='\<<C-R>=expand("<cword>")<CR>\>'<CR>:set hls<CR>

syn match BacktracePrefix /\v^#[0-9]+/
syn match BacktraceFileNum #\v[^ ]+/[^ ]+:[0-9]+$#
hi BacktraceFileNum ctermfg=darkgreen guifg=green
hi BacktracePrefix ctermfg=yellow guifg=yellow

" cursor line/column
set cursorline cursorcolumn
hi CursorLine cterm=NONE ctermbg=darkyellow ctermfg=white
hi CursorColumn cterm=NONE ctermbg=darkyellow ctermfg=white
autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorcolumn
autocmd WinLeave * setlocal nocursorcolumn



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

" bash
function LoadBashTemplate()
    0r ~/.vim/template/bash.sh
    normal Gdd
endfunction

autocmd BufNewFile *.sh call LoadBashTemplate()

" html
function LoadHTMLTemplate()
    0r ~/.vim/template/production.html
    normal Gdd
endfunction

autocmd BufNewFile *.html call LoadHTMLTemplate()


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

" Open .h if it's a cpp file, and vice versa.
function! OpenComplementFile()
  let f = expand('%')
  let suffix = matchstr(f, '\.\a\+$')
  let pattern = suffix . "$"
  if suffix == '.h'
    let suffixes = ['.cpp', '.cc', '.mm', '.m', '.h']
    for suf in suffixes
      let target = substitute(f, pattern, suf, '')
      if filereadable(target)
        break
      endif
    endfor
  elseif suffix == '.cpp' || suffix == '.cc' || suffix == '.m' || suffix == '.mm'
    let target = substitute(f, pattern, '.h', '')
    if !filereadable(target)
      let tmp = target
      let target = substitute(tmp, '\v(.+)\..+', 'public/\1.h', '')
      if !filereadable(target)
        let target = substitute(tmp, '\v(.+)/(.+)\.(.+)', '\1/public/\2.h', '')
      endif
    endif
  elseif suffix == '.py'
    if matchstr(f, '_test.py') == '_test.py'
      let target = substitute(f, '_test.py', '.py', '')
    else
      let target = substitute(f, '.py', '_test.py', '')
    endif
  else
    let target = ''
  endif

  if filereadable(target)
    exec 'vsplit ' target
  else
    echo "Complement file not found"
  endif
endfunction
nnoremap <silent> <F4> :call OpenComplementFile()<CR>

fun! ShowFuncNameForCpp()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  " Find out the target line and echo it.
  echo getline(search("^[^ \t#/]\\{2}.*[^:]\s*$", 'bW'))
  echohl None
  " Go back to the original position.
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun

fun! ShowFuncNameForJava()
  let lnum = line(".")
  let col = col(".")
  echohl ModeMsg
  echo getline(search(".*\\(private\\|protected\\|public\\) ", 'bW'))
  echohl None
  call search("\\%" . lnum . "l" . "\\%" . col . "c")
endfun

autocmd BufRead,BufNewFile *.c map F :call ShowFuncNameForCpp() <CR>
autocmd BufRead,BufNewFile *.cc map F :call ShowFuncNameForCpp() <CR>
autocmd BufRead,BufNewFile *.cpp map F :call ShowFuncNameForCpp() <CR>
autocmd BufRead,BufNewFile *.java map F :call ShowFuncNameForJava() <CR>

" gj in vim. These are set in the bundle.
"let g:ackprg="gj_without_interaction"
"nnoremap <silent> <Leader>g :Ack<CR>
"nnoremap <silent> <Leader>G :Ack -d1 <C-R>=expand("<cword>")<CR> <CR>
"nnoremap <silent> <Leader>d :Ack -d2 <C-R>=expand("<cword>")<CR> <CR>

" C++ shortcut
imap sss const std::string& 


"-----------------------------------------------------------
" vundle
"-----------------------------------------------------------
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" plugins on GitHub
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/syntastic'
Plugin 'airblade/vim-gitgutter'
Plugin 'fcamel/gj'
Plugin 'majutsushi/tagbar'
Plugin 'mkitt/tabline.vim'
Plugin 'rhysd/vim-clang-format'
Plugin 'Valloric/YouCompleteMe'
Plugin 'junegunn/fzf.vim'

" Go
Plugin 'fatih/vim-go'
Plugin 'jstemmer/gotags'

" plugins not on GitHub
"Bundle 'file:///home/fcamel/dev/personal/gj'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


let g:go_version_warning = 0


"-----------------------------------------------------------
" plugins settings
"-----------------------------------------------------------

" ctrlp setting
let g:ctrlp_working_path_mode = ''
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files = 1000000
let g:ctrlp_user_command = 'find %s -type f'
let g:syntastic_cpp_compiler_options = ' -std=c++11'

" syntastic
"let g:syntastic_python_checkers = ['flake8', 'pep257', 'pep8', 'py3kwarn', 'pyflakes', 'pylama', 'pylint', 'python']

" YouCompleteMe
let g:ycm_global_ycm_extra_conf = '<chrome_depot>/src/tools/vim/chromium.ycm_extra_conf.py'

" Go
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }

let g:tagbar_left = 1

set updatetime=100
let g:go_auto_type_info = 1
let g:go_auto_sameids = 1
let g:go_fmt_command = "goimports"


nmap <F2> :GoDescribe<CR>


"-----------------------------------------------------------
" Customized setting
"-----------------------------------------------------------
so ~/.vimrc_private
