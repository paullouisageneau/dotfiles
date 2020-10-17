set nocompatible    " Be iMproved, required
set exrc            " Load .vimrc from current directory
set secure	    " Secure mode so custom .vimrc don't execute commands
set showcmd         " Show leader command
set autoread	    " Automatically read a file that has changed on disk
set clipboard=unnamedplus   " Alias unnamed register to the + register, which is the X Window clipboard.
set history=2000            " Sets how many lines of history VIM has to remember
set undolevels=1000  	    " use many levels of undo
set viminfo='100,<1000,s100,h

filetype off " required
syntax on
set title

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Plugins
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'leafgarland/typescript-vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'tikhomirov/vim-glsl'
Plugin 'rust-lang/rust.vim'


" All plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Use space as leader
let g:mapleader = "\<space>"

let g:lsp_diagnostics_enabled = 1
let g:lsp_signs_enabled = 1

let g:asyncomplete_remove_duplicates = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_smart_completion = 1

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0

" Indentation
set smarttab
set autoindent copyindent preserveindent
set tabstop=8
set shiftwidth=4
set softtabstop=4
set expandtab
function! TabToggle()
    if &expandtab
        set tabstop=4
        set shiftwidth=4
        set softtabstop=0
        set noexpandtab
        echo "Indenting with tabs"
  else
        set tabstop=8
        set shiftwidth=4
        set softtabstop=4
        set expandtab
        echo "Indenting with spaces"
  endif
endfunction
map <silent> <leader><tab> mz:execute TabToggle()<CR>'z

" Strip trailing whitespaces
function! TrimSpaces()
    %s/\s*$//
    ''
endfunction
nnoremap <leader>t :call TrimSpaces()<CR>
map <A-t> :call TrimSpaces()<CR>
imap <A-t> <c-o>:call TrimSpaces()<CR>
"autocmd BufWritePre * call TrimSpaces()

" Reset position on file opening
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Format C++
let g:clang_format_py = "/usr/share/clang/clang-format.py"
if filereadable(g:clang_format_py)
    function! ClangFormat()
        execute "pyf ".g:clang_format_py
    endfunction
    function! ClangFormatAll()
        let l:lines = "all"
        execute "pyf ".g:clang_format_py
    endfunction
    function! ClangFormatDiff()
        let l:formatdiff = 1
        execute "pyf ".g:clang_format_py
    endfunction
    nnoremap <leader>f :call ClangFormatAll()<CR>
    map <A-f> :call ClangFormat()<CR>
    imap <A-f> <c-o>:call ClangFormat()<CR>
    "autocmd BufWritePre *.h,*.hh,*.hpp,*.c,*.cc,*.cpp call ClangFormatDiff()
endif

" vim-lsp bindings
nnoremap <silent> <A-d> :LspDefinition<CR>
nnoremap <silent> <A-r> :LspReferences<CR>
nnoremap <F2> :LspRename<CR>
nnoremap <silent> <A-a> :LspWorkspaceSymbol<CR>
nnoremap <silent> <A-l> :LspDocumentSymbol<CR>
nnoremap <silent> <A-x> :LspDocumentDiagnostics<CR>

" syntastic bindings
nnoremap <silent> <A-c> :SyntasticCheck<CR>

" fugitive git bindings
nnoremap <leader>g :Git<space>
nnoremap <leader>ga :Git add %:p<CR><CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>gc :Gcommit -v -q %:p<CR>
nnoremap <leader>gca :Gcommit -v -q -a<CR>
nnoremap <leader>gd :Gdiff<CR>
nnoremap <leader>ge :Gedit<CR>
nnoremap <leader>gr :Gread<CR>
nnoremap <leader>gw :Gwrite<CR><CR>
nnoremap <leader>glog :silent! Glog<CR>:bot copen<CR>
nnoremap <leader>gg :Ggrep<space>
nnoremap <leader>gb :Git branch<space>
nnoremap <leader>gbd :Git branch -d<space>
nnoremap <leader>gco :Git checkout<space>
nnoremap <leader>gcob :Git checkout -b<space>
nnoremap <leader>grs :Git reset<space>
nnoremap <leader>gbl :Gblame<CR>
nnoremap <leader>gl :Gpull<CR>
nnoremap <leader>gp :Gpush<CR>
nnoremap <leader>gpo :Gpush -u origin<CR>
nnoremap <leader>gmv :Gmove<space>

