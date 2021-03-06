" =========== DISPLAY ===========
if has('gui_running')
    set guifont=SF\ Mono\ Regular:h11
endif

" =========== SYNTAX SETTINGS ===========

" enable syntax processing
syntax enable

" highlight HTML syntax in PHP files
let g:php_htmlInStrings = 1

" =========== TABS AND SPACES ===========

" remove all trailing white spaces when saving
autocmd BufWritePre * %s/\s\+$//e

" expand tab to spaces except for makefiles
set expandtab
autocmd FileType make setlocal noexpandtab

" number of visual spaces per indentation
set shiftwidth=4

" number of visual spaces per tab
set softtabstop=4

" =========== INDENTATION ===========

" autoindent
set autoindent

" autoindent broken lines to the given indentation level
set breakindent

" autoindent broken lines two spaces further than the `breakindent` default
set showbreak=..

" load filetype-specific indent files
filetype indent on

" =========== VISUAL AND AUDIBLE AIDS ===========

" show line numbers
set number

" highlight the current line
set cursorline

" break lines at white spaces
set linebreak

" highlight matching brackets
set showmatch

" highlight search matches
set hlsearch

" always show sign column
autocmd BufEnter * sign define dummy
autocmd BufEnter * execute 'sign place 9999 line=1 name=dummy buffer=' . bufnr('')

" turn off error bell
autocmd! GUIEnter * set vb t_vb=

" =========== EDITING ===========

" set default encoding
set encoding=utf-8

" turn off auto inserting a comment sign when inserting a line break
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" =========== AUTOCOMPLETION ===========

" turn on autocompletion for the command menu
set wildmenu

" search matches as characters are entered
set incsearch

" don't show omnicompletion previews
set completeopt-=preview

" =========== DISK I/O ===========

" turn off swap files
set noswapfile

" autoload changes to files
set autoread

" =========== FILE TYPES ===========

" add non-default file types
au BufNewFile,BufRead *.s,*.S set filetype=arm
au BufNewFile,BufRead *.applescript set filetype=applescript

" =========== PYTHON ===========

if !has ('nvim')
    if has('python3')
        command! -nargs=1 Py py3 <args>
        set pythonthreedll=/usr/local/Frameworks/Python.framework/Versions/3.7/Python
        set pythonthreehome=/usr/local/Frameworks/Python.framework/Versions/3.7
    else
        command! -nargs=1 Py py <args>
        set pythondll=/usr/local/Frameworks/Python.framework/Versions/2.7/Python
        set pythonhome=/usr/local/Frameworks/Python.framework/Versions/2.7
    endif
endif

" =========== PLUGINS ===========

call plug#begin('~/.vim/plugged')

" syntax highlighting
Plug 'aklt/plantuml-syntax', {'for': 'plantuml'}
Plug 'ARM9/arm-syntax-vim', {'for': 'arm'}
Plug 'keith/swift.vim', {'for': 'swift'}
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}
Plug 'plasticboy/vim-markdown', {'for': 'markdown'}
Plug 'solarnz/thrift.vim', {'for': 'thrift'}
Plug 'vim-scripts/applescript.vim', {'for': 'applescript'}

" autocompletion
if has('nvim')
    Plug 'Shougo/deoplete.nvim', {'do': ':UpdateRemotePlugins'}
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'ervandew/supertab'

" omnicompletion engines
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
Plug 'zchee/deoplete-clang', {'for': ['c', 'cpp', 'objc', 'objcpp']}
Plug 'othree/csscomplete.vim', {'for': 'css'}
Plug 'othree/html5.vim', {'for': 'html'}

" language servers
Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}

" linting
Plug 'w0rp/ale'

" formatting
Plug 'jiangmiao/auto-pairs', {'for': ['html', 'xml', 'xhtml']}
Plug 'alvan/vim-closetag', {'for': ['html', 'xml', 'xhtml']}
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'godlygeek/tabular'

" visual aids
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" live preview
Plug 'CandySunPlus/browserlink.vim'

" project management
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-rooter'

" color scheme
if has ('nvim')
    Plug '~/.vim/colors/macvim.vim'
endif

" miscellaneous
Plug 'ajorgensen/vim-markdown-toc'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

call plug#end()

" =========== PLUGIN CONFIGURATION ===========

" vim-markdown
let g:tex_conceal = ''
let g:vim_markdown_math = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_folding_disabled = 1
autocmd BufNewFile,BufRead * setlocal formatoptions-=r

" deoplete
let g:deoplete#auto_complete_delay = 0
let g:deoplete#complete_method = "omnifunc"
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/usr/local/opt/llvm/lib/libclang.dylib'
let g:deoplete#sources#clang#clang_header = '/usr/local/opt/llvm/lib/clang/7.0.0/include'

" supertab
let g:SuperTabDefaultCompletionType = '<c-n>'

" LanguageClient-neovim
function SetupLanguageClients()
    let g:LanguageClient_serverCommands = {
        \'java': ['jdt-ls', FindRootDirectory()],
        \'javascript': ['javascript-typescript-stdio'],
        \'lua': ['lua-lsp'],
        \'php': ['php', '~/.vim/plugged/LanguageServer-php-neovim/vendor/bin/php-language-server.php'],
        \'python': ['pyls'],
        \'sh': ['bash-language-server', 'start'],
    \}

    LanguageClientStart()
endfunction

autocmd FileType java,javascript,lua,php,python,sh call SetupLanguageClients()

command Rename     call LanguageClient_textDocument_rename()
command Hover      call LanguageClient_textDocument_hover()
command Definition call LanguageClient_textDocument_definition()
command Symbols    call LanguageClient_textDocument_documentSymbol()
command Format     call LanguageClient_textDocument_formatting()
command Action     call LanguageClient_textDocument_codeAction()

" csscomplete.vim
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci

" ale
let g:ale_linters_explicit = 1
let g:ale_linters = {
    \ 'c': ['clang'],
    \ 'cpp': ['clang'],
    \ 'css': ['csslint'],
    \ 'dockerfile': ['hadolint'],
    \ 'html': ['htmlhint'],
    \ 'javascript': ['jshint'],
    \ 'json': ['jsonlint'],
    \ 'objc': ['clang'],
    \ 'objcpp': ['clang'],
    \ 'sh': ['shellcheck'],
    \ 'sql': ['sqlint'],
    \ 'thrift': ['thrift'],
    \ 'typescript': ['tslint'],
    \ 'vim': ['vint'],
    \ 'xml': ['xmllint'],
    \ 'yaml': ['yamllint'],
\ }

" NERDTree
let g:NERDTreeShowHidden = 1

" vim-rooter
let g:rooter_silent_chdir = 1

" macvim.vim
if has ('nvim')
    colorscheme macvim
endif

