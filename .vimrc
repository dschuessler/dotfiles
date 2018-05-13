" =========== DISPLAY ===========
if has('gui_running')
    set guifont=SF\ Mono\ Regular:h11
endif

" =========== SYNTAX SETTINGS ===========

" enable syntax processing
syntax enable

" highlight HTML syntax in PHP files
let g:php_htmlInStrings=1

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

" turn off undercurls
autocmd ColorScheme * hi clear SpellBad
    \| hi SpellBad term=reverse ctermbg=12 guisp=Firebrick2
    \| hi SpellCap term=reverse ctermbg=9 guisp=Blue
    \| hi SpellRare term=reverse ctermbg=13 guisp=Magenta
    \| hi SpellLocal term=reverse ctermbg=11

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

" use tab key to cycle through suggestions
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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
        set pythonthreedll=/usr/local/Frameworks/Python.framework/Versions/3.6/Python
        set pythonthreehome=/usr/local/Frameworks/Python.framework/Versions/3.6
    else
        command! -nargs=1 Py py <args>
        set pythondll=/usr/local/Frameworks/Python.framework/Versions/2.7/Python
        set pythonhome=/usr/local/Frameworks/Python.framework/Versions/2.7
    endif
endif

" =========== PLUGINS ===========

call plug#begin('~/.vim/plugged')

" syntax highlighting
Plug 'aklt/plantuml-syntax', { 'for': 'plantuml' }
Plug 'ARM9/arm-syntax-vim', { 'for': 'arm' }
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'solarnz/thrift.vim', { 'for': 'thrift' }
Plug 'vim-scripts/applescript.vim', { 'for': 'applescript' }

" autocompletion
if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'ervandew/supertab'

" omnicompletion engines
Plug 'autozimu/LanguageClient-neovim', {'tag': 'binary-*-x86_64-apple-darwin'}
Plug 'zchee/deoplete-clang', { 'for': ['c', 'cpp', 'objc', 'objcpp'] }
Plug 'artur-shaik/vim-javacomplete2', { 'for': 'java' }
Plug 'othree/csscomplete.vim', { 'for': 'css' }
Plug 'othree/html5.vim', { 'for': 'html' }
Plug 'carlitux/deoplete-ternjs', { 'do': 'npm install -g tern' }

" language servers
Plug 'roxma/LanguageServer-php-neovim',  {'do': 'composer install && composer run-script parse-stubs'}

" linting
Plug 'w0rp/ale'

" formatting
Plug 'jiangmiao/auto-pairs', { 'for': 'html' }
Plug 'alvan/vim-closetag', { 'for': 'html'  }
Plug 'editorconfig/editorconfig-vim'
Plug 'tpope/vim-sleuth'
Plug 'godlygeek/tabular'

" visual aids
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" live preview
Plug 'juanwolf/browserlink.vim'

" project management
Plug 'scrooloose/nerdtree'
Plug 'airblade/vim-rooter'

" color scheme
if has ('nvim')
    Plug '~/.vim/colors/macvim.vim'
endif

" miscellaneous
Plug 'ajorgensen/vim-markdown-toc'

call plug#end()

" =========== PLUGIN CONFIGURATION ===========

" vim-markdown
let g:tex_conceal = ''
let g:vim_markdown_math = 1
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_folding_disabled = 1
autocmd BufNewFile,BufRead * setlocal formatoptions-=r

" deoplete
let g:deoplete#enable_at_startup = 1
let g:deoplete#sources#clang#libclang_path = '/usr/local/Cellar/llvm/6.0.0/lib/libclang.dylib'
let g:deoplete#sources#clang#clang_header = '/usr/local/Cellar/llvm/6.0.0/lib/clang/6.0.0/include'
let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
let g:deoplete#ignore_sources.php = ['omni']

" ultisnips
let g:UltiSnipsExpandTrigger = "<nop>"
let g:ulti_expand_or_jump_res = 0
function ExpandSnippetOrCarriageReturn()
    let l:snippet = UltiSnips#ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res > 0
        return l:snippet
    else
        return "\<CR>"
    endif
endfunction
inoremap <expr> <CR> pumvisible() ? "<C-R>=ExpandSnippetOrCarriageReturn()<CR>" : "\<CR>"

" supertab
let g:SuperTabDefaultCompletionType = '<c-n>'

" LanguageClient-neovim
let g:LanguageClient_serverCommands = {
    \'lua': ['lua-lsp'],
    \'python': ['pyls'],
    \'php': ['php', '~/.vim/plugged/LanguageServer-php-neovim/vendor/bin/php-language-server.php']
\}

" vim-javacomplete2
autocmd FileType java setlocal omnifunc=javacomplete#Complete
nmap <F4> <Plug>(JavaComplete-Imports-AddSmart)
imap <F4> <Plug>(JavaComplete-Imports-AddSmart)
nmap <F5> <Plug>(JavaComplete-Imports-Add)
imap <F5> <Plug>(JavaComplete-Imports-Add)
nmap <F6> <Plug>(JavaComplete-Imports-AddMissing)
imap <F6> <Plug>(JavaComplete-Imports-AddMissing)
nmap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)
imap <F7> <Plug>(JavaComplete-Imports-RemoveUnused)

" csscomplete.vim
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci

" tern_for_vim
autocmd FileType javascript setlocal omnifunc=tern#Complete

" atp_vim
let g:atp_Compiler='bash'

" ale
let g:ale_linters = {
\   'php': ['langserver'],
\   'python': ['pyls']
\}

" vim-closetag
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx'
let g:closetag_emptyTags_caseSensitive = 1
let g:closetag_shortcut = '>'
let g:closetag_close_shortcut = '<leader>>'

" lanugage servers
autocmd FileType py LanguageClientStart

" NERDTree
let NERDTreeShowHidden=1

" macvim.vim
if has ('nvim')
    colorscheme macvim
endif
