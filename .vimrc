" Basics {
    set nocompatible              " be iMproved, required
" }

" Use cscope if available {
    if filereadable(expand("~/cscope_maps.vim"))
        source ~/cscope_maps.vim
    endif
" }

" Vundle {
    " Setup Bundle support {
        " set the runtime path to include Vundle and initialize
        filetype off                  " required
        set rtp+=~/.vim/bundle/Vundle.vim
        call vundle#begin()
    " }
    
    "Bundles {
        Plugin 'VundleVim/Vundle.vim'

        " Plugin {
            " General {

            " }

            " UI {
                Plugin 'altercation/vim-colors-solarized'
                Plugin 'bling/vim-airline'
                "Plugin 'vim-airline/vim-airline'
                Plugin 'vim-airline/vim-airline-themes'
                Plugin 'scrooloose/nerdtree'
                Plugin 'jistr/vim-nerdtree-tabs'
                Plugin 'ddollar/nerdcommenter'
                Plugin 'majutsushi/tagbar'
                Plugin 'nathanaelkane/vim-indent-guides'
                Plugin 'powerline/powerline-fonts'
            " }

            " Program {
                Plugin 'tpope/vim-surround'
                Plugin 'easymotion/vim-easymotion'
                Plugin 'ctrlpvim/ctrlp.vim'
                Plugin 'tacahiroy/ctrlp-funky'
                Plugin 'mattesgroeger/vim-bookmarks'
                Plugin 'tpope/vim-fugitive'
                Plugin 'airblade/vim-gitgutter'
                Plugin 'mbbill/undotree'
                Plugin 'godlygeek/tabular'
                " Plugin 'wesleyche/srcexpl'

                "Plugin 'Valloric/YouCompleteMe'
            " }

            " Format {

            " }

            " C/C++ {
                "Plugin 'octol/vim-cpp-enhanced-highlight'
            " } 
        " } 
    " }

    " Plugin list end
    call vundle#end()
" }

