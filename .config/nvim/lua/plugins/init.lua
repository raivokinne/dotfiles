vim.pack.add({
	{ src = "https://github.com/williamboman/mason.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/williamboman/mason-lspconfig.nvim" },
	{ src = "https://github.com/b0o/SchemaStore.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
	{ src = "https://github.com/mbbill/undotree" },
	{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1") },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/tpope/vim-fugitive" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/tpope/vim-dadbod" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-ui" },
	{ src = "https://github.com/kristijanhusak/vim-dadbod-completion" },
	"https://github.com/mfussenegger/nvim-dap",
	"https://github.com/nvim-neotest/nvim-nio",
	"https://github.com/rcarriga/nvim-dap-ui",
	"https://github.com/theHamsta/nvim-dap-virtual-text",
	{
		src = "https://github.com/JavaHello/spring-boot.nvim",
		version = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0",
	},
	"https://github.com/MunifTanjim/nui.nvim",
	"https://github.com/nvim-java/nvim-java",
	"https://github.com/stevearc/oil.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",
})

require("mason").setup()
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.luasnip")
require("plugins.undotree")
require("plugins.blink")
require("plugins.trouble")
require("plugins.lsp")
require("plugins.fugitive")
require("plugins.conform")
require("plugins.dap")
require("plugins.java")
require("plugins.oil")
