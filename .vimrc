" 禁用 vi 兼容模式
set nocompatible

" 显示光标位置
set cursorline
set cursorcolumn

" 设置 Backspace 键模式
set bs=eol,start,indent

" 允许隐藏未保存的缓冲区
set hidden

" 功能键超时检测 50 毫秒
set ttimeoutlen=50

"----------------------------------------------------------------------
" 设置\t展开为空格
set noexpandtab
set shiftwidth=8
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" 有 tmux 和没有的功能键超时（毫秒）
if $TMUX != ''
	set ttimeoutlen=30
elseif &ttimeoutlen > 80 || &ttimeoutlen <= 0
	set ttimeoutlen=80
endif
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" 终端下允许 ALT，详见：http://www.skywind.me/blog/archives/2021
" 记得设置 ttimeout 和 ttimeoutlen （上面）
if has('nvim') == 0 && has('gui_running') == 0
	function! s:metacode(key)
		exec "set <M-".a:key.">=\e".a:key
	endfunc
	for i in range(10)
		call s:metacode(nr2char(char2nr('0') + i))
	endfor
	for i in range(26)
		call s:metacode(nr2char(char2nr('a') + i))
		call s:metacode(nr2char(char2nr('A') + i))
	endfor
	for c in [',', '.', '/', ';', '{', '}']
		call s:metacode(c)
	endfor
	for c in ['?', ':', '-', '_', '+', '=', "'"]
		call s:metacode(c)
	endfor
endif
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" BEGIN:搜索设置
" 搜索时忽略大小写
set ignorecase

" 智能搜索大小写判断，默认忽略大小写，除非搜索内容包含大写字母
set smartcase

" 高亮搜索内容
set hlsearch

" 查找输入时动态增量显示查找结果
set incsearch

" 使得 * 和 # 在可视模式下以选中区域为模式进行搜索，而不是光标所在单词.
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

xnoremap * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>

" END:搜索设置
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" BEGIN:语法高亮设置
syntax enable
syntax on
" END:语法高亮设置
"----------------------------------------------------------------------

" 显示匹配的括号
set showmatch

" 显示括号匹配的时间
set matchtime=2

" 显示最后一行
set display=lastline

" 允许下方显示目录
set wildmenu

" 延迟绘制（提升性能）
set lazyredraw

" 错误格式
set errorformat+=[%f:%l]\ ->\ %m,[%f:%l]:%m

" 设置分隔符可视
set listchars=tab:\|\ ,trail:.,extends:>,precedes:<
" 设置显示制表符等隐藏字符
set list

"----------------------------------------------------------------------
" BEGIN:新建文件插入文件头
func SetCLikeHeader()
	call setline(1, "/*************************************************************************")
	call append(line("."), "    > File Name: ".expand("%"))
	call append(line(".")+1, "    > Author: Qinglin Pan")
	call append(line(".")+2, "    > Mail: panqinglin00@163.com ")
	call append(line(".")+3, "    > Created Time: ".strftime("%c"))
	call append(line(".")+4, " ************************************************************************/")
	call append(line(".")+5, "")
	autocmd BufNewFile * normal G
endfunc

autocmd BufNewFile *.cpp,*.[ch] exec ":call SetCLikeHeader()"
" END:新建文件插入文件头
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" BEGIN:显示设置

" 总是显示状态栏
set laststatus=2

" 总是显示行号
set number

" 总是显示侧边栏（用于显示 mark/gitdiff/诊断信息）
set signcolumn=yes

" 总是显示标签栏
set showtabline=2

" 右下角显示命令
set showcmd

" 插入模式在状态栏下面显示 -- INSERT --，
set showmode

" 水平切割窗口时，默认在右边显示新窗口
set splitright
" END:显示设置
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" BEGIN: 插件安装
" 在 ~/.vim/bundles 下安装插件
call plug#begin(get(g:, 'bundle_home', '~/.vim/bundles'))

" 颜色主题安装
Plug 'flazz/vim-colorschemes'
Plug 'lifepillar/vim-gruvbox8'

