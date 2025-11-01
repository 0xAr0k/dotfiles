-- Check if new API is available (Neovim 0.11+)
if not vim.lsp.config then
	vim.notify("Neovim 0.11+ required for new LSP config API", vim.log.levels.WARN)
	return
end

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- Note: typescript.nvim plugin may need updating for new API
-- For now, we'll configure ts_ls directly
-- local typescript_setup, typescript = pcall(require, "typescript")

local keymap = vim.keymap

local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }

	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)
	keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts)
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)

	-- TypeScript specific keymaps
	-- if client.name == "ts_ls" then
	-- 	if typescript_setup then
	-- 		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>")
	-- 		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>")
	-- 		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>")
	-- 	end
	-- end
end

local capabilities = cmp_nvim_lsp.default_capabilities()

-- Configure all LSP servers using new API
vim.lsp.config.html = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config.ts_ls = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config.cssls = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config.tailwindcss = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config.emmet_ls = {
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte", "javascript" },
}

vim.lsp.config.lua_ls = {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT", -- Add this
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME, -- Simplified this
					"${3rd}/luv/library",
				},
				checkThirdParty = false, -- Add this to avoid prompts
			},
			telemetry = {
				enable = false, -- Disable telemetry
			},
		},
	},
}

vim.lsp.config.solidity_ls_nomicfoundation = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config.rust_analyzer = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config.svelte = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config.pyright = {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "strict",
				autoSearchPaths = true,
				diagnosticMode = "workspace",
				useLibraryCodeForTypes = true,
			},
		},
	},
}

vim.lsp.config.clangd = {
	capabilities = capabilities,
	on_attach = on_attach,
}

vim.lsp.config.efm = {
	capabilities = capabilities,
	on_attach = on_attach,
	settings = {
		languages = {
			solidity = {
				{
					lintStdin = true,
					lintIgnoreExitCode = true,
					lintCommand = "solhint stdin",
					lintFormats = {
						" %#%l:%c %#%tarning %#%m",
						" %#%l:%c %#%trror %#%m",
					},
					lintSource = "solhint",
				},
			},
		},
	},
}

-- Enable LSP servers for appropriate filetypes
local function enable_lsp_for_filetype(filetypes, servers)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = filetypes,
		callback = function()
			for _, server in ipairs(servers) do
				vim.lsp.enable(server)
			end
		end,
	})
end

-- Enable servers based on filetypes
enable_lsp_for_filetype({ "html" }, { "html", "emmet_ls" })
enable_lsp_for_filetype({ "css", "scss", "sass", "less" }, { "cssls", "emmet_ls" })
enable_lsp_for_filetype({ "javascript", "javascriptreact", "typescript", "typescriptreact" }, { "ts_ls", "emmet_ls" })
enable_lsp_for_filetype({ "lua" }, { "lua_ls" })
enable_lsp_for_filetype({ "solidity" }, { "solidity_ls_nomicfoundation", "efm" })
enable_lsp_for_filetype({ "rust" }, { "rust_analyzer" })
enable_lsp_for_filetype({ "svelte" }, { "svelte", "emmet_ls" })
enable_lsp_for_filetype({ "python" }, { "pyright" })
enable_lsp_for_filetype({ "c", "cpp" }, { "clangd" })
enable_lsp_for_filetype({ "tailwindcss" }, { "tailwindcss" })
