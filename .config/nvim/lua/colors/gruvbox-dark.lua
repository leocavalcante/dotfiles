-- Gruvbox Dark theme for Neovim
-- Based on https://github.com/morhetz/gruvbox

local M = {}

M.colors = {
  bg = "#282828",
  bg_highlight = "#3c3836",
  bg_visual = "#504945",
  border = "#665c54",
  fg = "#ebdbb2",
  fg_muted = "#a89984",
  fg_subtle = "#928374",

  -- Terminal colors (ANSI)
  black = "#282828",
  bright_black = "#928374",
  white = "#a89984",
  bright_white = "#ebdbb2",

  -- Syntax colors (use Gruvbox bright variants for dark mode)
  red = "#fb4934",
  bright_red = "#cc241d",
  orange = "#fe8019",
  yellow = "#fabd2f",
  bright_yellow = "#d79921",
  green = "#b8bb26",
  bright_green = "#98971a",
  cyan = "#8ec07c",
  bright_cyan = "#689d6a",
  blue = "#83a598",
  bright_blue = "#458588",
  purple = "#d3869b",
  magenta = "#b16286",
  pink = "#d3869b",

  -- Special
  cursor = "#ebdbb2",

  -- Diff colors
  diff_add = "#98971a",
  diff_delete = "#cc241d",
  diff_change = "#458588",
  diff_text = "#83a598",
}