" 文本对齐，使用命令 Tabularize
" 最常见情景是用于获得对齐的注释，命令为:Tabularize
" 冒号对齐 : Tabularize /:
" 逗号对齐 : Tabularize /,
" //对齐   : Tabularize /\/\/
Plug 'godlygeek/tabular', { 'on': 'Tabularize' }

" 用于在侧边符号栏显示 marks （ma-mz 记录的位置）
Plug 'kshenoy/vim-signature'

" 用于在侧边符号栏显示 git/svn 的 diff
Plug 'mhinz/vim-signify'

" 会在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转
Plug 't9md/vim-choosewin'

" 配置airline插件
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

"配置NERDTREE插件
Plug 'scrooloose/nerdtree', {'on': ['NERDTree', 'NERDTreeFocus', 'NERDTreeToggle', 'NERDTreeCWD', 'NERDTreeFind'] }
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

"lsp插件
Plug 'autozimu/LanguageClient-neovim', {
		\ 'branch': 'next',
	\ 'do': 'bash install.sh',
	\ }

"对选中部分进行注释/取消注释。Leader-cc/Leader-cu
Plug 'preservim/nerdcommenter'
"基于popup的ui插件，主要用于快速预览
Plug 'skywind3000/vim-quickui'
"用于快速移动的插件
Plug 'easymotion/vim-easymotion'
call plug#end()
" END: 插件安装
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" BEGIN:颜色主题：色彩文件位于 colors 目录中
" 允许真彩色
"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
" gruvbox颜色主题设置
let g:gruvbox_transparent_bg=1
let g:gruvbox_termcolors=256
let g:gruvbox_contrast_dark='hard'
let g:gruvbox_italicize_strings=1
let g:gruvbox_invert_signs=1
let g:gruvbox_improved_strings=1
autocmd vimenter * ++nested colorscheme gruvbox8
" 设置背景色与终端颜色一致（为了透明终端下使用透明背景）
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE " transparent bg
" 设置特殊字符的显示背景色与终端一致（为了透明终端下使用透明背景）
autocmd vimenter * hi SpecialKey cterm=NONE ctermfg=darkgray ctermbg=NONE

