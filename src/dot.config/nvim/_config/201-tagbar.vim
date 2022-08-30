function! s:has_mdctags()
  return executable('mdctags')
endfunction

let g:tagbar_type_ansible = {
    \ 'ctagstype' : 'yaml',
    \ 'kinds' : [ 't:tasks' ],
    \ 'sort' : 0
  \ }

let g:tagbar_type_rst = {
    \ 'ctagstype': 'rst',
    \ 'ctagsbin' : '~/.vim/plugged/rst2ctags/rst2ctags.py',
    \ 'ctagsargs' : '-f - --sort=yes',
    \ 'kinds' : [ 's:sections', 'i:images' ],
    \ 'sro' : '|',
    \ 'kind2scope' : { 's' : 'section' },
    \ 'sort': 0,
  \ }

let g:tagbar_type_ps1 = {
    \ 'ctagstype': 'powershell',
    \ 'kinds': [
      \ 'c:class',
      \ 'f:function',
      \ 'v:variable',
      \ 'i:filter',
      \ 'a:alias'
    \ ]
  \ }

let g:tagbar_type_bats = {
    \ 'ctagstype': 'bats',
    \ 'kinds': [
      \ 't:test'
    \ ],
    \ 'sort': 0,
  \ }

if s:has_mdctags()
  let g:tagbar_type_markdown = {
      \ 'ctagsbin': 'mdctags',
      \ 'ctagsargs': '',
      \ 'kinds': [
        \ 'a:h1:0:0',
        \ 'b:h2:0:0',
        \ 'c:h3:0:0',
        \ 'd:h4:0:0',
        \ 'e:h5:0:0',
        \ 'f:h6:0:0',
      \ ],
      \ 'sro': '::',
      \ 'kind2scope' : {
        \ 'a': 'h1',
        \ 'b': 'h2',
        \ 'c': 'h3',
        \ 'd': 'h4',
        \ 'e': 'h5',
        \ 'f': 'h6',
      \ },
      \ 'scope2kind' : {
        \ 'h1': 'a',
        \ 'h2': 'b',
        \ 'h3': 'c',
        \ 'h4': 'd',
        \ 'h5': 'e',
        \ 'h6': 'f',
      \ },
      \ 'sort': 0,
    \}
else
  let g:tagbar_type_markdown = {
      \ 'ctagstype': 'markdown',
      \ 'ctagsbin' : '~/.vim/plugged/markdown2ctags/markdown2ctags.py',
      \ 'ctagsargs': '-f - --sort=yes',
      \ 'kinds' : [
        \ 's:sections',
        \ 'i:images'
      \ ],
      \ 'sro' : '|',
      \ 'kind2scope' : {
        \ 's' : 'section',
      \ },
      \ 'sort': 0,
    \ }
endif

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

let g:tagbar_type_rust = {
    \ 'ctagstype' : 'rust',
    \ 'kinds' : [
      \'T:types,type definitions',
      \'f:functions,function definitions',
      \'g:enum,enumeration names',
      \'s:structure names',
      \'m:modules,module names',
      \'c:consts,static constants',
      \'t:traits',
      \'i:impls,trait implementations',
    \]
  \}
