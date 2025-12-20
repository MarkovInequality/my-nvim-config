local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin"},
	{ "mason-org/mason.nvim" },
	{ "anuvyklack/keymap-amend.nvim" },
	{ "windwp/nvim-autopairs", event = "InsertEnter", config = true },
	{ "huggingface/llm.nvim",
		opts = {
			model = "Qwen3",
			backend = "openai",
			url = "http://localhost:5001",
			debounce_ms = 1000,
			accept_keymap = "<Tab>",
			dismiss_keymap = "<S-Tab>",
			fim = {
				enabled = true,
				prefix = "<|fim_prefix|>",
				middle = "<|fim_middle|>",
				suffix = "<|fim_suffix|>",
			},
			request_body = {
				max_tokens = 20,
			},
			enable_suggestions_on_startup = true,
		},
	},
})

vim.cmd.colorscheme "catppuccin-mocha"
require("mason").setup()

--Map Start AI Autocomplete
vim.keymap.set('n', '<C-Space>', function()
	vim.cmd('LLMSuggestion')
end, { desc = 'Trigger AI Autocomplete' })
