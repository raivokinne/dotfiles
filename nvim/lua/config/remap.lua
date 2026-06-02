vim.g.mapleader = " "
local map = vim.keymap.set
map("n", "-", vim.cmd.Ex)

map("v", "J", ":m '>+1<CR>gv=gv")
map("v", "K", ":m '<-2<CR>gv=gv")

vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
map('n', "<C-q>", ":copen<CR>", { silent = true })
map({ "n" }, "<leader>c", "1z=")
map({ "n" }, "<leader>op", "<Cmd>Open .<CR>", { desc = "Open current directory in Finder." })

map(
	"n",
	"<leader>ee",
	"oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
)

map(
	"n",
	"<leader>ef",
	"oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj"
)

map('n', '<Esc>', '<cmd>nohlsearch<CR>')

map("n", "j", "gj")
map("n", "k", "gk")

map("n", "J", "mzJ`z")
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "n", "nzzzv")
map("n", "N", "Nzzzv")
map("n", "=ap", "ma=ap'a")

map("n", "tt", ":tabnew<CR>")
map("n", "<S-h>", ":tabnext<CR>")
map("n", "<S-l>", ":tabprev<CR>")
map("n", "tc", ":tabclose<CR>")

map("x", "<leader>p", [["_dP]])

map({ "n", "v", "x" }, "<C-s>", [[:s/\V]], { desc = "Enter substitue mode in selection" })

map({ "n", "v" }, "<leader>y", [["+y]])
map("n", "<leader>Y", [["+Y]])

map({ "n", "v" }, "<leader>d", '"_d')

map("i", "<C-c>", "<Esc>")

map("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

map("n", "<C-k>", "<cmd>cnext<CR>zz")
map("n", "<C-j>", "<cmd>cprev<CR>zz")
map("n", "<leader>k", "<cmd>lnext<CR>zz")
map("n", "<leader>j", "<cmd>lprev<CR>zz")

local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end

map("n", "<leader>pcc", pack_clean)

-- for i = 1, 8 do
-- 	map({ "n", "t" }, "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
-- end


map('n', '<leader>xx', '<Cmd>source %<CR>', { desc = 'Source current file' })
map('n', '<leader>x', '<Cmd>:.lua<CR>', { desc = 'Lua: execute current line' })
map('v', '<leader>x', '<Cmd>:lua<CR>', { desc = 'Lua: execute current selection' })

map('n', '<leader>bb', '<C-^>', { desc = 'Switch to alternate buffer' })
map('n', '<leader>bn', ':bnext<cr>', { desc = 'Next buffer' })
map('n', '<leader>bp', ':bprevious<cr>', { desc = 'Previous buffer' })