function M.setup()
  local c = M.colors

  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "gruvbox-dark"

  local highlights = {
    -- Editor
    Normal = { fg = c.fg, bg = c.bg },
    NormalFloat = { fg = c.fg, bg = c.bg_highlight },
    FloatBorder = { fg = c.border, bg = c.bg_highlight },
    ColorColumn = { bg = c.bg_highlight },
    Cursor = { fg = c.bg, bg = c.fg },
    CursorLine = { bg = c.bg_highlight },
    CursorLineNr = { fg = c.yellow, bold = true },
    LineNr = { fg = c.fg_subtle },
    SignColumn = { fg = c.fg_subtle },
    VertSplit = { fg = c.border },
    WinSeparator = { fg = c.border },
    Folded = { fg = c.fg_muted, bg = c.bg_highlight },
    FoldColumn = { fg = c.fg_subtle },
    NonText = { fg = c.fg_subtle },
    SpecialKey = { fg = c.fg_subtle },
    EndOfBuffer = { fg = c.bg },

    -- Search
    Search = { fg = c.bg, bg = c.yellow },
    IncSearch = { fg = c.bg, bg = c.orange },
    CurSearch = { fg = c.bg, bg = c.orange },
    Substitute = { fg = c.bg, bg = c.red },

    -- Selection
    Visual = { bg = c.bg_visual },
    VisualNOS = { bg = c.bg_visual },

    -- Statusline
    StatusLine = { fg = c.fg, bg = c.bg_highlight },
    StatusLineNC = { fg = c.fg_muted, bg = c.bg_highlight },
    WildMenu = { fg = c.bg, bg = c.blue },

    -- Tabline
    TabLine = { fg = c.fg_muted, bg = c.bg_highlight },
    TabLineFill = { bg = c.bg },
    TabLineSel = { fg = c.fg, bg = c.bg },

    -- Popup menu
    Pmenu = { fg = c.fg, bg = c.bg_highlight },
    PmenuSel = { fg = c.bg, bg = c.blue },
    PmenuSbar = { bg = c.bg_highlight },
    PmenuThumb = { bg = c.fg_subtle },

    -- Messages
    ModeMsg = { fg = c.fg, bold = true },
    MoreMsg = { fg = c.green },
    Question = { fg = c.green },
    WarningMsg = { fg = c.yellow },
    ErrorMsg = { fg = c.red },

    -- Diff
    DiffAdd = { bg = "#3d4220" },
    DiffChange = { bg = "#2e3b3b" },
    DiffDelete = { bg = "#3e2a1f" },
    DiffText = { bg = "#3b4d5c" },

    -- Spelling
    SpellBad = { sp = c.red, undercurl = true },
    SpellCap = { sp = c.yellow, undercurl = true },
    SpellLocal = { sp = c.cyan, undercurl = true },
    SpellRare = { sp = c.purple, undercurl = true },

    -- Syntax (following gruvbox.vim rules)
    Comment = { fg = c.fg_subtle, italic = true },
    Constant = { fg = c.purple },
    String = { fg = c.green },
    Character = { fg = c.green },
    Number = { fg = c.purple },
    Boolean = { fg = c.purple },
    Float = { fg = c.purple },
    Identifier = { fg = c.blue },
    Function = { fg = c.green, bold = true },
    Statement = { fg = c.red },
    Conditional = { fg = c.red },
    Repeat = { fg = c.red },
    Label = { fg = c.red },
    Operator = { fg = c.fg },
    Keyword = { fg = c.red },
    Exception = { fg = c.red },
    PreProc = { fg = c.cyan },
    Include = { fg = c.cyan },
    Define = { fg = c.cyan },
    Macro = { fg = c.cyan },
    PreCondit = { fg = c.cyan },
    Type = { fg = c.yellow },
    StorageClass = { fg = c.orange },
    Structure = { fg = c.cyan },
    Typedef = { fg = c.yellow },
    Special = { fg = c.orange },
    SpecialChar = { fg = c.orange },
    Tag = { fg = c.green },
    Delimiter = { fg = c.fg },
    SpecialComment = { fg = c.fg_subtle },
    Debug = { fg = c.orange },
    Underlined = { underline = true },
    Ignore = { fg = c.fg_subtle },
    Error = { fg = c.red },
    Todo = { fg = c.fg, bg = c.bg, bold = true, italic = true },

    -- Treesitter
    ["@variable"] = { fg = c.fg },
    ["@variable.builtin"] = { fg = c.orange },
    ["@variable.parameter"] = { fg = c.fg },
    ["@variable.member"] = { fg = c.fg },
    ["@constant"] = { fg = c.purple },
    ["@constant.builtin"] = { fg = c.purple },
    ["@constant.macro"] = { fg = c.cyan },
    ["@module"] = { fg = c.fg },
    ["@label"] = { fg = c.red },
    ["@string"] = { fg = c.green },
    ["@string.escape"] = { fg = c.orange },
    ["@string.special"] = { fg = c.orange },
    ["@character"] = { fg = c.green },
    ["@number"] = { fg = c.purple },
    ["@boolean"] = { fg = c.purple },
    ["@float"] = { fg = c.purple },
    ["@function"] = { fg = c.green, bold = true },
    ["@function.builtin"] = { fg = c.green, bold = true },
    ["@function.macro"] = { fg = c.cyan },
    ["@function.method"] = { fg = c.green, bold = true },
    ["@constructor"] = { fg = c.orange },
    ["@keyword"] = { fg = c.red },
    ["@keyword.function"] = { fg = c.red },
    ["@keyword.operator"] = { fg = c.red },
    ["@keyword.return"] = { fg = c.red },
    ["@keyword.conditional"] = { fg = c.red },
    ["@keyword.repeat"] = { fg = c.red },
    ["@keyword.import"] = { fg = c.cyan },
    ["@keyword.exception"] = { fg = c.red },
    ["@operator"] = { fg = c.fg },
    ["@punctuation.bracket"] = { fg = c.fg },
    ["@punctuation.delimiter"] = { fg = c.fg },
    ["@punctuation.special"] = { fg = c.fg },
    ["@comment"] = { fg = c.fg_subtle, italic = true },
    ["@type"] = { fg = c.yellow },
    ["@type.builtin"] = { fg = c.yellow },
    ["@type.definition"] = { fg = c.yellow },
    ["@attribute"] = { fg = c.cyan },
    ["@property"] = { fg = c.fg },
    ["@tag"] = { fg = c.green },
    ["@tag.attribute"] = { fg = c.blue },
    ["@tag.delimiter"] = { fg = c.fg },

    -- LSP Semantic Tokens
    ["@lsp.type.class"] = { fg = c.yellow },
    ["@lsp.type.decorator"] = { fg = c.cyan },
    ["@lsp.type.enum"] = { fg = c.yellow },
    ["@lsp.type.enumMember"] = { fg = c.purple },
    ["@lsp.type.function"] = { fg = c.green, bold = true },
    ["@lsp.type.interface"] = { fg = c.yellow },
    ["@lsp.type.macro"] = { fg = c.cyan },
    ["@lsp.type.method"] = { fg = c.green, bold = true },
    ["@lsp.type.namespace"] = { fg = c.fg },
    ["@lsp.type.parameter"] = { fg = c.fg },
    ["@lsp.type.property"] = { fg = c.fg },
    ["@lsp.type.struct"] = { fg = c.cyan },
    ["@lsp.type.type"] = { fg = c.yellow },
    ["@lsp.type.variable"] = { fg = c.fg },

    -- Diagnostics
    DiagnosticError = { fg = c.red },
    DiagnosticWarn = { fg = c.yellow },
    DiagnosticInfo = { fg = c.blue },
    DiagnosticHint = { fg = c.cyan },
    DiagnosticUnderlineError = { sp = c.red, undercurl = true },
    DiagnosticUnderlineWarn = { sp = c.yellow, undercurl = true },
    DiagnosticUnderlineInfo = { sp = c.blue, undercurl = true },
    DiagnosticUnderlineHint = { sp = c.cyan, undercurl = true },
    DiagnosticVirtualTextError = { fg = c.red, bg = "#3e2a1f" },
    DiagnosticVirtualTextWarn = { fg = c.yellow, bg = "#3d3820" },
    DiagnosticVirtualTextInfo = { fg = c.blue, bg = "#2e3b3b" },
    DiagnosticVirtualTextHint = { fg = c.cyan, bg = "#2e3a2e" },

    -- Git signs
    GitSignsAdd = { fg = c.green },
    GitSignsChange = { fg = c.yellow },
    GitSignsDelete = { fg = c.red },

    -- Telescope
    TelescopeBorder = { fg = c.border },
    TelescopeTitle = { fg = c.blue, bold = true },
    TelescopePromptPrefix = { fg = c.blue },
    TelescopeSelection = { bg = c.bg_highlight },
    TelescopeMatching = { fg = c.yellow, bold = true },

    -- Neo-tree
    NeoTreeNormal = { fg = c.fg },
    NeoTreeNormalNC = { fg = c.fg },
    NeoTreeDirectoryName = { fg = c.fg },
    NeoTreeDirectoryIcon = { fg = c.blue },
    NeoTreeRootName = { fg = c.blue, bold = true },
    NeoTreeFileName = { fg = c.fg },
    NeoTreeGitAdded = { fg = c.green },
    NeoTreeGitModified = { fg = c.yellow },
    NeoTreeGitDeleted = { fg = c.red },
    NeoTreeGitUntracked = { fg = c.orange },

    -- Indent Blankline
    IndentBlanklineChar = { fg = c.border },
    IndentBlanklineContextChar = { fg = c.fg_subtle },
    IblIndent = { fg = c.border },
    IblScope = { fg = c.fg_subtle },

    -- Which-key
    WhichKey = { fg = c.purple },
    WhichKeyGroup = { fg = c.blue },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeperator = { fg = c.fg_subtle },
    WhichKeySeparator = { fg = c.fg_subtle },
    WhichKeyFloat = { bg = c.bg_highlight },

    -- Lazy
    LazyH1 = { fg = c.bg, bg = c.blue, bold = true },
    LazyButton = { fg = c.fg, bg = c.bg_highlight },
    LazyButtonActive = { fg = c.bg, bg = c.blue },
    LazySpecial = { fg = c.purple },

    -- Mason
    MasonHeader = { fg = c.bg, bg = c.blue, bold = true },
    MasonHighlight = { fg = c.blue },
    MasonHighlightBlock = { fg = c.bg, bg = c.blue },
    MasonHighlightBlockBold = { fg = c.bg, bg = c.blue, bold = true },

    -- Notify
    NotifyERRORBorder = { fg = c.red },
    NotifyWARNBorder = { fg = c.yellow },
    NotifyINFOBorder = { fg = c.blue },
    NotifyDEBUGBorder = { fg = c.fg_subtle },
    NotifyTRACEBorder = { fg = c.purple },
    NotifyERRORIcon = { fg = c.red },
    NotifyWARNIcon = { fg = c.yellow },
    NotifyINFOIcon = { fg = c.blue },
    NotifyDEBUGIcon = { fg = c.fg_subtle },
    NotifyTRACEIcon = { fg = c.purple },
    NotifyERRORTitle = { fg = c.red },
    NotifyWARNTitle = { fg = c.yellow },
    NotifyINFOTitle = { fg = c.blue },
    NotifyDEBUGTitle = { fg = c.fg_subtle },
    NotifyTRACETitle = { fg = c.purple },

    -- Cmp
    CmpItemAbbr = { fg = c.fg },
    CmpItemAbbrDeprecated = { fg = c.fg_subtle, strikethrough = true },
    CmpItemAbbrMatch = { fg = c.blue, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.blue, bold = true },
    CmpItemKind = { fg = c.purple },
    CmpItemMenu = { fg = c.fg_subtle },

    -- Lualine (if not using built-in theme)
    lualine_a_normal = { fg = c.bg, bg = c.blue, bold = true },
    lualine_b_normal = { fg = c.fg, bg = c.bg_highlight },
    lualine_c_normal = { fg = c.fg_muted, bg = c.bg },

    -- Harpoon
    HarpoonBorder = { fg = c.border },
    HarpoonWindow = { fg = c.fg, bg = c.bg_highlight },
  }

  for group, opts in pairs(highlights) do
    vim.api.nvim_set_hl(0, group, opts)
  end
end

return M
