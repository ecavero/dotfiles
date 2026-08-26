set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdTree'
Plugin 'https://github.com/jovandeginste/vim-groovy.git'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'mattn/emmet-vim.git'
Plugin 'axiaoxin/vim-json-line-format'
Plugin 'dhruvasagar/vim-table-mode'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'SQLComplete.vim'
Plugin 'tpope/vim-dadbod'
Plugin 'kshenoy/vim-signature'
Plugin 'maxboisvert/vim-simple-complete'
Plugin 'prabirshrestha/vim-lsp'
Plugin 'mattn/vim-lsp-settings'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
Plugin 'hashivim/vim-terraform'
Plugin 'jidn/vim-dbml'
Plugin 'keith/swift.vim'

call vundle#end()            " required
filetype plugin indent on    " required

filetype plugin on
set path +=**
set wildmenu
set number
set relativenumber
set tabstop=2
set expandtab
let mapleader = ' '

autocmd FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab

autocmd FileType java setlocal shiftwidth=3 softtabstop=3 tabstop=3

inoremap <S-Tab> <C-d>
noremap <leader>b :Buffers<CR>
noremap <leader>f :FZF<CR>
noremap <leader>a :Ag<CR>
noremap <leader>m :Marks<CR>
noremap <leader>s :w<CR>
noremap <leader>n :NERDTreeToggle<CR>
noremap <leader>N :NERDTreeFind<CR>
noremap <leader>g :!lazygit<CR>

syntax on

let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore bin -g ""'

autocmd BufNewFile,BufRead *.fxml set filetype=xml
autocmd BufNewFile,BufRead *.sc set filetype=scala

nnoremap <leader>q :call RunSQLParagraphBuffer()<CR>

function! RunSQLParagraphBuffer()
    " Definir las variables para la conexión
    let l:url = 'jdbc:mysql://localhost:3306/smartworkspaces'
    let l:usuario = 'root'
    let l:clave = 'root'

    " Obtener el párrafo alrededor del cursor
    let l:start = search('\v^\s*$', 'bnW') + 1
    let l:end = search('\v^\s*$', 'nW')
    if l:end == 0
        let l:end = line('$') " Si no se encuentra una línea en blanco, ir al final del archivo
    endif
    let l:lines = getline(l:start, l:end)

    " Escribir en un archivo temporal
    let l:tmpfile = tempname() . ".sql"
    call writefile(l:lines, l:tmpfile)

    " Ejecutar el comando SQL y formatear la salida mientras se mantienen los encabezados
    let l:raw_output = system("sqlline -u " . l:url . " -n " . l:usuario . " -p " . l:clave . " --silent --outputformat=tsv -f " . shellescape(l:tmpfile) . " | tr -d '\"' | column -t -s $'\t' -o '|'")
    call delete(l:tmpfile)  " Limpiar el archivo temporal

    " Filtrar la salida innecesaria pero MANTENER la primera línea (encabezados)
    let l:filtered_lines = filter(split(l:raw_output, "\n"), 'v:val !~ "sqlline version" && v:val !~ "rows selected" && v:val !~ "WARNING" && v:val != ""')

    if empty(l:filtered_lines)
        echo "No se encontraron resultados válidos para la consulta."
        return
    endif

    " Abrir un nuevo buffer **debajo** del actual
    belowright new
    setlocal buftype=nofile
    call setline(1, l:filtered_lines)
endfunction



let g:fabric_session_name = ""

nnoremap <leader><leader>ss :call SetFabricSession()<CR>
function! SetFabricSession()
    let l:session_name = input('Ingrese el nombre de la sesión: ')
    let g:fabric_session_name = l:session_name
    echo "Sesión establecida: " . g:fabric_session_name
endfunction

nnoremap <leader><leader>gs :call GetFabricSession()<CR>
function! GetFabricSession()
    if empty(g:fabric_session_name)
        echo "No hay sesión establecida."
    else
        echo "Sesión actual: " . g:fabric_session_name
    endif
endfunction


nnoremap <leader>i :call RunFabricCommand()<CR>

