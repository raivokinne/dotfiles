local lint = require("lint")

lint.linters_by_ft = {
	go = { "golangcilint" },
	php = { "phpstan" },
	javascript = { "oxlint" },
	typescript = { "oxlint" },
	javascriptreact = { "oxlint" },
	typescriptreact = { "oxlint" },
}

vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
	group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
	callback = function()
		lint.try_lint()
	end,
})
