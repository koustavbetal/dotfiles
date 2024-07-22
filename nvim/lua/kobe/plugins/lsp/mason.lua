return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")
		-- enable mason and configure icons
		mason.setup({
			PATH = "append",
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},

			providers = {
				"mason.providers.client",
				"mason.providers.registry-api",
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"arduino_language_server", --Arduino
				"html", --HTML
				"bashls", -- Bash
				"clangd", -- C/C++
				--"neocmake",
				"lua_ls", --lua
				"cssls", -- CSS
				"dockerls", --Docker
				"jdtls", -- Java
				"texlab", -- LaTeX
				"markdown_oxide",
				"matlab_ls", -- Matlab
				"pyright", -- Python
				"lemminx", -- XML
				"yamlls", -- YAML
			},
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"prettier", -- prettier formatter
				"stylua", -- lua formatter
				"ast-grep", -- python formatter
				"blackd-client", -- python formatter
			},
		})
	end,
}