" Configuration
" General {
    let mapleader = ','
    set t_Co=256
    
    " Allow to trigger background
    function! ToggleBG()
        let s:tbg = &background
        " Inversion
        if s:tbg == "dark"
            set background=light
        else
            set background=dark
        endif
    endfunction
    noremap <leader>bg :call ToggleBG()<CR>

    if !has('gui')
        set term=$TERM          " Make arrow and other keys work
    endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    " set mouse=v
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8
    
    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:spf13_no_restore_cursor = 1
    if !exists('g:spf13_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your .vimrc.before.local file:
        "   let g:spf13_no_views = 1
        if !exists('g:spf13_no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }
" }

" Plugin {
    " Vim UI {

        "solarized {
            if filereadable(expand("~/.vim/bundle/vim-colors-solarized/colors/solarized.vim"))
                set background=dark
                let g:solarized_termcolors=256
                let g:solarized_termtrans=1
                let g:solarized_contrast="normal"
                let g:solarized_visibility="normal"
                colorscheme solarized
            endif
        " }

        set tabpagemax=15               " Only show 15 tabs
        set showmode                    " Display the current mode

        set cursorline                  " Highlight current line

        highlight clear SignColumn      " SignColumn should match background
        highlight clear LineNr          " Current line number row will have same background color in relative mode
        "highlight clear CursorLineNr    " Remove highlight color from current line number

        if has('cmdline_info')
            set ruler                   " Show the ruler
            set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
            set showcmd                 " Show partial commands in status line and
                                        " Selected characters/lines in visual mode
        endif

        if has('statusline')
            set laststatus=2

            " Broken down into easily includeable segments
            set statusline=%<%f\                     " Filename
            set statusline+=%w%h%m%r                 " Options
            set statusline+=%{fugitive#statusline()} " Git Hotness

            set statusline+=\ [%{&ff}/%Y]            " Filetype
            set statusline+=\ [%{getcwd()}]          " Current dir
            set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
        endif

        set backspace=indent,eol,start  " Backspace for dummies
        set linespace=0                 " No extra spaces between rows
        set number                      " Line numbers on
        set showmatch                   " Show matching brackets/parenthesis
        set incsearch                   " Find as you type search
        set hlsearch                    " Highlight search terms
        set winminheight=0              " Windows can be 0 line high
        set ignorecase                  " Case insensitive search
        set smartcase                   " Case sensitive when uc present
        set wildmenu                    " Show list instead of just completing
        set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
        set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
        set scrolljump=5                " Lines to scroll when cursor leaves screen
        set scrolloff=3                 " Minimum lines to keep above and below cursor
        set foldenable                  " Auto fold code
        set list
        set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

        "TagBar{
            if isdirectory(expand("~/.vim/bundle/tagbar/"))
                nnoremap <silent> <leader>tt :TagbarToggle<CR>
            endif
        " }
        
        " NerdTree {
            if isdirectory(expand("~/.vim/bundle/nerdtree"))
                map <C-e> <plug>NERDTreeTabsToggle<CR>
                map <leader>e :NERDTreeFind<CR>
                nmap <leader>nt :NERDTreeFind<CR>

                let NERDTreeShowBookmarks=1
                let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
                let NERDTreeChDirMode=0
                let NERDTreeQuitOnOpen=1
                let NERDTreeMouseMode=2
                let NERDTreeShowHidden=1
                let NERDTreeKeepTreeInNewTab=1
                let g:nerdtree_tabs_open_on_gui_startup=0
            endif
        " }

        " indent_guides {
            if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
                let g:indent_guides_start_level = 2
                let g:indent_guides_guide_size = 1
                let g:indent_guides_enable_on_vim_startup = 1
            endif
        " }
    " }

    "Program {
        "syntastic {
            if isdirectory(expand("~/.vim/bundle/syntastic/"))
                set statusline+=%#warningmsg#
                set statusline+=%{SyntasticStatuslineFlag()}
                set statusline+=%*

                let g:syntastic_always_populate_loc_list = 1
                let g:syntastic_auto_loc_list = 1
                let g:syntastic_check_on_open = 1
                let g:syntastic_check_on_wq = 0
            endif
        " }
    
        " Fugitive {
            if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
                nnoremap <silent> <leader>gs :Gstatus<CR>
                nnoremap <silent> <leader>gd :Gdiff<CR>
                nnoremap <silent> <leader>gc :Gcommit<CR>
                nnoremap <silent> <leader>gb :Gblame<CR>
                nnoremap <silent> <leader>gl :Glog<CR>
                nnoremap <silent> <leader>gp :Git push<CR>
                nnoremap <silent> <leader>gr :Gread<CR>
                nnoremap <silent> <leader>gw :Gwrite<CR>
                nnoremap <silent> <leader>ge :Gedit<CR>
                " Mnemonic _i_nteractive
                nnoremap <silent> <leader>gi :Git add -p %<CR>
                nnoremap <silent> <leader>gg :SignifyToggle<CR>
            endif
        " }
        
        " ctrlp {
            if isdirectory(expand("~/.vim/bundle/ctrlp.vim/"))
                let g:ctrlp_working_path_mode = 'ra'
                nnoremap <silent> <D-t> :CtrlP<CR>
                nnoremap <silent> <D-r> :CtrlPMRU<CR>
                let g:ctrlp_custom_ignore = {
                    \ 'dir':  '\.git$\|\.hg$\|\.svn$',
                    \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

                if executable('ag')
                    let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
                elseif executable('ack-grep')
                    let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
                elseif executable('ack')
                    let s:ctrlp_fallback = 'ack %s --nocolor -f'
                " On Windows use "dir" as fallback command.
                else
                    let s:ctrlp_fallback = 'find %s -type f'
                endif
                if exists("g:ctrlp_user_command")
                    unlet g:ctrlp_user_command
                endif
                let g:ctrlp_user_command = {
                    \ 'types': {
                        \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
                        \ 2: ['.hg', 'hg --cwd %s locate -I .'],
                    \ },
                    \ 'fallback': s:ctrlp_fallback
                \ }

                if isdirectory(expand("~/.vim/bundle/ctrlp-funky/"))
                    " CtrlP extensions
                    let g:ctrlp_extensions = ['funky']

                    "funky
                    nnoremap <Leader>fu :CtrlPFunky<Cr>
                endif
            endif
        " }
        
        " UndoTree {
            if isdirectory(expand("~/.vim/bundle/undotree/"))
                nnoremap <Leader>u :UndotreeToggle<CR>
                " If undotree is opened, it is likely one wants to interact with it.
                let g:undotree_SetFocusWhenToggle=1
            endif
        " }
        
        " Tabularize {
            if isdirectory(expand("~/.vim/bundle/tabular"))
                nmap <Leader>a& :Tabularize /&<CR>
                vmap <Leader>a& :Tabularize /&<CR>
                nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
                vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
                nmap <Leader>a=> :Tabularize /=><CR>
                vmap <Leader>a=> :Tabularize /=><CR>
                nmap <Leader>a: :Tabularize /:<CR>
                vmap <Leader>a: :Tabularize /:<CR>
                nmap <Leader>a:: :Tabularize /:\zs<CR>
                vmap <Leader>a:: :Tabularize /:\zs<CR>
                nmap <Leader>a, :Tabularize /,<CR>
                vmap <Leader>a, :Tabularize /,<CR>
                nmap <Leader>a,, :Tabularize /,\zs<CR>
                vmap <Leader>a,, :Tabularize /,\zs<CR>
                nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
                vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            endif
        " }

    " }
" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    ""set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    " To disable the stripping of whitespace, add the following to your
    " .vimrc.before.local file:
    "   let g:spf13_keep_trailing_whitespace = 1
    "" autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    "" autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    "" autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    "" autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    "" autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    "" autocmd FileType haskell,rust setlocal nospell

" }

" Key Mappings {

    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    " If you prefer that functionality, add the following to your
    " .vimrc file:
    "   let g:spf13_no_easyWindows = 1
    map <C-J> <C-W>j<C-W>_
    map <C-K> <C-W>k<C-W>_
    map <C-L> <C-W>l<C-W>_
    map <C-H> <C-W>h<C-W>_

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>
" }

" Functions {
    " Strip whitespace {
    function! StripTrailingWhitespace()
        " Preparation: save last search, and cursor position.
        let _s=@/
        let l = line(".")
        let c = col(".")
        " do the business:
        %s/\s\+$//e
        " clean up: restore previous search history, and cursor position
        let @/=_s
        call cursor(l, c)
    endfunction
    " }
" }


