local setup, neotree = pcall(require, "neo-tree")
if not setup then
	return
end

-- recommended settings from nvim-neo-tree documentation

neotree.setup({
	filesystem = {
		filtered_items = {
			visible = true, -- show dotfiles
			hide_dotfiles = false,
			hide_gitignored = true,
		},
	},
})