function! RunFabricCommand()
    let l:lines = getbufline('%', 1, '$')

    " Escribir las líneas seleccionadas en un archivo temporal
    let l:tmpfile = tempname() . ".md"
    call writefile(l:lines, l:tmpfile)

    " Definir la configuración de Fabric
    let l:config_file = "config.yml"
    let l:model_context_length = 8000

    " Ejecutar el comando Fabric
    "let l:command = "cat " . l:tmpfile . "| fabric --config " . l:config_file . " --modelContextLength=" . l:model_context_length . " -C tienda.md" 
    if !empty(g:fabric_session_name)
      let l:command = "cat " . l:tmpfile . "| fabric --session=" . g:fabric_session_name
    else
      let l:command = "cat " . l:tmpfile . "| fabric"
    endif

    let l:raw_output = system(l:command)

    " Limpiar el archivo temporal
    call delete(l:tmpfile)

    " Filtrar la salida si es necesario (opcional)
    let l:filtered_lines = filter(split(l:raw_output, "\n"), 'v:val != ""')

    if empty(l:filtered_lines)
        echo "No se encontraron resultados válidos para el comando Fabric."
        return
    endif

    " Abrir un nuevo buffer **debajo** del actual para mostrar la salida
    belowright new
    setlocal buftype=nofile
    call setline(1, l:filtered_lines)
endfunction


if executable('java')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'jdtls',
        \ 'cmd': ['java', '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        \        '-Dosgi.bundles.defaultStartLevel=4',
        \        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        \        '-noverify',
        \        '-Xmx1G',
        \        '-Djava.exclude=**/*.class,bin/',
        \        '-jar', expand('~/.local/share/eclipse.jdt.ls/plugins/org.eclipse.equinox.launcher_*.jar'),
        \        '-configuration', expand('~/.local/share/eclipse.jdt.ls/config_linux/'),
        \        '-data', expand('~/.local/share/eclipse.jdt.ls/workspace')],
        \ 'root_uri': {'root': lsp#utils#path_to_uri(expand('%:p:h'))},
        \ 'capabilities': {},
        \ })
endif

if executable('metals')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'metals',
        \ 'cmd': ['metals'],
        \ 'root_uri': {'root': lsp#utils#path_to_uri(expand('%:p:h'))},
        \ 'whitelist': ['scala'],
        \ 'capabilities': {},
        \ })
    let g:lsp_settings = {'metals': {'whitelist': ['scala']}}
endif

"LSP config from https://youtu.be/9HqgUo7kduk
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 1

let g:lsp_completion_documentation_enabled = 1
let g:lsp_completion_documentation_delay = 1000

" Move notification messages to the right
let g:lsp_diagnostics_virtual_text_enabled=1

" Gutter symbols
let g:lsp_document_code_action_signs_enabled = 1
let g:lsp_document_code_action_signs_hint = {'text': '→'}
let g:lsp_diagnostics_signs_error = {'text': '⨉'}
let g:lsp_diagnostics_signs_warning = {'text': '‼'}
let g:lsp_diagnostics_signs_info = {'text': 'ℹ'}
let g:lsp_diagnostics_signs_hint = {'text': '?'}
let g:lsp_diagnostics_signs_insert_mode_enabled=1 


function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> gA <plug>(lsp-code-action-float)
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gs <plug>(lsp-document-symbol-search)
    nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END


" ============================================================================
" Worksheet Scala (<leader>r): ejecuta el archivo con scala-cli y muestra
" la salida en un buffer debajo del actual.
" ============================================================================

function! RunScalaWorksheet() abort
    let l:lines = getline(1, '$')
    let l:tmpfile = tempname() . ".sc"
    call writefile(l:lines, l:tmpfile)
    let l:script = 'FILE=' . shellescape(l:tmpfile)
        \ . ' && DEPS=$(grep "^//> using dep " "$FILE" | sed "s|//> using dep |--dep |" | tr "\n" " ")'
        \ . ' && CODE=$(sed "/^\/\/> using /d" "$FILE")'
        \ . ' && scala-cli repl $DEPS -O --repl-init-script -O "$CODE" -O --repl-quit-after-init 2>&1'
    let l:raw = system(l:script)
    call delete(l:tmpfile)
    let l:clean = substitute(l:raw, '\e\[[0-9;]*m', '', 'g')
    let l:filtered = filter(split(l:clean, "\n"), 'v:val != ""')
    if empty(l:filtered)
        echo "No se obtuvo salida."
        return
    endif
    belowright new
    setlocal buftype=nofile
    call setline(1, l:filtered)
endfunction

augroup scala_worksheet
    autocmd!
    autocmd BufRead,BufNewFile *.sc nnoremap <buffer> <silent> <leader>r :call RunScalaWorksheet()<CR>
augroup END
