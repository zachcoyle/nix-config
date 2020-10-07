let g:startify_session_dir ='~/.config/nvim/session'
let g:startify_fortune_use_unicode = 1
let g:startify_lists = [
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'files',     'header': ['   Files']            },
          \ ]
let g:startify_bookmarks = [
         \ {'n': '~/.config/nixpkgs'},
         \ ]
