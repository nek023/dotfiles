" ------------------------------------------------------------------------------
" 基本
" ------------------------------------------------------------------------------
" vi互換
set nocompatible

" タブ文字を空白文字にする
set expandtab

" タブ文字を何文字の空白文字にするか
set tabstop=4

" タブ文字をキーボードで入力した際に何文字の空白文字にするか
set softtabstop=4

" 自動インデントを行う際に何文字の空白文字にするか
set shiftwidth=4

" インデントを 'shiftwidth' の値の倍数に丸める
set shiftround

" 文字コードの指定
set encoding=utf-8

" Backspaceで改行を削除する
set backspace=2

" 行数を表示する
set number

" カーソル行からの相対行数を表示する
set relativenumber

" 折り返し
set wrap

" 改行時に自動的にインデントを挿入する
set autoindent
set nosmartindent
set nocindent

" 行頭の余白内で<Tab>を押すとshiftwidthの数だけインデントする
set smarttab

" コマンド補完を有効にする
set wildmenu

" コマンド補完時にマッチするコマンドをすべて表示して最初の候補を補完する
set wildmode=list:full

" 常にステータスラインを表示する
set laststatus=2

" ステータスラインに表示する内容を指定する
set statusline=%f%m%=%y[%{&fileencoding}][%{&fileformat}]

" 検索にヒットした文字列をハイライトする
set hlsearch

" 検索時に大文字小文字を無視する
set ignorecase

" 大文字で検索された場合は大文字だけヒットさせる
set smartcase

" インクリメンタルサーチを有効にする
set incsearch

" タブ・空白・改行などの非表示文字を表示する
set list

" タブと行末スペースを表す文字を指定する
set listchars=tab:>\ ,trail:-

" vimの外でのファイル変更を自動的に反映させる
set autoread

" バッファのスワップファイルを作成しない
set noswapfile

" バックアップファイルを作成しない
set nobackup

" ビープ音と画面のフラッシュを無効にする
set noerrorbells
set novisualbell
set visualbell t_vb=

" モードラインを有効にする
set modeline

" 3行目までをモードラインとして検索する
set modelines=3

" 折り畳みの設定
set foldmethod=marker
set foldcolumn=3
set foldlevel=99
"set foldlevelstart=99

" 補完候補選択時にプレビューを表示しない
set completeopt=menuone

" スクロール時にカーソルを中央に維持
"set scrolloff=999999

" カーソルがある行を強調表示する
set cursorline

" 行を跨いでカーソル移動できるようにする
"set whichwrap=b,s,h,l,<,>,[,],~

" マクロなどの途中経過を描写しない
set lazyredraw

" シンタックスハイライト
syntax on

" 括弧のハイライトを無効にする
let loaded_matchparen = 1

" 行継続のための\のインデント
let g:vim_indent_cont = 0

" 改行時のコメント補完を無効にする
augroup disable_comment_completion
  autocmd!
  autocmd BufEnter * setlocal formatoptions-=r
  autocmd BufEnter * setlocal formatoptions-=o
augroup END

" ------------------------------------------------------------------------------
" ファイルタイプ
" ------------------------------------------------------------------------------
" 拡張子mのファイルをObjective-Cのファイルとして認識
let g:filetype_m = 'objc'

" CoffeeScriptを認識させる
au BufRead, BufNewFile, BufReadPre *.coffee set filetype=coffee

" CoffeeScriptのインデントを設定
autocmd FileType coffee setlocal sw=2 sts=2 ts=2 et

" ------------------------------------------------------------------------------
" キーマッピング
" ------------------------------------------------------------------------------
" <Leader> の設定
let mapleader = '\'

" .vimrcを再読み込みする
nnoremap <Leader>s :source ~/.vimrc<CR>

