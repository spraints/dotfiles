call plug#begin()
Plug 'neovim/nvim-lspconfig'
call plug#end()

lua <<END
-- https://github.com/neovim/nvim-lspconfig
require'lspconfig'.dockerls.setup{}
require'lspconfig'.gopls.setup{}
require'lspconfig'.pyright.setup{}
-- Need to npm install -g typescript typescript-language-server
require'lspconfig'.tsserver.setup{}

-- todo: figure out formatting.
END

se sw=2
"se sw=4
se ai
se nu
se nowrap
se expandtab
"au is short for autocmd
"au BufNewFile,BufRead [tT]horfile,*.thor	setf ruby
"au BufNewFile,BufRead *.rabl                    setf ruby
"au BufNewFile,BufRead *.hb                      setf mustache

se modeline modelines=2

noremap <silent> <Leader>w :call ToggleWrap()<CR>
function ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    setlocal nowrap
    set virtualedit=all
    silent! nunmap <buffer> <Up>
    silent! nunmap <buffer> <Down>
    silent! nunmap <buffer> <Home>
    silent! nunmap <buffer> <End>
    silent! iunmap <buffer> <Up>
    silent! iunmap <buffer> <Down>
    silent! iunmap <buffer> <Home>
    silent! iunmap <buffer> <End>
  else
    echo "Wrap ON"
    setlocal wrap linebreak nolist
    set virtualedit=
    setlocal display+=lastline
    noremap  <buffer> <silent> <Up>   gk
    noremap  <buffer> <silent> <Down> gj
    noremap  <buffer> <silent> <Home> g<Home>
    noremap  <buffer> <silent> <End>  g<End>
    inoremap <buffer> <silent> <Up>   <C-o>gk
    inoremap <buffer> <silent> <Down> <C-o>gj
    inoremap <buffer> <silent> <Home> <C-o>g<Home>
    inoremap <buffer> <silent> <End>  <C-o>g<End>
  endif
endfunction