" END:颜色主题：色彩文件位于 colors 目录中
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" BEGIN:状态栏设置
set statusline=                                 " 清空状态了
set statusline+=\ %F                            " 文件名
set statusline+=\ [%1*%M%*%n%R%H]               " buffer 编号和状态
set statusline+=%=                              " 向右对齐
set statusline+=\ %y                            " 文件类型
" 最右边显示文件编码和行号等信息，并且固定在一个 group 中，优先占位
set statusline+=\ %0(%{&fileformat}\ [%{(&fenc==\"\"?&enc:&fenc).(&bomb?\",BOM\":\"\")}]\ %v:%l/%L%)
" 配置airline插件
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_powerline_fonts = 0
let g:airline_exclude_preview = 1
let g:airline_section_b = '%n'
let g:airline_theme='gruvbox8'
let g:airline#extensions#branch#enabled = 0
let g:airline#extensions#syntastic#enabled = 0
let g:airline#extensions#fugitiveline#enabled = 0
let g:airline#extensions#csv#enabled = 0
let g:airline#extensions#vimagit#enabled = 0
" END:状态栏设置
"----------------------------------------------------------------------

" 设置vim-choosewin使用 ALT+E 来选择窗口
nmap <m-e> <Plug>(choosewin)

"----------------------------------------------------------------------
"BEGIN:配置NERDTREE插件
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeHijackNetrw = 0
let NERDTreeIgnore=['\.o$', '\.a$', '\.O$'] " ignore files in nerdtree
let NERDTreeShowLineNumbers=1 " enable line number
autocmd FileType nerdtree setlocal number " use line number in nerdtree
noremap <space>nn :NERDTree<cr>
noremap <space>no :NERDTreeFocus<cr>
noremap <space>nm :NERDTreeMirror<cr>
noremap <space>nt :NERDTreeToggle<cr>
"END:配置NERDTREE插件
"----------------------------------------------------------------------


"----------------------------------------------------------------------
"BEGIN: lsp插件
let g:LanguageClient_loadSettings = 1
let g:LanguageClient_diagnosticsEnable = 0
let g:LanguageClient_selectionUI = 'quickfix'
let g:LanguageClient_diagnosticsList = v:null
let g:LanguageClient_hoverPreview = 'Never'

let g:LanguageClient_serverCommands = {}
let g:LanguageClient_serverCommands.c = ['clangd']
let g:LanguageClient_serverCommands.cpp = ['clangd']
let g:LanguageClient_serverCommands.rust = ['rust-analyzer']

noremap <leader>rd :call LanguageClient#textDocument_definition()<cr>
noremap <leader>rr :call LanguageClient#textDocument_references()<cr>
noremap <leader>rv :call LanguageClient#textDocument_hover()<cr>
"END: lsp插件
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" BEGIN:quickui插件设置
"quickui颜色主题
let g:quickui_color_scheme = 'gruvbox'
let g:quickui_border_style = 2
"设置quickfix预览
let g:quickui_preview_w = 90
let g:quickui_preview_h = 40
augroup MyQuickfixPreview
  au!
  au FileType qf noremap <silent><buffer> p :call quickui#tools#preview_quickfix()<cr>
  au FileType qf noremap <silent><buffer> f :call quickui#preview#scroll(20)<cr>
  au FileType qf noremap <silent><buffer> b :call quickui#preview#scroll(-20)<cr>
augroup END
"使用leader-be来进行buffer切换(到当前窗口），leader-bt新开一个tab来显示
noremap <leader>be :call quickui#tools#list_buffer('e')<cr>
noremap <leader>bt :call quickui#tools#list_buffer('tabedit')<cr>
" END:quickui插件设置
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" BEGIN:vim-easymotion插件设置
map <space>l <Plug>(easymotion-lineforward)
map <space>j <Plug>(easymotion-j)
map <space>k <Plug>(easymotion-k)
map <space>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor column when JK motion
" END:vim-easymotion插件设置
"----------------------------------------------------------------------

"----------------------------------------------------------------------
" BEGIN:自定义的键位绑定
" 窗口切换：ALT+SHIFT+hjkl
" 传统的 CTRL+hjkl 移动窗口不适用于 vim 8.1 的终端模式，CTRL+hjkl 在
" bash/zsh 及带文本界面的程序中都是重要键位需要保留，不能 tnoremap 的
noremap <m-H> <c-w>h
noremap <m-L> <c-w>l
noremap <m-J> <c-w>j
noremap <m-K> <c-w>k
inoremap <m-H> <esc><c-w>h
inoremap <m-L> <esc><c-w>l
inoremap <m-J> <esc><c-w>j
inoremap <m-K> <esc><c-w>k

" ALT+N 切换 tab
noremap <silent><m-1> :tabn 1<cr>
noremap <silent><m-2> :tabn 2<cr>
noremap <silent><m-3> :tabn 3<cr>
noremap <silent><m-4> :tabn 4<cr>
noremap <silent><m-5> :tabn 5<cr>
noremap <silent><m-6> :tabn 6<cr>
noremap <silent><m-7> :tabn 7<cr>
noremap <silent><m-8> :tabn 8<cr>
noremap <silent><m-9> :tabn 9<cr>
noremap <silent><m-0> :tabn 10<cr>
inoremap <silent><m-1> <ESC>:tabn 1<cr>
inoremap <silent><m-2> <ESC>:tabn 2<cr>
inoremap <silent><m-3> <ESC>:tabn 3<cr>
inoremap <silent><m-4> <ESC>:tabn 4<cr>
inoremap <silent><m-5> <ESC>:tabn 5<cr>
inoremap <silent><m-6> <ESC>:tabn 6<cr>
inoremap <silent><m-7> <ESC>:tabn 7<cr>
inoremap <silent><m-8> <ESC>:tabn 8<cr>
inoremap <silent><m-9> <ESC>:tabn 9<cr>
inoremap <silent><m-0> <ESC>:tabn 10<cr>
" ALT+SHIFT+n/p 切换 tab (如果插入模式则退出到普通模式之后切换）
noremap <m-N> :tabn<cr>
noremap <m-P> :tabp<cr>
inoremap <silent><m-N> <ESC>:tabn<cr>
inoremap <silent><m-P> <ESC>:tabp<cr>

" END:自定义的键位绑定
"----------------------------------------------------------------------
