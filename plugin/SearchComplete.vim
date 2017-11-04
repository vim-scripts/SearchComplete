" SearchComplete.vim
" Author: Chris Russell
" Version: 1.1
" License: GPL v2.0
"
" Description:
" This script defineds functions and key mappings for Tab completion in
" searches.
"
" Help:
" This script catches the <Tab> character when using the '/' search
" command.  Pressing Tab will expand the current partial word to the
" next matching word starting with the partial word.
"
" If you want to match a tab, use the '\t' pattern.
"
" Installation:
" Simply drop this file into your $HOME/.vim/plugin directory.
"
" Changelog:
" 2002-11-08 v1.1
"   Convert to unix eol
" 2002-11-05 v1.0
"   Initial release
"
" TODO:
"


"--------------------------------------------------
" Avoid multiple sourcing
"--------------------------------------------------
if exists( "loaded_search_complete" )
    finish
endif
let loaded_search_complete = 1


"--------------------------------------------------
" Key mappings
"--------------------------------------------------

noremap [search] <Nop>
noremap [bsearch] <Nop>
onoremap [search] /<C-r>=SearchCompleteStart('f')<CR>
onoremap [bsearch] /<C-r>=SearchCompleteStart('b')<CR>
nnoremap [search] :call SearchCompleteStart('f')<CR>/
nnoremap [bsearch] :call SearchCompleteStart('b')<CR>?


"--------------------------------------------------
" Set mappings for search complete
"--------------------------------------------------
function! SearchCompleteStart(dir)
    if a:dir == 'f'
        let s:completecmd = "\<C-N>"
        cnoremap <Tab> <C-C>:call SearchComplete()<CR>/<C-R>s
    else
        let s:completecmd = "\<C-P>"
        cnoremap <Tab> <C-C>:call SearchComplete()<CR>?<C-R>s
    endif
    let s:reg_s = @s
    cnoremap <silent> <CR> <CR>:call SearchCompleteStop()<CR>
    cnoremap <silent> <Esc> <C-C>:call SearchCompleteStop()<CR>
    " allow Up/Down arrows without breaking
    cnoremap <silent> <Esc>[A <Esc>[A
    cnoremap <silent> <Esc>[B <Esc>[B

endfunction

"--------------------------------------------------
" Tab completion in / search
"--------------------------------------------------
function! SearchComplete()
    " get current cursor position
    let l:loc = col( "." ) - 1
    " get partial search and delete
    let l:search = histget( '/', -1 )
    call histdel( '/', -1 )
    " check if new search
    if l:search == @s
        " get root search string
        let l:search = b:searchcomplete
        " increase number of autocompletes
        let b:searchcompletedepth = b:searchcompletedepth . s:completecmd
    else
        " one autocomplete
        let b:searchcompletedepth = s:completecmd
    endif
    " store origional search parameter
    let b:searchcomplete = l:search
    " set paste option to disable indent options
    let l:paste = &paste
    setlocal paste
    " on a temporary line put search string and use autocomplete
    execute "normal! A\n" . l:search . b:searchcompletedepth
    " get autocomplete result
    let @s = getline( line( "." ) )
    " undo and return to first char
    execute "normal! u0"
    " return to cursor position
    if l:loc > 0
        execute "normal! ". l:loc . "l"
    endif
    " reset paste option
    let &paste = l:paste
endfunction

"--------------------------------------------------
" Remove search complete mappings
"--------------------------------------------------
function! SearchCompleteStop()
    cunmap <Tab>
    cunmap <CR>
    cunmap <Esc>
    let @s = s:reg_s
endfunction

