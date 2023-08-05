set autoindent
set formatoptions=tcq2l
set textwidth=78 shiftwidth=2
setlocal sw=2 sts=2 et
" set foldmethod=syntax
let g:vim_json_warnings=1

" Format json using python
function! FormatJSON()
	:%!python -m json.tool
endfunction
