"""""""""""""Content{{{
" Maintainer:
"         Qin Chen
" Basic version to learn from @amix3k
" Github link: https://github.com/amix/vimrc
"
" 
" Sections:
"         -> General
"         -> VIM user interface
"         -> Colors and Fonts
"         -> Files and backps
"         -> Text, tab and indent related
"         -> Visual mode related
"         -> Moving around, tabs and buffers
"         -> Status line
"         -> Editing mappings
"         -> vimgrep searching and cope displaying
"         -> Spell checking
"         -> Misc
"         -> Help functions
" Notes:
" when using set foo=xxx, xxx could be number or string without quotes, and there is no space.
"""""""""""""""""""""""""""""""""""""""""""""""}}}

""""""""""" => General {{{
set nocompatible

" Sets how many lines of history vim has to remember
set history=500

" Enable filetype plugins
filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
let mapleader = ","

" quick editing and sourcing vimrc config file
nnoremap <leader>ev :vsplit $MYVIMRC<cr> " $MYVIMRC resolves to ~/.vimrc
nnoremap <leader>sv :source $MYVIMRC<cr>

" nocompatible with vi
" Fast saving
nnoremap <leader>w :w!<cr>

" Fast existing insert m=ode
inoremap jk <esc>

" :W sudo saves the file
" (usefule for handling the permisssion-denied error
" Does not work on windows
" command W w !sudo tee % > /dev/null
"""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""" => VIM user interface{{{
" Set the top/bottom 7 lines away to the cursor
set scrolloff=7  " set so=7

" display current line and relative line number
set number
set relativenumber

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" Turn on the wild menu
set wildmenu " when on, command-line completion prompts above the cmd line

" Ignore compiled files when expanding wildcars or autocompleting
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_STORE
endif

" Awalys show current position
set ruler " on the bottom right: line,column(relative/absolute),percent/top/bottom

" Height of the command bar
set cmdheight=2

" A buffer becomes hidden when it is abandoned
" when switching with unsaved change, it is marked as 'h' in buffer list
" otherwise vim will refuse to switch
set hid

" Configure backspace so it acts as it should
" make backspace can delete indent, line breaks.
" this is equal: backspace=indent,eol,start
set backspace=2
set whichwrap+=<,>,h,l " Allow specified keys to move to the previous/next lines

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases
" If containing upper case characters and the search pattern is typed,
" used for "/", "?", "n", "N", ":g" and ":s".
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expression turn magic on, the default option
" overwrite option: \v very magic, \V very nomagic, \m magic, \M nomagic
" magic: still need to escape (), | to get special meanings, but not for {}
set magic

" Show matching brackets when inserting a bracket, i.e., {, (, [
set showmatch
" How many tenths of a second to blink when inserting matching brackets
set mat=2

" No annoying beeping and flash on errors
set noerrorbells
set novisualbell
set t_vb= " maybe redudant. Could use `set vb t_vb=`

" equal to tm=500 time to wait for a mapped key sequence
" important to tune for key combinations/mappings
set timeoutlen=500

" Properly disable sound on erros on MacVim
if has("gui_macvim")
    autocmd GUIEnter * set vb t_vb=
endif

" Add a bit extra margin to the left. By default 0
set foldcolumn=1
"""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""" => Colors and Fonts{{{
" Always enable syntax hightlighting whatever terminal or GUI we are on; Vim will automatiy detect file type and load the right syntax highlighting.
syntax enable

" Enable 256 colors plaette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256 " number of colors
endif

try
    colorscheme desert
catch
endtry

set background=dark

" Set extra options when runnin in GUI mode
if has("gui_running")
    set guioptions-=T " remove Tool bar
    set guioptions-=e " remove tab pages
    set t_Co=256
    set guitablabel=%M\ %t " %M modified flag, %t file name(tail) in buffer for tab names
endif

" Set utf8 as standard encoding and en_US as the standard language
set encoding=utf8

" Use Unix as the standard file type to interpret end of line <EOL>
" dos: <CR><NL> \r\n ; unix: <NL> \n ; mac: <CR> \r ;
set ffs=unix,dos,mac 

"""""""""""""""""""""""""""""""""""""""""""""""}}}

""""""""""""""""""""""""""" => Files, backups and undo{{{
" Turn backup off, since most stuff is in git, hg, svn etc
set nobackup
set nowb " But by default wb + nobackup
set noswapfile " swapfile saves the changes since the original file
"""""""""""""""""""""""""""""""""""""""}}}

""""""""""""" => Text, tab and indent related{{{
" Use spaces instead of tabs; use :retab to expand existing tabs
set expandtab

" Be smart when using tabs
set smarttab

" 1 tab == 4 spaces
set shiftwidth=4 " for shift >, >> movement
set tabstop=4 " <Tab> calculation for :rehab/expandtab?
set softtabstop=4 " number of spaces to insert a tab

" Copy the current indent to new lines; delete it if nothing is added
set autoindent 
" Be smart with autoindenting, like after a line ending with {
set smartindent

" Unlimited textwidth, so no automatic <EOL> inserted. Just wrap around the visual boundary and only break at `breakat` characters.
set tw=0
set wrap
set linebreak
""""""""""""""""""""""""""""""""}}}

""""""""""""" => Visual mode related {{{
" Visual mode pressing * or # searching for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>

""""""""""""""""""""""""""""""""}}}

""""""""""""" => Helper functions{{{
" Uscope function must start with a big cap
function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' ")
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/' . l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Let Plug manage my plugins
call plug#begin('~/vimfiles/bundle')

Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

call plug#end()
