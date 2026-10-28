local parsers = {
	"lua",
	"vim",
	"vimdoc",
	"query",
	"javascript",
	"typescript",
	"tsx",
	"html",
	"css",
	"json",
	"gitignore",
	"go",
}

local group = vim.api.nvim_create_augroup("RaivoTreesitter", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
	group = group,
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end

		pcall(vim.treesitter.start, 0)
	end,
})

vim.api.nvim_create_autocmd("User", {
	group = group,
	pattern = "VeryLazy",
	once = true,
	callback = function()
		require("nvim-treesitter").install(parsers)
	end,
})
