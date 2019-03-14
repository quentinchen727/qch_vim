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

" enable filetype plugins and indent, the filetype also being enabled. See :filetype-overview

filetype plugin on
filetype indent on

" Set to auto read when a file is changed from the outside
set autoread

" With a map leader it's possible to do extra key combinations
let mapleader = " "

" quick editing and sourcing vimrc config file
nnoremap <leader>ev :n $MYVIMRC<cr> " $MYVIMRC resolves to ~/.vimrc
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

" Show incomplete commands or numbers of characters/lines
set showcmd

" Ignore compiled files when expanding wildcars or autocompleting
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_STORE
endif

" Awalys show current position
set ruler " on the bottom right: line,column(relative/absolute),percent/top/bottom

" Highlight the current line
set cursorline

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
" <C-R>=@/<CR> also gets the / register, which == <C-R>/
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>/<CR>
"""""""""""""""""""""""""""""""}}}

""""""""""""""""" => Moving around, tabs, windows and buffers {{{
" Disable highlight
nnoremap <silent> <leader><cr> :noh<cr>

" Smart way to move between windows
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-h> <C-W>h
nnoremap <C-l> <C-w>l

" Better splits (new windows appear below and to the right)
set splitbelow
set splitright

" Buffer management
nnoremap <leader>bd :bd<cr>
nnoremap <leader>ba :bufdo bd<cr> " Close all buffers
nnoremap <leader>l :bnext<cr>
nnoremap <leader>h :bprevious<cr>

" Tab management. Not that useful
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tm :tabmove
nnoremap <leader>t<leader> :tabnext

" toggle between tabs
if !exists("g:lasttab") " check if some option/variable exists
    let g:lasttab = 1
endif
" equivalent: nmap <leader>tl :exe "tabn ". g:lasttab<cr>
nnoremap <leader>tl :tabn <C-r>=g:lasttab<cr><cr>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
" Super useful when editing files in the same directory
nnoremap <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer for all windows
" lcd only changes the directory of the current window
map <leader>cd :cd %:h<cr>:pwd<cr>

" Specify the behavior when swithcing between buffers
try
    set switchbuf=useopen,usetab,newtab
catch
endtry

" always show the tab line
set showtabline=2

" Return to last known position when opening files
" 'g;' go the last position in change list; g'" go the last known position
" '": the cursor position when last existing the current
au BufReadPost * if line("'\"") > 1 && line ("'\"") <= line("$") | exe "normal! g'\"" | endif

""""""""""""""}}}

""""""""""""" => Statue line{{{
" Always show the status line
    set laststatus=2

" Format the status line %-0{minwid}.{maxwid}{item}
" %F: full path; $m: modified flag; %r: readonly; %h: help; %w: preview
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ PWD:\ %{getcwd()}\ \ \ Line:\ %l\ \ Column:\ %c\ %P
"""""""""""""""}}}

""""""""""""""""""""""" => Editing mappings{{{
"  Move a line of text using ALT=[jk] or Command+[jk] on mac
nnoremap <M-j> mz:m+<cr>`z
nnoremap <M-k> mz:m-2<cr>`z
"  Move a line/lines of text using ALT+[jk] or Command+[jk] on mac
vnoremap <M-j> :m'>+<cr>'<my'>mzgv'yo'z
vnoremap <M-k> :m'<-2<cr>'>my'<mzgv'yo'z

if has("mac") || has("macunix")
    nnoremap <D-j> <M-j>
    nnoremap <D-k> <M-k>
    vnoremap <D-j> <M-j>
    vnoremap <D-k> <M-k>
endif

" Deleting all trailing white space on save, useful for some filetypes
fun! CleanExtraSpaces()
    let save_cursor = getpos(".") " get position of the current cursor
    let old_query = getreg('/') " get register /
    silent! %s/\s\+$//e   " e flag suppresses errors
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.js,*.py,*.wiki,*.sh,*.vimrc :call CleanExtraSpaces()
endif
""""""""""""""}}}

""""""""""""" => Spell checking{{{
" toggle and untoggle spell checking
noremap <leader>ss :setlocal spell!<cr>
noremap <leader>sp [s
noremap <leader>sa zg
noremap <leader>s? z=

"""""""""""""""}}}

""""""""""""""" => jumplist, locationlist, quickfix{{{
" jumplist does not rember j/k/h/l/<c-d>/<c-u>;<c-o> goes back, <c-i> forward; It seems jumplist is implemented using hashmap and deque, similar to LRU, except it uses a pointer to record the current position. When you use a jump command, the current position is inserted at the end.
" m' set the previous context mark, and it can be used to switch between previous and current context;
" location-quickfix list is per window; quickfix is per file.
"""""""""""""""}}}

""""""""""""" => Misc{{{
" Remove the Windows ^M - when the encoding gets messed up
noremap <leader>m mmHmt:%s/<C-V><cr>//ge<cr>'tzt'm

" Quickly open a buffer for scribble
noremap <leader>q :e ~/buffer<cr>

" Quickly open a markdown buffer for scribble
noremap <leader>x :e ~/buffer.md<cr>

" Toggle paste mode no and off
noremap <leader>pp :setlocal paste!<cr>
"""""""""""}}}

""""""""""""" => Helper functions{{{
" Use "<register> y to paste into <register>
" Unscoped function must start with a big cap
" Paste mode is useful if you want to copy some text from one window and paste it in Vim when using Vim in a terminal. GVim can handle it by itself.
" Different windows have their paste mode.
" Mapping in insert mode is disabled when paste is on.
function! HasPaste()
    if &paste
        return 'PASTE MODE'
    endif
    return ''
endfunction

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    " Move and copy the last v selection
    execute "normal! gvy"

    " escape all in second parmaters with '\'
    let l:pattern = escape(@", "\\/.*'$^~[]")
    " substitute pattern with replace and flags
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' ")
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/' . l:pattern . '/')
    endif

    call setreg('/', l:pattern)
    call setreg('"', l:saved_reg)
    " Equivalent: let @/ = l:pattern
    "             let @" = l:saved_reg
endfunction

"""}}}

""""""""""""""""""""""""" =>  Plugins {{{
" one life-time auto installation of Plug manager
if !has('win16') && !has('win32') && empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Let Plug manage my plugins. Designate a directory for plugins.
" Use windows default for windows, linux and mac
call plug#begin('~/vimfiles/bundle')

Plug 'scrooloose/nerdtree', {'on': 'NERDTreeToggle'}

nnoremap <leader>' :NERDTreeToggle<cr>

Plug 'lifepillar/vim-solarized8'

Plug 'w0rp/ale'

Plug 'hhvm/vim-hack'

call plug#end()

colorscheme solarized8
""""""""""""""""""""""""""""""""}}}

