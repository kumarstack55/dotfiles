if empty(globpath(&runtimepath, 'syntax/ansible.vim'))
  finish
endif

" INSERTで２つの改行の後でインデントを完全にリセットする。
let g:ansible_unindent_after_newline = 1

" key=value フォーマットを強調して表示する。
let g:ansible_attribute_highlight = "ob"

" name 属性を強調して表示する。
let g:ansible_name_highlight = 'd'

" register, always_run, 等のキーワードを強調して表示する。
let g:ansible_extra_keywords_highlight = 1

" include, until, 等のキーワードの強調を変える。
let g:ansible_normal_keywords_highlight = 'Constant'

" with_ 等キーワードの強調を変える。
let g:ansible_with_keywords_highlight = 'Constant'
