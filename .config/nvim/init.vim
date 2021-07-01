" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
let mapleader=" " 

call plug#begin('~/.vim/plugged')

Plug 'lervag/vimtex'
" let g:vimtex_compiler_tectonic = {
" 	'build_dir': '',
" \}
" let g:vimtex_compiler_method = 'tectonic'
let g:vimtex_compiler_latexmk = {
    \ 'options' : [
    \   '-pdf',
    \   '-shell-escape',
    \   '-verbose',
    \   '-file-line-error',
    \   '-synctex=1',
    \   '-interaction=nonstopmode',
    \ ],
    \}
set conceallevel=1
let g:tex_conceal='abdmg'

" WakaTime time tracking
Plug 'wakatime/vim-wakatime'

" Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
Plug 'junegunn/vim-easy-align'

" Any valid git URL is allowed
Plug 'https://github.com/junegunn/vim-github-dashboard.git'

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

" Plugin outside ~/.vim/plugged with post-update hook
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

Plug '907th/vim-auto-save'

Plug 'sonph/onehalf', {'rtp': 'vim/'}

Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Markdown
Plug 'godlygeek/tabular'

" Language support
Plug 'plasticboy/vim-markdown'
Plug 'digitaltoad/vim-pug'

" Multi cursors
Plug 'terryma/vim-multiple-cursors'

" Color scheme synchronization with wal
Plug 'dylanaraps/wal'

" UltiSnips
Plug 'SirVer/ultisnips'
" Set ultisnips triggers
let g:UltiSnipsExpandTrigger="<tab>"                                            
let g:UltiSnipsJumpForwardTrigger="<tab>"                                       
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"     

Plug 'drewtempelmeyer/palenight.vim'

Plug 'preservim/nerdtree'
" Open nerdtree when vim opens
" autocmd vimenter * NERDTree
" Show hidden files
let NERDTreeShowHidden=1
" Show working dir instead of $HOMEDIR
let NERDTreeChDirMode=2

Plug 'Xuyuanp/nerdtree-git-plugin'

Plug 'easymotion/vim-easymotion'

Plug 'tpope/vim-abolish'

Plug 'chaoren/vim-wordmotion'

Plug 'kana/vim-textobj-user'

" WIP
" call textobj#user#plugin('fillable', {
" \ 	'-': {
" \		'select-a-function': 'NextFillableLineA',
" \		'select-a': 'aF',
" \		'select-i-function': 'NextFillibleLineI',
" \		'select-i': 'iF',
" \ 	},
" \ })
" 
" function! NextFillableLineA()
" 	normal! /\/\/\/
" 	let line = getline('.')

Plug 'thinca/vim-textobj-between'

Plug 'dag/vim-fish'

Plug 'mboughaba/i3config.vim'

Plug 'unblevable/quick-scope'
	let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']

Plug 'editorconfig/editorconfig-vim'

Plug 'iloginow/vim-stylus'

Plug 'pangloss/vim-javascript'

Plug 'evanleck/vim-svelte', {'branch': 'main'}
let g:svelte_preprocessors = ["typescript"]

" Initialize plugin system
call plug#end()

" Color (synced with wal)
syntax on
set t_Co=256
set cursorline
colorscheme onehalflight
set background=light
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let current_wal_variant = system('cat $HOME/.config/current_color_scheme')
if current_wal_variant =~# 'dark'
	colorscheme onehalfdark
	set background=dark
endif
" colorscheme palenight
" set background=dark
"colorscheme wal
" fix different background color
highlight Normal ctermbg=black

" Typewriter mode
set scrolloff=99
" Line numbers
set number
set relativenumber
" Disable softwrap
set nowrap

" Enable autosave
let g:auto_save = 1

" GUI stuff (for e.g. Neovide)
set guifont=Cartograph\ CF:h12

