local setup, devcontainer = pcall(require, "devcontainer")
if not setup then
	return
end

devcontainer.setup({})
