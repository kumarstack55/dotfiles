" git は GitGutter で行うため除外する。
let g:signify_vcs_cmds = {
  \ 'yadm':     'yadm diff --no-color --no-ext-diff -U0 -- %f',
  \ 'hg':       'hg diff --color=never --config aliases.diff= --nodates -U0 -- %f',
  \ 'svn':      'svn diff --diff-cmd %d -x -U0 -- %f',
  \ 'bzr':      'bzr diff --using %d --diff-options=-U0 -- %f',
  \ 'darcs':    'darcs diff --no-pause-for-gui --no-unified --diff-opts=-U0 -- %f',
  \ 'fossil':   'fossil diff --unified -c 0 -- %f',
  \ 'cvs':      'cvs diff -U0 -- %f',
  \ 'rcs':      'rcsdiff -U0 %f 2>%n',
  \ 'accurev':  'accurev diff %f -- -U0',
  \ 'perforce': 'p4 info '. sy#util#shell_redirect('%n') . (has('win32') ? ' &&' : ' && env P4DIFF= P4COLORS=') .' p4 diff -du0 %f',
  \ 'tfs':      'tf diff -version:W -noprompt -format:Unified %f'
  \ }