" 高速移動
noremap H b
noremap J }
noremap K {
noremap L w

" 行移動を見た目上の移動にする
noremap j gj
noremap k gk

" 行頭・行末移動
noremap 9 ^
noremap 0 $

" 分割したウィンドウのサイズを変更する
nnoremap <C-w>+ :resize +5<CR>
nnoremap <C-w>- :resize -5<CR>
nnoremap <C-w>< :vertical resize -10<CR>
nnoremap <C-w>> :vertical resize +10<CR>

" 新しいタブを開く
nnoremap <silent> tt :tablast <bar> tabnew<CR>

" タブを閉じる
nnoremap <silent> tc :tabclose<CR>

" 前後のタブに移動する
nnoremap <silent> tn :tabnext<CR>
nnoremap <silent> tp :tabprevious<CR>

" 前後のバッファに移動する
"nnoremap <Tab>   :bnext<CR>
"nnoremap <S-Tab> :bprevious<CR>

" 現在開いているファイルをバッファから削除する
nnoremap <Leader>d :bdelete<CR>

" カーソル行の折り畳みを再帰的にすべて切り替える
nnoremap <Leader>z za

" ファイル全体の折り畳みを再帰的にすべて切り替える
nnoremap <Leader>Z :call ToggleAllFolds()<CR>

function! ToggleAllFolds()
  if &foldlevel == 0
    setlocal foldlevel=99
  else
    setlocal foldlevel=0
  endif
endfunction

" 検索にヒットした文字列のハイライトを非表示にする
nnoremap <Esc><Esc> :nohlsearch<CR>

" 検索にヒットした候補に移動したときに表示位置を中央に修正する
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" インデントを戻す
inoremap <S-Tab> <C-o><<

" ビジュアルモードでインデントを継続的に変更できるようにする
vnoremap < <gv
vnoremap > >gv

" ------------------------------------------------------------------------------
" プラグイン
" ------------------------------------------------------------------------------
call plug#begin()

Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/neocomplete.vim'
Plug 'Shougo/unite.vim'
Plug 'Shougo/neomru.vim' " for unite.vim
Plug 'ujihisa/unite-colorscheme'
Plug 'thinca/vim-quickrun'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'itchyny/lightline.vim'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tyru/caw.vim'
Plug 'osyo-manga/vim-over'
Plug 'tpope/vim-surround'
Plug 'airblade/vim-gitgutter'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'rhysd/clever-f.vim'
Plug 'cohama/lexima.vim'

Plug 'osyo-manga/shabadou.vim' " for vim-watchdogs
Plug 'osyo-manga/vim-watchdogs'
Plug 'othree/yajs.vim'
Plug 'dag/vim-fish'

Plug 'cocopon/iceberg.vim'

call plug#end()

" ------------------------------------------------------------------------------
" neocomplete.vim
" ------------------------------------------------------------------------------
" 起動時に有効にする
let g:neocomplete#enable_at_startup = 1

" 補完が自動で開始される文字数
let g:neocomplete#auto_completion_start_length = 3

" 大文字が入力されるまで大文字小文字の区別を無視する
let g:neocomplete#enable_smart_case = 1

" 大文字を区切りとして補完する
let g:neocomplete#enable_camel_case_completion = 1

" _(アンダーバー)を区切りとして補完する
let g:neocomplete#enable_underbar_completion = 1

" シンタックスをキャッシュするときの最小文字長を3に
let g:neocomplete#min_syntax_length = 3

" neocompleteを自動的にロックするバッファ名のパターン
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" -(ハイフン)入力による候補番号の表示
let g:neocomplete#enable_quick_match = 1

" 補完候補の一番先頭を選択状態にする
let g:neocomplete#enable_auto_select = 1

" ポップアップメニューで表示される候補の数
let g:neocomplete#max_list = 20

" キーワードの定義
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" <TAB>で候補を選択する
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"

" オムニ補完の有効化
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" オムニ補完の設定
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'

" ------------------------------------------------------------------------------
" unite.vim
" ------------------------------------------------------------------------------
" 入力モードで開始する
let g:unite_enable_start_insert=1

" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1

" 現在のバッファ一覧
noremap <C-u><C-b> :<C-u>Unite<Space>buffer<CR>

" カレントディレクトリのファイル一覧
noremap <C-u><C-f> :<C-u>Unite<Space>file<CR>

" 最近使ったファイルの一覧
noremap <C-u><C-r> :<C-u>Unite<Space>file_mru<CR>

" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>

" ------------------------------------------------------------------------------
" vim-quickrun
" ------------------------------------------------------------------------------
let g:quickrun_config = {}

" MarkdownをMarked 2.appで開く
let g:quickrun_config.markdown = {
  \ 'outputter' : 'null',
  \ 'command'   : 'open',
  \ 'cmdopt'    : '-a',
  \ 'args'      : 'Marked\ 2',
  \ 'exec'      : '%c %o %a %s',
  \ }

" ------------------------------------------------------------------------------
" vim-indent-guides
" ------------------------------------------------------------------------------
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_start_level=1
let g:indent_guides_auto_colors=0
let g:indent_guides_color_change_percent=20
let g:indent_guides_guide_size=1
let g:indent_guides_space_guides=1

autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  ctermbg=235
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven ctermbg=237

" ------------------------------------------------------------------------------
" NERDTree
" ------------------------------------------------------------------------------
" NERDTreeを開く/閉じる
nnoremap <silent><C-e> :NERDTreeToggle<CR>

" 隠しファイルを表示する
let g:NERDTreeShowHidden=1

" ------------------------------------------------------------------------------
" caw.vim
" ------------------------------------------------------------------------------
"  カーソル行をコメントイン/アウト
nmap <Leader>c <Plug>(caw:hatpos:toggle)
vmap <Leader>c <Plug>(caw:hatpos:toggle)

" ------------------------------------------------------------------------------
" vim-over
" ------------------------------------------------------------------------------
"  vim-overを起動する
nnoremap <silent> <Leader>m :OverCommandLine<CR>

" ------------------------------------------------------------------------------
" ctrlp.vim
" ------------------------------------------------------------------------------
" キーバインドの設定
let g:ctrlp_map = '<C-p>'

" コマンドの設定
let g:ctrlp_cmd = 'CtrlP'

" ワーキングディレクトリの探し方を指定する
" 'c' - the directory of the current file.
" 'a' - the directory of the current file, unless it is a subdirectory of the cwd
" 'r' - the nearest ancestor of the current file that contains one of these directories or files: .git .hg .svn .bzr _darcs
" 'w' - modifier to "r": start search from the cwd instead of the current file's directory
" 0 or '' (empty string) - disable this feature.
let g:ctrlp_working_path_mode = 'ra'

" 隠しファイルを表示する
let g:ctrlp_show_hidden = 1

" 無視するファイルを指定する
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'

" .gitignoreで指定されているファイルを無視する
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" ------------------------------------------------------------------------------
" clever-f.vim
" ------------------------------------------------------------------------------
" 行を跨いで検索できるようにする
 let g:clever_f_across_no_line = 0

" 小文字を入力したときのみ大文字/小文字を無視する
 let g:clever_f_smart_case = 1

" ------------------------------------------------------------------------------
" lexima.vim
" ------------------------------------------------------------------------------
function! s:as_list(a)
  return type(a:a) == type([]) ? a:a : [a:a]
endfunction

function! s:add_ignore_rule(rule)
  let rule = copy(a:rule)
  let rule.input = rule.char
  let rule.input_after = ""
  call lexima#add_rule(rule)
endfunction

function! s:add_rule(rule, ...)
  call lexima#add_rule(a:rule)
  if a:0 == 0
    return
  endif

  for ignore in s:as_list(a:1)
    call s:add_ignore_rule(extend(copy(a:rule), ignore))
  endfor
endfunction

" |) の場合は補完しない
" コメント内では補完しない
" 文字列内では補完しない
call s:add_rule({ 'char': '(', 'input_after': ')' }, [
\   { 'at': '\%#)' },
\   { 'syntax' : 'Comment' },
\   { 'syntax' : 'String' },
\])

call s:add_rule({ 'char': '[', 'input_after': ']' }, [
\   { 'at': '\%#]' },
\   { 'syntax' : 'Comment' },
\   { 'syntax' : 'String' },
\])

call s:add_rule({ 'char': '{', 'input_after': '}' }, [
\   { 'at': '\%#}' },
\   { 'syntax' : 'Comment' },
\   { 'syntax' : 'String' },
\])

" ------------------------------------------------------------------------------
" カラースキーム
" ------------------------------------------------------------------------------
" iceberg
set background=dark
colorscheme iceberg
