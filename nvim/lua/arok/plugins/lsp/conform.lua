local conform_status, conform = pcall(require, "conform")
if not conform_status then
	return
end

conform.setup({
	formatters_by_ft = {
		-- JavaScript/TypeScript
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },

		-- Web
		html = { "prettier" },
		css = { "prettier" },
		scss = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },

		-- Lua
		lua = { "stylua" },

		-- Rust
		rust = { "rustfmt" },

		-- C/C++
		c = { "clang_format" },
		cpp = { "clang_format" },

		-- Assembly
		asm = { "asmfmt" },

		-- Python
		python = { "black" }, -- or "isort", "black"

		-- Solidity
		solidity = { "forge_fmt" }, -- if you use Foundry
	},

	-- Format on save
	format_on_save = {
		timeout_ms = 500,
		lsp_fallback = true, -- Use LSP if no formatter configured
	},

	-- Customize formatters (optional)
	formatters = {
		rustfmt = {
			prepend_args = {
				"--edition=2021",
			},
		},
		clang_format = {
			prepend_args = { "-style=file" }, -- Use .clang-format file
		},
	},
})

-- Optional: Manual format keymap
vim.keymap.set({ "n", "v" }, "<leader>f", function()
	conform.format({
		lsp_fallback = true,
		async = false,
		timeout_ms = 1000,
	})
end, { desc = "Format file or range (in visual mode)" })
