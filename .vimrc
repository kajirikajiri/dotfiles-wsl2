" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'bronson/vim-trailing-whitespace'

" Unite
"   depend on vimproc
"   ------------- VERY IMPORTANT ------------
"   you have to go to .vim/plugin/vimproc.vim and do a ./make
"   -----------------------------------------

Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'w0ng/vim-hybrid'

Plug 'terryma/vim-multiple-cursors'

" language server
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'

Plug 'vim-scripts/vim-auto-save'

call plug#end()

" -----------------
"       THEME
" -----------------

set background=dark
try
  colorscheme vim-hybrid
  catch
endtry

" ----------------------------
"       File Management
" ----------------------------
" search a file in the filetree
nnoremap <space><space> :<C-u>Files<cr>
nnoremap <space>b :<C-u>Buffers<cr>
nnoremap <space>g :<C-u>GFiles<cr>
nnoremap <space>a :<C-u>Ag<cr>
" vim-fzfのagでファイル名一致を除外
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)

" ---------------------------
"       Vim Autosave
" ---------------------------
let g:auto_save = 1
let g:auto_save_in_insert_mode = 0
let g:auto_save_silent = 1

" #####################
" ### Personal conf ###
" #####################

let mapleader=";"

" TABキーを押した際にタブ文字の代わりにスペースを入れる
set expandtab
set tabstop=2
set shiftwidth=2

" 貼付け時の自動インデント禁止
:set paste
" カレント行のインデントを維持する
:set autoindent

" swapなし
:set noswapfile

" cursorが自動で切り替わるようにする
if &term =~ '^xterm'
  " enter vim
  autocmd VimEnter * silent !echo -ne "\e[3 q"
  " oherwise
  let &t_EI .= "\<Esc>[3 q"
  " insert mode
  let &t_SI .= "\<Esc>[6 q"
  autocmd VimLeave * silent !echo -ne "\e[6 q"
endif

" <C-a>で行頭<C-e>で行末
nmap <C-e> $
nmap <C-a> 0

:hi CursorLine   cterm=NONE ctermbg=lightblue ctermfg=white guibg=darkred guifg=white
:hi CursorColumn cterm=NONE ctermbg=lightblue ctermfg=white guibg=darkred guifg=white
:nnoremap <Leader>c :nohlsearch<CR>:set cul cuc<cr>:sleep 300m<cr>:set nocul nocuc<cr>/<BS>

" 右側に行を追加して透明にする
set signcolumn=yes
highlight clear SignColumn

