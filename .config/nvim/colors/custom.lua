vim.cmd("highlight clear")

if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end

vim.g.colors_name = "void"
vim.o.termguicolors = true
vim.o.background = "dark"

local c = {
	bg = "#000000",
	fg = "#F4F4F5",
	comment = "#777783",
	cyan = "#45D6FF",
	green = "#6EFF8A",
	purple = "#C792EA",
	orange = "#FFAD66",
	pink = "#FF79C6",
	yellow = "#F1FA8C",
	blue = "#82AAFF",
	red = "#FF5C70",

	gray0 = "#0a0a0b",
	gray1 = "#121215",
	gray2 = "#1b1b20",
	gray3 = "#2c2c34",
	gray4 = "#43434d",
	gray5 = "#5a5a66",
	gray6 = "#777783",
	gray7 = "#8e8e9a",
	gray8 = "#a9a9b4",
	gray9 = "#d2d2d8",

	lred = "#FF8F9D",
	lgreen = "#A3FFB6",
	lcyan = "#9BE8FF",
	lblue = "#B4CCFF",
	lpurple = "#DEBEF3",
	lpink = "#FFADDC",
}

local function hi(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

hi("Normal", { fg = c.fg, bg = c.bg })
hi("NormalNC", { fg = c.fg, bg = c.bg })
hi("NormalFloat", { fg = c.fg, bg = c.gray1 })
hi("FloatBorder", { fg = c.gray5, bg = c.gray1 })
hi("FloatTitle", { fg = c.orange, bg = c.gray1, bold = true })

hi("Cursor", { fg = c.bg, bg = c.fg })
hi("lCursor", { fg = c.bg, bg = c.fg })
hi("CursorIM", { fg = c.bg, bg = c.fg })
hi("CursorLine", { bg = c.gray1 })
hi("CursorColumn", { bg = c.gray1 })
hi("CursorLineNr", { fg = c.orange, bg = c.bg, bold = true })
hi("LineNr", { fg = c.gray5, bg = c.bg })
hi("SignColumn", { fg = c.gray5, bg = c.bg })
hi("ColorColumn", { bg = c.gray1 })

hi("Visual", { bg = c.gray3 })
hi("VisualNOS", { bg = c.gray3 })
hi("Search", { fg = c.bg, bg = c.orange })
hi("IncSearch", { fg = c.bg, bg = c.orange, bold = true })
hi("CurSearch", { fg = c.bg, bg = c.yellow, bold = true })
hi("MatchParen", { fg = c.orange, bg = c.gray3, bold = true })

hi("Pmenu", { fg = c.fg, bg = c.gray1 })
hi("PmenuSel", { fg = c.bg, bg = c.orange })
hi("PmenuSbar", { bg = c.gray1 })
hi("PmenuThumb", { bg = c.orange })
hi("WildMenu", { fg = c.bg, bg = c.orange })

hi("StatusLine", { fg = c.fg, bg = c.gray2 })
hi("StatusLineNC", { fg = c.gray6, bg = c.gray0 })
hi("WinSeparator", { fg = c.gray4 })
hi("VertSplit", { fg = c.gray4 })

hi("TabLine", { fg = c.gray6, bg = c.gray1 })
hi("TabLineSel", { fg = c.orange, bg = c.bg, bold = true })
hi("TabLineFill", { bg = c.gray1 })

hi("Folded", { fg = c.gray8, bg = c.gray2 })
hi("FoldColumn", { fg = c.gray5, bg = c.bg })
hi("NonText", { fg = c.gray4 })
hi("SpecialKey", { fg = c.gray4 })
hi("Whitespace", { fg = c.gray3 })
hi("EndOfBuffer", { fg = c.gray4 })
hi("Conceal", { fg = c.gray6 })

hi("Directory", { fg = c.blue })
hi("Title", { fg = c.orange, bold = true })
hi("Question", { fg = c.green })
hi("MoreMsg", { fg = c.green })
hi("ModeMsg", { fg = c.fg })
hi("ErrorMsg", { fg = c.red, bold = true })
hi("WarningMsg", { fg = c.yellow })
hi("MsgArea", { fg = c.fg })
hi("QuickFixLine", { bg = c.gray3, bold = true })

hi("SpellBad", { undercurl = true, sp = c.red })
hi("SpellWarn", { undercurl = true, sp = c.yellow })
hi("SpellCap", { undercurl = true, sp = c.cyan })
hi("SpellLocal", { undercurl = true, sp = c.purple })

hi("DiffAdd", { fg = c.green, bg = c.gray1 })
hi("DiffChange", { fg = c.yellow, bg = c.gray1 })
hi("DiffDelete", { fg = c.red, bg = c.gray1 })
hi("DiffText", { fg = c.blue, bg = c.gray3, bold = true })
hi("Added", { fg = c.green })
hi("Changed", { fg = c.yellow })
hi("Removed", { fg = c.red })

hi("DiagnosticError", { fg = c.red })
hi("DiagnosticWarn", { fg = c.yellow })
hi("DiagnosticInfo", { fg = c.blue })
hi("DiagnosticHint", { fg = c.cyan })
hi("DiagnosticOk", { fg = c.green })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.yellow })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.blue })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.cyan })

