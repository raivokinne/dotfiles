local dap = require("dap")
local dapui = require("dapui")

dapui.setup()
require("nvim-dap-virtual-text").setup()

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

local map = vim.keymap.set
map("n", "<leader>dc", dap.continue, { desc = "DAP continue / start" })
map("n", "<leader>dq", dap.terminate, { desc = "DAP terminate" })
map("n", "<leader>dl", dap.run_last, { desc = "DAP run last" })

map("n", "<leader>do", dap.step_over, { desc = "DAP step over" })
map("n", "<leader>di", dap.step_into, { desc = "DAP step into" })
map("n", "<leader>dO", dap.step_out, { desc = "DAP step out" })

map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
map("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Condition: "))
end, { desc = "Conditional breakpoint" })
map("n", "<leader>dx", dap.clear_breakpoints, { desc = "Clear all breakpoints" })

map("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
map("n", "<leader>dr", dap.repl.open, { desc = "DAP REPL" })
map({ "n", "v" }, "<leader>de", function()
	dapui.eval()
end, { desc = "Eval expression" })

dap.adapters.php = {
	type = "executable",
	command = "node",
	args = {
		vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
	},
}

dap.configurations.php = {
	{
		name = "Listen for Xdebug",
		type = "php",
		request = "launch",
		port = 9003,
		-- pathMappings = { ["/var/www/html"] = "${workspaceFolder}" },
	},
	{
		name = "Debug current script",
		type = "php",
		request = "launch",
		program = "${file}",
		cwd = "${fileDirname}",
		port = 9003,
		runtimeExecutable = "php",
	},
}

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticOk" })
