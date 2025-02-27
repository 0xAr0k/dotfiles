-- import mason plugin safely
local mason_status, mason = pcall(require, "mason")
if not mason_status then
	return
end

-- import mason-lspconfig plugin safely
local mason_lspconfig_status, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_status then
	return
end

-- import mason-null-ls plugin safely
local mason_null_ls_status, mason_null_ls = pcall(require, "mason-null-ls")
if not mason_null_ls_status then
	return
end

local registry = require("mason-registry")

-- enable mason
mason.setup()

mason_lspconfig.setup({
	-- list of servers for mason to install
	ensure_installed = {
		"tsserver",
		"html",
		"cssls",
		"tailwindcss",
		"lua_ls",
		"emmet_ls",
		"solidity_ls_nomicfoundation",
		"svelte",
		"rust_analyzer",
		"efm",
		"pyright",
	},
	-- auto-install configured servers (with lspconfig)
	automatic_installation = true, -- not the same as ensure_installed
})

require("lspconfig").efm.setup({
	filetypes = { "solidity" },
	settings = {
		languages = {
			solidity = {
				{ -- solidity could have more than one linter, hence this nesting.
					lintStdin = true, -- pipe buffer content to solhint
					lintIgnoreExitCode = true, -- because exit code 1 is common
					lintCommand = "solhint stdin", -- default format stylish
					lintFormats = {
						" %#%l:%c %#%tarning %#%m",
						" %#%l:%c %#%trror %#%m", -- solhint only has error and warn
					},
					lintSource = "solhint",
				},
			},
		},
	},
})

mason_null_ls.setup({
	-- list of formatters & linters for mason to install
	ensure_installed = {
		"prettier", -- ts/js formatter
		"stylua", -- lua formatter
		"eslint_d", -- ts/js linter
		"solhint", -- solidity linter
	},
	-- auto-install configured formatters & linters (with null-ls)
	automatic_installation = true,
})

for _, pkg_name in ipairs({ "solhint" }) do -- add others here
	local ok, pkg = pcall(registry.get_package, pkg_name)
	if ok then
		if not pkg:is_installed() then
			pkg:install()
		end
	end
end
