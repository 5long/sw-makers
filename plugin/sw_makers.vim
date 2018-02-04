let g:neomake_javascript_eslintsw_maker = {
      \ 'exe': 'npx',
      \ 'args': ['eslint', '-f', 'compact', '-c', resolve($HOME) . '/.eslintrc.yaml'],
      \ 'cwd': '%:p:h',
      \ 'process_output': function('sw_makers#eslint#ProcessOutput')
      \ }
