return {
	{
		-- CoC (Conqueror of Completion) Configuration
		"neoclide/coc.nvim",
		branch = "release",
		config = function()
			-- CoCの基本設定
			vim.cmd([[
        " Use <Tab> and <S-Tab> to navigate through popup menu
        inoremap <silent><expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
        inoremap <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

        " Make <CR> accept selected completion item or notify coc.nvim to format
        " <C-g>u breaks current undo, please make your own choice
        inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm()
              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

        " Use `[g` and `]g` to navigate diagnostics
        nmap <silent> [g <Plug>(coc-diagnostic-prev)
        nmap <silent> ]g <Plug>(coc-diagnostic-next)

        " GoTo code navigation
        nmap <silent> gd <Plug>(coc-definition)
        nmap <silent> gy <Plug>(coc-type-definition)
        nmap <silent> gi <Plug>(coc-implementation)
        nmap <silent> gr <Plug>(coc-references)
      ]])

			-- Auto install extensions
			vim.cmd([[
        augroup mygroup
          autocmd!
          autocmd FileType python,javascript,typescript,json call coc#add_extension('coc-pyright', 'coc-tsserver', 'coc-json')
        augroup END
      ]])
		end,
	},
}
