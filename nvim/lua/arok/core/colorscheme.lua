local status, _ = pcall(vim.cmd, "colorscheme kanagawa-wave")
if not status then
	print("Colorscheme not found!")
	return
end
