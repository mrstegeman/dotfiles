" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn match   hostIp        "^[0-9a-f\.:]*"
syn match   hostString    "[ \t].*"hs=s+1
syn match   hostComment   "^#.*"

" Define the default highlighting.
" Only used when an item doesn't have highlighting yet
hi def link hostIp      Keyword
hi def link hostString  String
hi def link hostComment Comment

let b:current_syntax = "hosts"
