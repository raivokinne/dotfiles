vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
	vim.cmd("syntax reset")
end
vim.g.colors_name = "alabaster-refined"
vim.o.termguicolors = true
vim.o.background = "dark"

local c = {
	bg = "#000000",
	bg_subtle = "#252526",
	bg_sel = "#264F78",
	bg_paren = "#2D2D30",
	border = "#3C3C3C",

	base = "#D4D4D4",
	muted = "#777777",
	very_muted = "#4A4A4A",

	green = "#6A9955",
	teal = "#4EC9B0",
	orange = "#CE9178",
	purple = "#C586C0",
	comment = "#6A7040",

	red = "#F44747",
	yellow = "#DCDCAA",
	cursor = "#AEAFAD",
	none = "NONE",
}

local function hi(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

hi("Normal", { fg = c.base, bg = c.bg })
hi("NormalFloat", { fg = c.base, bg = c.bg_subtle })
hi("FloatBorder", { fg = c.border, bg = c.bg_subtle })
hi("Cursor", { fg = c.bg, bg = c.cursor })
hi("CursorLine", { bg = c.bg_subtle })
hi("CursorColumn", { bg = c.bg_subtle })
hi("CursorLineNr", { fg = c.muted, bg = c.bg })
hi("LineNr", { fg = c.very_muted, bg = c.bg })
hi("SignColumn", { fg = c.very_muted, bg = c.bg })
hi("ColorColumn", { bg = c.bg_subtle })
hi("Visual", { bg = c.bg_sel })
hi("VisualNOS", { bg = c.bg_sel })
hi("Search", { fg = c.base, bg = c.bg_sel, bold = true })
hi("IncSearch", { fg = c.base, bg = c.bg_sel, bold = true })
hi("CurSearch", { fg = c.bg, bg = c.teal, bold = true })
hi("MatchParen", { bg = c.bg_paren, bold = true })
hi("Pmenu", { fg = c.base, bg = c.bg_subtle })
hi("PmenuSel", { fg = c.base, bg = c.bg_sel })
hi("PmenuSbar", { bg = c.bg_subtle })
hi("PmenuThumb", { bg = c.muted })
hi("StatusLine", { fg = c.base, bg = c.bg_subtle })
hi("StatusLineNC", { fg = c.muted, bg = c.bg })
hi("WinSeparator", { fg = c.border })
hi("TabLine", { fg = c.muted, bg = c.bg_subtle })
hi("TabLineSel", { fg = c.teal, bg = c.bg, bold = true })
hi("TabLineFill", { bg = c.bg_subtle })
hi("Folded", { fg = c.muted, bg = c.bg_subtle })
hi("FoldColumn", { fg = c.very_muted, bg = c.bg })
hi("NonText", { fg = c.very_muted })
hi("SpecialKey", { fg = c.very_muted })
hi("Whitespace", { fg = c.very_muted })
hi("EndOfBuffer", { fg = c.very_muted })
hi("WildMenu", { fg = c.base, bg = c.bg_sel })
hi("Directory", { fg = c.teal })
hi("Title", { fg = c.teal, bold = true })
hi("Question", { fg = c.green })
hi("MoreMsg", { fg = c.green })
hi("ModeMsg", { fg = c.base })
hi("ErrorMsg", { fg = c.red })
hi("WarningMsg", { fg = c.orange })
hi("SpellBad", { undercurl = true, sp = c.red })
hi("SpellWarn", { undercurl = true, sp = c.orange })
hi("SpellCap", { undercurl = true, sp = c.teal })
hi("SpellLocal", { undercurl = true, sp = c.purple })

hi("Comment", { fg = c.comment, italic = true })
hi("String", { fg = c.green })
hi("Character", { fg = c.green })
hi("Number", { fg = c.green })
hi("Float", { fg = c.green })
hi("Boolean", { fg = c.purple })
hi("Constant", { fg = c.purple })
hi("Identifier", { fg = c.base })
hi("Function", { fg = c.teal, bold = true })
hi("Keyword", { fg = c.base })
hi("Statement", { fg = c.base })
hi("Conditional", { fg = c.orange }) -- if / else / elif / switch
hi("Repeat", { fg = c.orange }) -- for / while / loop
hi("Exception", { fg = c.orange }) -- try / catch / raise
hi("Operator", { fg = c.muted })
hi("PreProc", { fg = c.purple })
hi("Include", { fg = c.purple })
hi("Define", { fg = c.purple })
hi("Macro", { fg = c.purple })
hi("Type", { fg = c.teal })
hi("StorageClass", { fg = c.base })
hi("Structure", { fg = c.teal })
hi("Typedef", { fg = c.teal })
hi("Special", { fg = c.orange })
hi("SpecialChar", { fg = c.orange })
hi("Tag", { fg = c.teal })
hi("Delimiter", { fg = c.muted })
hi("SpecialComment", { fg = c.comment })
hi("Debug", { fg = c.red })
hi("Underlined", { underline = true })
hi("Error", { fg = c.red })
hi("Todo", { fg = c.orange, bold = true })

hi("@comment", { fg = c.comment, italic = true })
hi("@string", { fg = c.green })
hi("@string.escape", { fg = c.orange })
hi("@number", { fg = c.green })
hi("@float", { fg = c.green })
hi("@boolean", { fg = c.purple })
hi("@constant", { fg = c.purple })
hi("@constant.builtin", { fg = c.purple })
hi("@constant.macro", { fg = c.purple })
hi("@variable", { fg = c.base })
hi("@variable.builtin", { fg = c.orange }) -- self, this, super
hi("@function", { fg = c.teal, bold = true })
hi("@function.builtin", { fg = c.base })
hi("@function.call", { fg = c.base })
hi("@function.macro", { fg = c.purple })
hi("@method", { fg = c.teal, bold = true })
hi("@method.call", { fg = c.base })
hi("@constructor", { fg = c.teal })
hi("@parameter", { fg = c.base })
hi("@keyword", { fg = c.base })
hi("@keyword.function", { fg = c.base })
hi("@keyword.operator", { fg = c.muted })
hi("@keyword.return", { fg = c.orange })
hi("@keyword.import", { fg = c.base })
hi("@conditional", { fg = c.orange })
hi("@repeat", { fg = c.orange })
hi("@exception", { fg = c.orange })
hi("@operator", { fg = c.muted })
hi("@punctuation.bracket", { fg = c.muted })
hi("@punctuation.delimiter", { fg = c.muted })
hi("@punctuation.special", { fg = c.muted })
hi("@type", { fg = c.teal })
hi("@type.builtin", { fg = c.teal })
hi("@namespace", { fg = c.base })
hi("@field", { fg = c.base })
hi("@property", { fg = c.base })
hi("@attribute", { fg = c.purple })
hi("@tag", { fg = c.teal })
hi("@tag.attribute", { fg = c.base })
hi("@tag.delimiter", { fg = c.muted })
hi("@text", { fg = c.base })
hi("@text.title", { fg = c.teal, bold = true })
hi("@text.emphasis", { italic = true })
hi("@text.strong", { bold = true })
hi("@text.uri", { fg = c.teal, underline = true })
hi("@text.literal", { fg = c.green })
hi("@text.reference", { fg = c.purple })

hi("DiagnosticError", { fg = c.red })
hi("DiagnosticWarn", { fg = c.orange })
hi("DiagnosticInfo", { fg = c.teal })
hi("DiagnosticHint", { fg = c.muted })
hi("DiagnosticUnderlineError", { undercurl = true, sp = c.red })
hi("DiagnosticUnderlineWarn", { undercurl = true, sp = c.orange })
hi("DiagnosticUnderlineInfo", { undercurl = true, sp = c.teal })
hi("DiagnosticUnderlineHint", { undercurl = true, sp = c.muted })
hi("LspReferenceText", { bg = c.bg_paren })
hi("LspReferenceRead", { bg = c.bg_paren })
hi("LspReferenceWrite", { bg = c.bg_paren, bold = true })

hi("DiffAdd", { fg = c.green, bg = "#1E3A1E" })
hi("DiffDelete", { fg = c.red, bg = "#3A1E1E" })
hi("DiffChange", { bg = "#1E2A3A" })
hi("DiffText", { fg = c.teal, bg = "#1E2A3A", bold = true })
hi("GitSignsAdd", { fg = c.green })
hi("GitSignsChange", { fg = c.teal })
hi("GitSignsDelete", { fg = c.red })

hi("TelescopeNormal", { fg = c.base, bg = c.bg_subtle })
hi("TelescopeBorder", { fg = c.border, bg = c.bg_subtle })
hi("TelescopePromptBorder", { fg = c.teal, bg = c.bg_subtle })
hi("TelescopeSelection", { bg = c.bg_sel })
hi("TelescopeMatching", { fg = c.teal, bold = true })

hi("CmpItemAbbr", { fg = c.base })
hi("CmpItemAbbrMatch", { fg = c.teal, bold = true })
hi("CmpItemAbbrMatchFuzzy", { fg = c.teal })
hi("CmpItemKind", { fg = c.muted })
hi("CmpItemMenu", { fg = c.very_muted })

hi("WhichKey", { fg = c.teal })
hi("WhichKeyGroup", { fg = c.purple })
hi("WhichKeyDesc", { fg = c.base })
hi("WhichKeySeparator", { fg = c.very_muted })
hi("WhichKeyFloat", { bg = c.bg_subtle })
