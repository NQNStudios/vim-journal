" ------------------------------------------------------------------------------
" Exit when your app has already been loaded (or "compatible" mode set)
if exists("g:loaded_VimJournal") || &cp
  finish
endif
let g:loaded_VimJournal= 000
let s:keepcpo           = &cpo
set cpo&vim

" Settings

if !exists("g:vimJournalDir")
  let g:vimJournalDir = 'Journal'
end

if !exists("g:vimJournalYearFormat")
  let g:vimJournalYearFormat = '%Y'
end

if !exists("g:vimJournalMonthFormat")
  let g:vimJournalMonthFormat = '%B'
end

if !exists("g:vimJournalDayFormat")
  let g:vimJournalDayFormat = '%m-%d-%y'
end

if !exists("g:vimJournalTimeStampFormat")
  let g:vimJournalTimeStampFormat = '%c'
end

if !exists("g:vimJournalFileExtension")
  let g:vimJournalFileExtension = '.markdown'
end

" Fields
let s:currentDir = ''

" Global commands
command Journal call s:journal()
command TimeStamp call s:insertTimeStamp()
command SwapDelete call s:swapDelete()

" Script functions
fun! s:journal()
  call s:openRootDir()
  call s:openYearDir()
  call s:openMonthDir()
  call s:openDayFile()
endfun

fun! s:insertTimeStamp()
  let @"=strftime(g:vimJournalTimeStampFormat)
  normal! p
endfun

fun! s:swapDelete()
  let l:workingDir = getcwd() " remember the initial working dir
  cd %:p:h " change working directory to current file directory
  call delete('.' . expand('%') . '.swp') " delete the swap file
  execute 'cd ' . l:workingDir
endfun

fun! s:openRootDir()
  let s:currentDir = ''
  let s:currentDir .= $HOME
  call s:openDir(g:vimJournalDir)
endfun

fun! s:openYearDir()
  let s:year = strftime(g:vimJournalYearFormat)
  call s:openDir(s:year)
endfun

fun! s:openMonthDir()
  let s:month = strftime(g:vimJournalMonthFormat)
  call s:openDir(s:month)
endfun

fun! s:openDayFile()
  let s:day = strftime(g:vimJournalDayFormat)
  execute 'e' fnameescape(s:currentDir . '/' . s:day . g:vimJournalFileExtension)
endfun

fun! s:openDir(dir)
  if !isdirectory(s:currentDir . '/' . a:dir)
    call mkdir(s:currentDir . '/' . a:dir, 'p')
    echom "Making a new directory"
  end
  let s:currentDir .= '/' . a:dir
endfun

" ------------------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo
