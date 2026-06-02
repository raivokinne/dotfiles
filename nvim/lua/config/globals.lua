function _G.dump(value)
	vim.fn.setreg("+", vim.inspect(value))
	vim.notify("Copied to clipboard!", vim.log.levels.INFO)
end
