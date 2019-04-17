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

" Always highlight column 81 so it's easier to see where
" cutoff appears on longer screens
set colorcolumn=81  " highlight column after 'textwidth'
augroup highlight_81_col
  autocmd!
  autocmd BufEnter * highlight ColorColumn ctermbg=lightgrey
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""}}}

"""""""""""""" => Colors and Fonts{{{
" Always enable syntax hightlighting whatever terminal or GUI we are on; Vim will automatiy detect file type and load the right syntax highlighting.
syntax enable

" Enable 256 colors plaette
set t_Co=256
set termguicolors

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

" Move down/up half page
nnoremap \ <c-d>
nnoremap <bs> <c-u>

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

"  Execute the current python file
augroup python_file
    autocmd!
    autocmd FileType python nnoremap <buffer> <leader>e :exec '!py'  shellescape(@%,1)<cr>
    " Press `K` to view the type in the gutter
    autocmd FileType python nnoremap <buffer> <silent> K :ALEHover<CR>
    " Type `gd` to go to definition
    autocmd FileType python nnoremap <buffer> <silent> gd :ALEGoToDefinition<CR>
augroup END
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

""""""""""""""""""""""""""""""""""""""""""
" hackfmt on range
""""""""""""""""""""""""""""""""""""""""""
function! HackFmt(width) range
  let start = a:firstline
  let end = a:lastline
  " current range contents, for comparison
  let curr = join(getline(start, end), "\n")."\n"
  " the replacement command (passes the full buffer as stdin)
  let cmd = "hackfmt --line-width=".a:width." --range ".line2byte(start)." ".line2byte(end+1)
  let output = system(cmd, join(getline(1, '$'), "\n"))

  " if they are the (case-sensitive) same, then don't touch the file
  if curr ==# output
    return
  endif

  " otherwise, delete what's there and put the new output
  execute start.",".end."d"
  execute start-1."put =output"
endfunction
command! -range -nargs=1 HackFmt <line1>,<line2>call HackFmt(<args>)
noremap <leader>k :HackFmt<Home>silent <End> 80<CR>
noremap <leader>kk :HackFmt<Home>silent <End> 80<CR>
noremap <leader>kl :HackFmt<Home>silent <End> 120<CR>

" If you are using a console version of Vim, or dealing
" with a file that changes externally (e.g. a web server log)
" then Vim does not always check to see if the file has been changed.
" The GUI version of Vim will check more often (for example on Focus change),
" and prompt you if you want to reload the file.
"
" There can be cases where you can be working away, and Vim does not
" realize the file has changed. This command will force Vim to check
" more often.
"
" Calling this command sets up autocommands that check to see if the
" current buffer has been modified outside of vim (using checktime)
" and, if it has, reload it for you.
"
" This check is done whenever any of the following events are triggered:
" * BufEnter
" * CursorMoved
" * CursorMovedI
" * CursorHold
" * CursorHoldI
"
" In other words, this check occurs whenever you enter a buffer, move the cursor,
" or just wait without doing anything for 'updatetime' milliseconds.
"
" Normally it will ask you if you want to load the file, even if you haven't made
" any changes in vim. This can get annoying, however, if you frequently need to reload
" the file, so if you would rather have it to reload the buffer *without*
" prompting you, add a bang (!) after the command (WatchForChanges!).
" This will set the autoread option for that buffer in addition to setting up the
" autocommands.
"
" If you want to turn *off* watching for the buffer, just call the command again while
" in the same buffer. Each time you call the command it will toggle between on and off.
"
" WatchForChanges sets autocommands that are triggered while in *any* buffer.
" If you want vim to only check for changes to that buffer while editing the buffer
" that is being watched, use WatchForChangesWhileInThisBuffer instead.
"
command! -bang WatchForChanges                  :call WatchForChanges(@%,  {'toggle': 1, 'autoread': <bang>0})
command! -bang WatchForChangesWhileInThisBuffer :call WatchForChanges(@%,  {'toggle': 1, 'autoread': <bang>0, 'while_in_this_buffer_only': 1})
command! -bang WatchForChangesAllFile           :call WatchForChanges('*', {'toggle': 1, 'autoread': <bang>0})
" WatchForChanges function
"
" This is used by the WatchForChanges* commands, but it can also be
" useful to call this from scripts. For example, if your script executes a
" long-running process, you can have your script run that long-running process
" in the background so that you can continue editing other files, redirects its
" output to a file, and open the file in another buffer that keeps reloading itself
" as more output from the long-running command becomes available.
"
" Arguments:
" * bufname: The name of the buffer/file to watch for changes.
"     Use '*' to watch all files.
" * options (optional): A Dict object with any of the following keys:
"   * autoread: If set to 1, causes autoread option to be turned on for the buffer in
"     addition to setting up the autocommands.
"   * toggle: If set to 1, causes this behavior to toggle between on and off.
"     Mostly useful for mappings and commands. In scripts, you probably want to
"     explicitly enable or disable it.
"   * disable: If set to 1, turns off this behavior (removes the autocommand group).
"   * while_in_this_buffer_only: If set to 0 (default), the events will be triggered no matter which
"     buffer you are editing. (Only the specified buffer will be checked for changes,
"     though, still.) If set to 1, the events will only be triggered while
"     editing the specified buffer.
"   * more_events: If set to 1 (the default), creates autocommands for the events
"     listed above. Set to 0 to not create autocommands for CursorMoved, CursorMovedI,
"     (Presumably, having too much going on for those events could slow things down,
"     since they are triggered so frequently...)
function! WatchForChanges(bufname, ...)
  " Figure out which options are in effect
  if a:bufname == '*'
    let id = 'WatchForChanges'.'AnyBuffer'
    " If you try to do checktime *, you'll get E93: More than one match for * is given
    let bufspec = ''
  else
    if bufnr(a:bufname) == -1
      echoerr "Buffer " . a:bufname . " doesn't exist"
      return
    end
    let id = 'WatchForChanges'.bufnr(a:bufname)
    let bufspec = a:bufname
  end
  if len(a:000) == 0
    let options = {}
  else
    if type(a:1) == type({})
      let options = a:1
    else
      echoerr "Argument must be a Dict"
    end
  end
  let autoread    = has_key(options, 'autoread')    ? options['autoread']    : 0
  let toggle      = has_key(options, 'toggle')      ? options['toggle']      : 0
  let disable     = has_key(options, 'disable')     ? options['disable']     : 0
  let more_events = has_key(options, 'more_events') ? options['more_events'] : 1
  let while_in_this_buffer_only = has_key(options, 'while_in_this_buffer_only') ? options['while_in_this_buffer_only'] : 0
  if while_in_this_buffer_only
    let event_bufspec = a:bufname
  else
    let event_bufspec = '*'
  end
  let reg_saved = @"
  "let autoread_saved = &autoread
  let msg = "\n"
  " Check to see if the autocommand already exists
  redir @"
    silent! exec 'au '.id
  redir END
  let l:defined = (@" !~ 'E216: No such group or event:')
  " If not yet defined...
  if !l:defined
    if l:autoread
      let msg = msg . 'Autoread enabled - '
      if a:bufname == '*'
        set autoread
      else
        setlocal autoread
      end
    end
    silent! exec 'augroup '.id
      if a:bufname != '*'
        "exec "au BufDelete    ".a:bufname . " :silent! au! ".id . " | silent! augroup! ".id
        "exec "au BufDelete    ".a:bufname . " :echomsg 'Removing autocommands for ".id."' | au! ".id . " | augroup! ".id
        exec "au BufDelete    ".a:bufname . " execute 'au! ".id."' | execute 'augroup! ".id."'"
      end
        exec "au BufEnter     ".event_bufspec . " :checktime ".bufspec
        exec "au CursorHold   ".event_bufspec . " :checktime ".bufspec
        exec "au CursorHoldI  ".event_bufspec . " :checktime ".bufspec
      " The following events might slow things down so we provide a way to disable them...
      " vim docs warn:
      "   Careful: Don't do anything that the user does
      "   not expect or that is slow.
      if more_events
        exec "au CursorMoved  ".event_bufspec . " :checktime ".bufspec
        exec "au CursorMovedI ".event_bufspec . " :checktime ".bufspec
      end
    augroup END
    let msg = msg . 'Now watching ' . bufspec . ' for external updates...'
  end
  " If they want to disable it, or it is defined and they want to toggle it,
  if l:disable || (l:toggle && l:defined)
    if l:autoread
      let msg = msg . 'Autoread disabled - '
      if a:bufname == '*'
        set noautoread
      else
        setlocal noautoread
      end
    end
    " Using an autogroup allows us to remove it easily with the following
    " command. If we do not use an autogroup, we cannot remove this
    " single :checktime command
    " augroup! checkforupdates
    silent! exec 'au! '.id
    silent! exec 'augroup! '.id
    let msg = msg . 'No longer watching ' . bufspec . ' for external updates.'
  elseif l:defined
    let msg = msg . 'Already watching ' . bufspec . ' for external updates'
  end
  echo msg
  let @"=reg_saved
endfunction

let autoreadargs={'autoread':1}
execute WatchForChanges("*",autoreadargs)

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

" Post hook to compile and install command-t
Plug 'wincent/command-t', {
\   'do': 'cd ruby/command-t/ext/command-t && ruby extconf.rb && make'
\ }
let g:CommandTFileScanner='watchman'
let g:CommandTMaxFiles=200000

Plug 'tpope/vim-commentary'
Plug 'Raimondi/delimitMate'

" Plug 'lifepillar/vim-solarized8'
Plug 'morhetz/gruvbox'

" Plug 'prabirshrestha/async.vim'
" Plug 'prabirshrestha/vim-lsp'

" if executable('pyls')
" " pip install python-language-server
"     au User lsp_setup call lsp#register_server({
"         \ 'name': 'pyls',
"         \ 'cmd': {server_info->['pyls']},
"         \ 'whitelist': ['python'],
"         \ })
" endif

Plug 'w0rp/ale'
" Automatic completion
let g:ale_completion_enabled = 1
" Include the linter name (e.g. 'hack' or 'hhast'), code, and message in errors
let g:ale_echo_msg_format = '[%linter%]% [code]% %s'
" Enable HHAST - this has security implications (see below)
let g:ale_linters = { 'hack': ['hack', 'hhast'] , 'python': ['pyls', 'pylint', 'flake8'], 'javascript': ['flow', 'eslint']}
augroup hack_short_cuts
autocmd!
" Press `K` to view the type in the gutter
autocmd FileType php,hack nnoremap <buffer> <silent> K :ALEHover<CR>
" Type `gd` to go to definition
autocmd FileType php,hack nnoremap <buffer> <silent> gd :ALEGoToDefinition<CR>
" Meta-click (command-click) to go to definition
autocmd FileType php,hack nnoremap <buffer> <M-LeftMouse> <LeftMouse>:ALEGoToDefinition<CR>
augroup END

" show type on hover in a floating bubble. This does not work without `balleval`
if v:version >= 801
  set balloonevalterm
  let g:ale_set_balloons = 1
  let balloondelay = 250
endif

" On-demand loading for hack
Plug 'hhvm/vim-hack', {'for': ['hack','php']}

Plug 'flowtype/vim-flow', {'for': ['javascript']}
augroup flow_short_cuts
autocmd!
" Press `K` to view the type in the gutter
autocmd FileType javascript nnoremap <buffer> <silent> K :FlowType<CR>
" Type `gd` to go to definition
autocmd FileType javascript nnoremap <buffer> <silent> gd :FlowJumpToDef<CR>
" Meta-click (command-click) to go to definition
autocmd FileType javascript nnoremap <buffer> <M-LeftMouse> <LeftMouse>:FlowJumpToDef<CR>
augroup END

call plug#end()

" colorscheme solarized8
colorscheme gruvbox
""""""""""""""""""""""""""""""""}}}
