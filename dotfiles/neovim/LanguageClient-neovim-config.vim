let g:LanguageClient_serverCommands = {
      \ 'c'               : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
      \ 'clojure'         : ['clojure-lsp'],
      \ 'cpp'             : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
      \ 'dockerfile'      : ['docker-langserver', '--stdio'],
      \ 'go'              : ['gopls'],
      \ 'haskell'         : ['haskell-language-server', '--lsp'],
      \ 'javascript'      : ['typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
      \ 'javascriptreact' : ['typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
      \ 'json'            : ['typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
      \ 'nix'             : ['rnix-lsp'],
      \ 'objc'            : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
      \ 'python'          : ['poetry', 'run', 'pyls'],
      \ 'ruby'            : ['solargraph', 'stdio'],
      \ 'rust'            : ['rls'],
      \ 'sh'              : ['bash-language-server', 'start'],
      \ 'swift'           : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
      \ 'typescript'      : ['typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
      \ 'typescriptreact' : ['typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
      \ 'vim'             : ['vim-language-server', '--stdio'],
      \ }

nmap <silent>K <Plug>(lcn-hover)
nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> <F2> <Plug>(lcn-rename)
nmap <silent> <C-i> <Plug>(lcn-explain-error)

let g:LanguageClient_autoStart = 1
let g:LanguageClient_hoverPreview = 'Always'
let g:LanguageClient_preferredMarkupKind = ['markdown', 'plaintext']
