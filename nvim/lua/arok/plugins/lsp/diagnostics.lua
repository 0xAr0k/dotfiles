-- Configure diagnostic display
vim.diagnostic.config({
	virtual_text = true, -- Show inline error messages
	signs = true, -- Show signs in gutter (left side)
	underline = true, -- Underline errors
	update_in_insert = false, -- Don't update while typing
	severity_sort = true, -- Sort by severity
	float = {
		border = "rounded",
		source = "always",
		header = "",
		prefix = "",
	},
})

-- Define diagnostic signs (the icons in the gutter)
local signs = {
	Error = "󰅚 ",
	Warn = "󰀪 ",
	Hint = "󰌶 ",
	Info = " ",
}

for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
