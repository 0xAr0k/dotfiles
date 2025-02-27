local setup, fterm = pcall(require, "FTerm")
if not setup then
	return
end

local btop = fterm:new({
	ft = "fterm_btop",
	cmd = "btop",
})

fterm.setup({
	dimensions = {
		height = 0.9,
		width = 0.9,
	},
})

vim.api.nvim_create_user_command("FTermToggle", require("FTerm").toggle, { bang = true })
vim.keymap.set("n", "<leader>b", function()
	btop:toggle()
end)
