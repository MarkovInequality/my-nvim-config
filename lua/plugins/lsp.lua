vim.lsp.config['rust_ls'] = {
	cmd = { 'rust-analyzer' },
	filetypes = { 'rust' },
	settings = {
		check = {
			command = "clippy",
		},
	},
}

vim.lsp.config['lua_ls'] = {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	settings = {
		Lua = {
			diagnostics = {
				globals = { 'vim' },
			},
			workspace = {
				library = {vim.env.VIMRUNTIME},
			},
		},
	},
}

vim.lsp.config['python_ls'] = {
	cmd = { 'pylsp' },
	filetypes = { 'python' },
	settings = {
		pylsp = {
			plugins = {
				pycodestyle = { ignore = {'E501', 'E302', 'E262', 'E261'} },
			},
		},
	},
}

vim.lsp.enable({
	'rust_ls',
	'lua_ls',
	'python_ls',
})

--Manual Autocomplete
vim.keymap.set('i', '<S-Tab>', '<C-x><C-o>', {desc = 'Trigger Omni Completion'})

--Toggleable Inline Hints
vim.lsp.inlay_hint.enable(true)
vim.keymap.set('n', '<leader>th', function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = 'Toggle Inlay Hints' })


--Toggleable autocomplete
vim.opt.completeopt = { 'menuone', 'noinsert' }
local non_triggers = {'}', ']', ')', '{', ',', ':', ';', '\'', '\"'}
local function enable_autocomplete()
	return vim.api.nvim_create_autocmd('InsertCharPre', {
	callback = function()
		local c = vim.v.char
		-- Only trigger if the popup menu is not already visible
		if vim.fn.pumvisible() == 0 then
			if not vim.list_contains(non_triggers, c) then
				local keys = vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true)
				vim.fn.feedkeys(keys, "n")
			end
		end
	end,
	})
end

local my_autocomplete = 0
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			my_autocomplete = enable_autocomplete()
		end
	end
})
vim.keymap.set('n', '<leader>ta', function()
	if my_autocomplete == 0 then
		my_autocomplete = enable_autocomplete()
	else
		vim.api.nvim_del_autocmd(my_autocomplete)
		my_autocomplete = 0
	end
end, {desc = "[T]oggle [A]utocomplete"})


--Toggleable Warning Hover
local function enable_warn_hover()
	vim.o.updatetime = 300
	return vim.api.nvim_create_autocmd("CursorHold", {
		callback = function()
			vim.diagnostic.open_float(nil, {focusable = false})
		end,
	})
end

local my_warns = enable_warn_hover()
vim.keymap.set('n', '<leader>tw', function()
	if my_warns == 0 then
		my_warns = enable_warn_hover()
	else
		vim.api.nvim_del_autocmd(my_warns)
		my_warns = 0
	end
end, {desc = "[T]oggle [W]Warnings"})
