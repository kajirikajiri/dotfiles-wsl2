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

" #####################
" ### Personal conf ###
" #####################

" TABキーを押した際にタブ文字の代わりにスペースを入れる
set expandtab
set tabstop=2
set shiftwidth=2

" 貼付け時の自動インデント禁止
:set paste

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

" vim-fzfのagでファイル名一致を除外
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, {'options': '--delimiter : --nth 4..'}, <bang>0)
