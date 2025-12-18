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
				globals = { "vim" },
			},
			workspace = {
				library = {vim.env.VIMRUNTIME},
			},
		},
	},
}

vim.lsp.enable({
	'rust_ls',
	'lua_ls',
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
local function enable_autocomplete()
	return vim.api.nvim_create_autocmd("InsertCharPre", {
	  callback = function()
		-- Only trigger if the popup menu is not already visible
		if vim.fn.pumvisible() == 0 then
		  local keys = vim.api.nvim_replace_termcodes("<C-x><C-o>", true, false, true)
		  vim.fn.feedkeys(keys, "n")
		end
	  end,
	})
end

local my_autocomplete = enable_autocomplete()

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
			vim.diagnostic.open_float(nil, {focasable = false})
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
