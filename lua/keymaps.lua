vim.cmd([[
nnoremap <Space> <NOP>
let mapleader="\<Space>"
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
nnoremap <silent> <leader>J :resize -2<CR>
nnoremap <silent> <leader>K :resize +2<CR>
nnoremap <silent> <leader>H :vertical resize +2<CR>
nnoremap <silent> <leader>L :vertical resize -2<CR>
nnoremap <silent> <leader>jj <C-W>j
nnoremap <silent> <leader>kk <C-W>k
nnoremap <silent> <leader>hh  <C-W>h
nnoremap <silent> <leader>ll <C-W>l
nnoremap <silent> <leader>gh <cmd>lua require'lspsaga.provider'.lsp_finder()<CR>
nnoremap <silent> <leader>ca <cmd>lua require('lspsaga.codeaction').code_action()<CR>
vnoremap <silent> <leader>ca :<C-U>lua require('lspsaga.codeaction').range_code_action()<CR>
nnoremap <silent> K <cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
nnoremap <silent> <C-j> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
nnoremap <silent> <C-k> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
nnoremap <silent> <leader>gs <cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>
nnoremap <silent> <leader>gr <cmd>lua require('lspsaga.rename').rename()<CR>
nnoremap <silent> <leader>gd <cmd>lua require'lspsaga.provider'.preview_definition()<CR>
nnoremap <silent> <leader>cd <cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<CR>
nnoremap <silent> <leader>cc <cmd>lua require'lspsaga.diagnostic'.show_cursor_diagnostics()<CR>
nnoremap <silent> <leader>n <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<CR>
nnoremap <silent> <leader>; <cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<CR>
nnoremap <silent> <leader>ft <cmd>lua require('lspsaga.floaterm').open_float_terminal()<CR> 
tnoremap <silent> <leader>ft <C-\><C-n>:lua require('lspsaga.floaterm').close_float_terminal()<CR>
]])