hi("Comment", { fg = c.comment, italic = true })
hi("String", { fg = c.green })
hi("Character", { fg = c.green })
hi("Number", { fg = c.purple })
hi("Float", { fg = c.purple })
hi("Boolean", { fg = c.purple })
hi("Constant", { fg = c.purple })

hi("Identifier", { fg = c.blue })
hi("Function", { fg = c.yellow })
hi("Keyword", { fg = c.pink })
hi("Statement", { fg = c.pink })
hi("Conditional", { fg = c.pink })
hi("Repeat", { fg = c.pink })
hi("Exception", { fg = c.pink })

hi("Operator", { fg = c.gray9 })
hi("PreProc", { fg = c.orange })
hi("Include", { fg = c.orange })
hi("Define", { fg = c.orange })
hi("Macro", { fg = c.orange })

hi("Type", { fg = c.cyan, bold = true })
hi("StorageClass", { fg = c.pink })
hi("Structure", { fg = c.cyan, bold = true })
hi("Typedef", { fg = c.cyan, bold = true })

hi("Special", { fg = c.yellow })
hi("SpecialChar", { fg = c.yellow })
hi("Tag", { fg = c.cyan })
hi("Delimiter", { fg = c.gray9 })
hi("SpecialComment", { fg = c.comment, italic = true })
hi("Debug", { fg = c.red })
hi("Underlined", { fg = c.blue, underline = true })
hi("Error", { fg = c.red, bold = true })
hi("Todo", { fg = c.yellow, bold = true })

hi("@comment", { fg = c.comment, italic = true })
hi("@string", { fg = c.green })
hi("@string.documentation", { fg = c.green })
hi("@string.escape", { fg = c.yellow })
hi("@string.special", { fg = c.cyan })
hi("@character", { fg = c.green })

hi("@number", { fg = c.purple })
hi("@float", { fg = c.purple })
hi("@boolean", { fg = c.purple })
hi("@constant", { fg = c.purple })
hi("@constant.builtin", { fg = c.purple })
hi("@constant.macro", { fg = c.orange })

hi("@variable", { fg = c.fg })
hi("@variable.builtin", { fg = c.lred })
hi("@variable.parameter", { fg = c.fg })
hi("@variable.member", { fg = c.fg })
hi("@parameter", { fg = c.fg })

hi("@function", { fg = c.yellow })
hi("@function.builtin", { fg = c.yellow })
hi("@function.call", { fg = c.yellow })
hi("@function.method", { fg = c.yellow })
hi("@function.macro", { fg = c.orange })
hi("@method", { fg = c.yellow })
hi("@method.call", { fg = c.yellow })
hi("@constructor", { fg = c.cyan })

hi("@keyword", { fg = c.pink })
hi("@keyword.function", { fg = c.pink })
hi("@keyword.operator", { fg = c.pink })
hi("@keyword.return", { fg = c.pink })
hi("@keyword.import", { fg = c.pink })
hi("@conditional", { fg = c.pink })
hi("@repeat", { fg = c.pink })
hi("@exception", { fg = c.pink })
hi("@operator", { fg = c.gray9 })

hi("@punctuation.bracket", { fg = c.gray9 })
hi("@punctuation.delimiter", { fg = c.gray9 })
hi("@punctuation.special", { fg = c.cyan })

hi("@type", { fg = c.cyan })
hi("@type.builtin", { fg = c.cyan })
hi("@type.definition", { fg = c.cyan })
hi("@namespace", { fg = c.fg })
hi("@module", { fg = c.fg })
hi("@field", { fg = c.fg })
hi("@property", { fg = c.fg })
hi("@attribute", { fg = c.orange })
hi("@tag", { fg = c.cyan })
hi("@tag.attribute", { fg = c.fg })
hi("@tag.delimiter", { fg = c.gray9 })

hi("@text", { fg = c.fg })
hi("@text.title", { fg = c.orange, bold = true })
hi("@text.emphasis", { fg = c.fg, italic = true })
hi("@text.strong", { fg = c.fg, bold = true })
hi("@text.uri", { fg = c.blue, underline = true })
hi("@text.literal", { fg = c.green })
hi("@text.reference", { fg = c.pink })
hi("@text.todo", { fg = c.yellow, bold = true })
hi("@text.warning", { fg = c.orange })
hi("@text.danger", { fg = c.red })

vim.g.terminal_color_0 = c.bg
vim.g.terminal_color_1 = c.red
vim.g.terminal_color_2 = c.green
vim.g.terminal_color_3 = c.yellow
vim.g.terminal_color_4 = c.blue
vim.g.terminal_color_5 = c.purple
vim.g.terminal_color_6 = c.cyan
vim.g.terminal_color_7 = c.fg
vim.g.terminal_color_8 = c.gray4
vim.g.terminal_color_9 = c.lred
vim.g.terminal_color_10 = c.lgreen
vim.g.terminal_color_11 = c.orange
vim.g.terminal_color_12 = c.lblue
vim.g.terminal_color_13 = c.lpink
vim.g.terminal_color_14 = c.lcyan
vim.g.terminal_color_15 = c.gray9
