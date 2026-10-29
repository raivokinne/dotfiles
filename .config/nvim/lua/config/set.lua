local opt = vim.opt

opt.nu = true
opt.relativenumber = true
opt.guicursor = ""
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.inccommand = "split"
opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")
opt.updatetime = 50
opt.shortmess:append("c")
opt.winborder = "rounded"
opt.termguicolors = true
opt.colorcolumn = "100"
