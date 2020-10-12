nmap <silent>K <Plug>(lcn-hover)
nmap <silent> gd <Plug>(lcn-definition)
nmap <silent> <F2> <Plug>(lcn-rename)
nmap <silent> <C-i> <Plug>(lcn-explain-error)

let g:LanguageClient_autoStart = 1
let g:LanguageClient_hoverPreview = 'Always'
let g:LanguageClient_preferredMarkupKind = ['markdown', 'plaintext']