" other bindings
nnoremap <leader>ls :Explore<CR>

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<CR>"
imap <c-space> <Plug>(asyncomplete_force_refresh)
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
set completeopt-=preview

autocmd BufNewFile,BufRead *.ts  setlocal filetype=typescript
autocmd BufNewFile,BufRead *.tsx setlocal filetype=typescript.tsx
autocmd BufNewFile,BufRead *.vect,*.frag,*.glsl set filetype=glsl

function! s:get_node_bin(name, global_fallback)
    let l:nodemodules_dir = lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), 'node_modules')
    if !empty(nodemodules_dir)
        let l:bin_path = l:nodemodules_dir.'.bin/'.a:name
        if executable(l:bin_path)
            return l:bin_path
        endif
    endif
    if a:global_fallback && executable(a:name)
        return a:name
    endif
    return ''
endfunction

let g:flow_bin = s:get_node_bin('flow', 0)
if !empty(g:flow_bin)
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'flow',
        \ 'cmd': {server_info->[g:flow_bin] + ['lsp']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.flowconfig'))},
        \ 'whitelist': ['javascript', 'javascript.jsx'],
        \ })
endif

let g:typescript_language_bin = s:get_node_bin('typescript-language-server', 1)
if !empty(g:typescript_language_bin)
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[g:typescript_language_bin] + ['--stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ 'whitelist': ['typescript', 'typescript.tsx'],
        \ })

    if empty(g:flow_bin)
        autocmd User lsp_setup call lsp#register_server({
            \ 'name': 'javascript using typescript-language-server',
            \ 'cmd': {server_info->[g:typescript_language_bin] + ['--stdio']},
            \ 'root_uri': { server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_directory(lsp#utils#get_buffer_path(), '.git/..'))},
            \ 'whitelist': ['javascript', 'javascript.jsx']
            \ })
    endif
endif

if executable('ccls')
   autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'ccls',
      \ 'cmd': {server_info->['ccls']},
      \ 'root_uri': {server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'compile_commands.json'))},
      \ 'initialization_options': {'cache': {'directory': '/tmp/ccls/cache' }},
      \ 'whitelist': ['c', 'cpp', 'cc', 'objc', 'objcpp'],
      \ })
    autocmd FileType c setlocal omnifunc=lsp#complete
    autocmd FileType cpp setlocal omnifunc=lsp#complete
    autocmd FileType cc setlocal omnifunc=lsp#complete
endif

"if executable('clangd')
"    autocmd User lsp_setup call lsp#register_server({
"        \ 'name': 'clangd',
"        \ 'cmd': {server_info->['clangd']},
"        \ 'whitelist': ['c', 'cpp', 'cc', 'objc', 'objcpp'],
"        \ })
"    autocmd FileType c setlocal omnifunc=lsp#complete
"    autocmd FileType cpp setlocal omnifunc=lsp#complete
"    autocmd FileType cc setlocal omnifunc=lsp#complete
"endif

if executable('pyls')
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'pyls',
        \ 'cmd': {server_info->['pyls']},
        \ 'whitelist': ['python'],
        \ 'workspace_config': {'pyls': {'plugins': {'pycodestyle': {'maxLineLength': 99, 'ignore': ['E402']}}}},
        \ })
endif

if executable('rls')
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rls']},
        \ 'whitelist': ['rust'],
        \ })
endif

let g:eslint_bin = s:get_node_bin('eslint', 1)
if executable(g:eslint_bin)
    let g:syntastic_javascript_checkers = ['eslint']
    let g:syntastic_javascript_eslint_exec = g:eslint_bin
endif

" Hack to remap Alt key escaped by gnome terminal
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endwhile
set timeout ttimeoutlen=50
