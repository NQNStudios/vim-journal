" ------------------------------------------------------------------------------
" Exit when your app has already been loaded (or "compatible" mode set)
if exists("g:loaded_VimJournal") || &cp
  finish
endif
let g:loaded_VimJournal= 000
let s:keepcpo           = &cpo
set cpo&vim

" Settings
let g:vimJournalDir = 'Journal'
let g:vimJournalYearFormat = '%Y'
let g:vimJournalMonthFormat = '%B'
let g:vimJournalDayFormat = '%m-%d-%y'
let g:vimJournalTimeStampFormat = '%c'
let g:vimJournalFileExtension = '.txt'

" Global commands
command Journal call s:journal()
command TimeStamp call s:insertTimeStamp()

" Script functions
fun! s:journal()
  call s:openRootDir()
  call s:openYearDir()
  call s:openMonthDir()
  call s:openDayFile()
endfun

fun! s:insertTimeStamp()
  let s:timeStamp = strftime(g:vimJournalTimeStampFormat)

  echo 'time stamp: ' . s:timeStamp

  let @a = s:timeStamp
  normal! G
  execute "put a"
endfun

fun! s:openRootDir()
  cd $HOME
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
  execute 'e' fnameescape(s:day . g:vimJournalFileExtension)
endfun

fun! s:openDir(dir)
  if !isdirectory(a:dir)
    call mkdir(fnameescape(a:dir), 'p')
  end
  execute 'cd' fnameescape(a:dir)
endfun

" ------------------------------------------------------------------------------
let &cpo= s:keepcpo
unlet s:keepcpo
