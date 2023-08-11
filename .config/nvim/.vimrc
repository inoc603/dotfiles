"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Vimrc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" open vimrc
noremap <F7> :e $MYVIMRC<CR>
" source vimrc
noremap <F8> :source $MYVIMRC<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Display
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set bg=dark           " prefer dark themes
set colorcolumn=100   " add a line length guard at the 100th column
set number            " show line numbers
set showcmd           " show command in bottom bar
set cursorline        " highlight current line
set showmatch         " highlight matching [{()}]
set scrolloff=7       " keep some lines visible when moving cursor
set synmaxcol=512     " prevent slow rendering on large files with syntax highlighting
set guicursor=i:ver25 " turn cursor to vertical line in insert mode
set signcolumn=yes    " alwasy show sign column

syntax on


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Wild menu
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
	set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
else
	set wildignore+=.git\*,.hg\*,.svn\*
endif


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Search
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set hlsearch
set ignorecase
set smartcase

" Cancel highlight when you're done seraching
nnoremap <F10> :nohlsearch<CR>

" center the cursor when moving between search results
nnoremap n nzzzv
nnoremap N Nzzzv


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic key map
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use space as leader key
let mapleader=' '

" Disable arrow keys
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>

" Use kj to switch to normal mode
inoremap kj <Esc>

" A terrible place to be.
nnoremap Q <nop>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Files and session
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Quick save
nnoremap <silent> <leader>w :w<CR>
" Close current window
nmap <silent> <leader>q :q<CR>
" Close all windows
nmap <silent> <leader><leader>q :qall<CR>
set nobackup
set nowb
set noswapfile


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Movement
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Treat long lines as break lines
nnoremap j gj
nnoremap k gk
set whichwrap+=<,>,h,l

" Use H/L to move to start/end of line
" Also remap common combination because H/L are originally used to go to
" top/bottom of window
nnoremap H ^
nnoremap L $
nnoremap cH c^
nnoremap cL c$
nnoremap dH d^
nnoremap dL d$
vnoremap H ^
vnoremap L $


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Ctrl-j,k,h,l to move between windows
" With the christoomey/vim-tmux-navigator plugin you can navigate between tmux
" and vim windows seamlessly
if mapcheck("<C-j>", ":TmuxNavigateDown") == ""
	map <C-j> <C-W>j
	map <C-k> <C-W>k
	map <C-h> <C-W>h
	map <C-l> <C-W>l
endif

nmap <leader>h :split<CR>
nmap <leader>v :vsplit<CR>

set diffopt=vertical

" - to switch to previous buffer(left)
nmap <silent> - :bprevious<CR>
" = to switch to next buffer(right)
nmap <silent> = :bnext<CR>

" These only works on iTerm2
" Alt-l to swtich to last used buffer
map ¬ :b#<CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Copy and Paste
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use Ctrl-c and Ctrl-v to copy and paste to system clipboard
vmap <C-c> "*yy
nmap <C-v> "*p
imap <C-v> <Esc><C-v>a


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Editing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Move line(s) up and down
" Probably not work in Iterm2
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Special mapping for Alt to work with iTerm2 on mac, with default setting
" If alt key is configured to send +Esc, you can have a mapping with an
" invisible prefix, but you'll often accidentally move your code when exiting
" insert mode
map ∆ <A-j>
map ˚ <A-k>

" Insert new line using enter
nnoremap <CR> o<Esc>

" Stay in visual mode after indent
vnoremap > >gv
vnoremap < <gv

set autowriteall

" remove tailing whitespaces
nnoremap <F2> :%s/\s\+$//e<CR>

if has("nvim")
        set termguicolors
	luafile $HOME/.config/nvim/lua/init.lua
	set jumpoptions=stack
	set cmdheight=0
endif

" Get the highlight group under cursor
nnoremap <F9> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
