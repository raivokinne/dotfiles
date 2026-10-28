vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
	pattern = "*",
	desc = "highlight selection on yank",
	callback = function()
		vim.highlight.on_yank({ timeout = 200, visual = true })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	command = "wincmd L",
})

vim.api.nvim_create_autocmd("VimResized", {
	command = "wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("no_auto_comment", {}),
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

vim.api.nvim_create_autocmd("BufRead", {
	group = vim.api.nvim_create_augroup("dotenv_ft", { clear = true }),
	pattern = { ".env", ".env.*" },
	callback = function()
		vim.bo.filetype = "dosini"
	end,
})

vim.api.nvim_create_user_command("PackClean", function()
	local inactive = vim.iter(vim.pack.get())
		:filter(function(x)
			return not x.active
		end)
		:map(function(x)
			return x.spec.name
		end)
		:totable()
	if #inactive == 0 then
		vim.notify("No inactive plugins to remove", vim.log.levels.INFO)
		return
	end
	vim.pack.del(inactive)
	vim.notify("Removed: " .. table.concat(inactive, ", "), vim.log.levels.INFO)
end, { desc = "Remove plugins not in vim.pack.add() specs" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "netrw",
	callback = function()
		local opts = { buffer = true, silent = true }
		vim.keymap.set("n", "%", function()
			local dir = vim.b.netrw_curdir or vim.fn.expand("%:p:h")
			vim.ui.input({ prompt = "Enter filename: " }, function(input)
				if input and input ~= "" then
					local filepath = dir .. "/" .. input
					vim.cmd("!touch " .. vim.fn.shellescape(filepath))
					vim.cmd.edit()
				end
			end)
		end, opts)
	end,
})

local function update_plugin(plugin_name)
	if plugin_name == "" then
		print("Updating all plugins...")
		local plugins = vim.pack.get()
		if vim.tbl_isempty(plugins) then
			print("No plugins installed to update")
			return
		end
		print("Found " .. #plugins .. " plugins to update:")
		for i, plugin in ipairs(plugins) do
			local name = plugin.spec.name or "Unknown Plugin " .. i
			print("- " .. name)
		end
		local choice = vim.fn.confirm("Update all plugins?", "&Yes\n&No", 2)
		if choice ~= 1 then
			print("Cancelled")
			return
		end
		vim.pack.update()
		print("All plugins updated successfully!")
	else
		local plugins = vim.pack.get()
		local found = false
		for _, plugin in ipairs(plugins) do
			local name = plugin.spec.name or ""
			local url = plugin.spec.src or ""
			if name == plugin_name or url:match(plugin_name) then
				found = true
				break
			end
		end
		if not found then
			print("Plugin not found: " .. plugin_name)
			print("Use :PackList to see installed plugins")
			return
		end
		local choice = vim.fn.confirm("Update plugin '" .. plugin_name .. "'?", "&Yes\n&No", 2)
		if choice ~= 1 then
			print("Cancelled")
			return
		end
		vim.pack.update({ names = { plugin_name } })
		print("Updated plugin: " .. plugin_name)
	end
end

vim.api.nvim_create_user_command("PackUpdate", function(opts)
	update_plugin(opts.args)
end, {
	nargs = "?",
	desc = "Update plugin(s). No args = update all, or specify plugin name",
})
