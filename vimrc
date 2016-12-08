call pathogen#runtime_append_all_bundles()
call pathogen#helptags()
se sw=2
"se sw=4
se ai
syntax on
se nu
se nowrap
se expandtab
filetype plugin indent on
au BufNewFile,BufRead [tT]horfile,*.thor	setf ruby
au BufNewFile,BufRead *.rabl                    setf ruby
au BufNewFile,BufRead *.hb                      setf mustache

se modeline modelines=2
