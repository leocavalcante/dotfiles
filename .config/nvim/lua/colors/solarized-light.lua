-- Solarized Light theme for Neovim
-- Colors from https://ethanschoonover.com/solarized/
-- Canonical CIELAB values translated to sRGB

local M = {}

M.colors = {
  bg = "#fdf6e3",
  bg_highlight = "#eee8d5",
  bg_visual = "#eee8d5",
  border = "#eee8d5",
  fg = "#657b83",
  fg_muted = "#93a1a1",
  fg_subtle = "#93a1a1",

  -- Terminal colors (ANSI)
  black = "#073642",
  bright_black = "#002b36",
  white = "#eee8d5",
  bright_white = "#fdf6e3",

  -- Solarized accent colors
  red = "#dc322f",
  orange = "#cb4b16",
  yellow = "#b58900",
  green = "#859900",
  cyan = "#2aa198",
  blue = "#268bd2",
  violet = "#6c71c4",
  magenta = "#d33682",

  -- Monotone content
  base01 = "#586e75",
  base00 = "#657b83",
  base0 = "#839496",
  base1 = "#93a1a1",

  -- Special
  cursor = "#586e75",

  -- Diff colors
  diff_add = "#859900",
  diff_delete = "#dc322f",
  diff_change = "#268bd2",
  diff_text = "#268bd2",
}

function M.setup()
  local c = M.colors

  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "solarized-light"

  local highlights = {
    -- Editor
    Normal = { fg = c.fg },
    NormalFloat = { fg = c.fg, bg = c.bg_highlight },
    FloatBorder = { fg = c.border, bg = c.bg_highlight },
    ColorColumn = { bg = c.bg_highlight },
    Cursor = { fg = c.bg, bg = c.fg },
    CursorLine = { bg = c.bg_highlight },
    CursorLineNr = { fg = c.base01, bold = true },
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
    IncSearch = { fg = c.bg, bg = c.yellow },
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
    DiffAdd = { bg = "#eee8d5" },
    DiffChange = { bg = "#eee8d5" },
    DiffDelete = { fg = c.red, bg = "#eee8d5" },
    DiffText = { bg = "#ddd6c1" },

    -- Spelling
    SpellBad = { sp = c.red, undercurl = true },
    SpellCap = { sp = c.yellow, undercurl = true },
    SpellLocal = { sp = c.cyan, undercurl = true },
    SpellRare = { sp = c.violet, undercurl = true },

    -- Syntax (Solarized conventions)
    Comment = { fg = c.base1, italic = true },
    Constant = { fg = c.cyan },
    String = { fg = c.cyan },
    Character = { fg = c.cyan },
    Number = { fg = c.magenta },
    Boolean = { fg = c.magenta },
    Float = { fg = c.magenta },
    Identifier = { fg = c.fg },
    Function = { fg = c.blue },
    Statement = { fg = c.green },
    Conditional = { fg = c.green },
    Repeat = { fg = c.green },
    Label = { fg = c.green },
    Operator = { fg = c.fg },
    Keyword = { fg = c.green },
    Exception = { fg = c.green },
    PreProc = { fg = c.orange },
    Include = { fg = c.orange },
    Define = { fg = c.orange },
    Macro = { fg = c.orange },
    PreCondit = { fg = c.orange },
    Type = { fg = c.yellow },
    StorageClass = { fg = c.yellow },
    Structure = { fg = c.yellow },
    Typedef = { fg = c.yellow },
    Special = { fg = c.orange },
    SpecialChar = { fg = c.orange },
    Tag = { fg = c.blue },
    Delimiter = { fg = c.fg },
    SpecialComment = { fg = c.base1 },
    Debug = { fg = c.orange },
    Underlined = { fg = c.violet, underline = true },
    Ignore = { fg = c.fg_subtle },
    Error = { fg = c.red },
    Todo = { fg = c.bg, bg = c.yellow, bold = true },

    -- Treesitter
    ["@variable"] = { fg = c.fg },
    ["@variable.builtin"] = { fg = c.blue },
    ["@variable.parameter"] = { fg = c.fg },
    ["@variable.member"] = { fg = c.fg },
    ["@constant"] = { fg = c.cyan },
    ["@constant.builtin"] = { fg = c.cyan },
    ["@constant.macro"] = { fg = c.cyan },
    ["@module"] = { fg = c.fg },
    ["@label"] = { fg = c.green },
    ["@string"] = { fg = c.cyan },
    ["@string.escape"] = { fg = c.orange },
    ["@string.special"] = { fg = c.orange },
    ["@character"] = { fg = c.cyan },
    ["@number"] = { fg = c.magenta },
    ["@boolean"] = { fg = c.magenta },
    ["@float"] = { fg = c.magenta },
    ["@function"] = { fg = c.blue },
    ["@function.builtin"] = { fg = c.blue },
    ["@function.macro"] = { fg = c.blue },
    ["@function.method"] = { fg = c.blue },
    ["@constructor"] = { fg = c.yellow },
    ["@keyword"] = { fg = c.green },
    ["@keyword.function"] = { fg = c.green },
    ["@keyword.operator"] = { fg = c.green },
    ["@keyword.return"] = { fg = c.green },
    ["@keyword.conditional"] = { fg = c.green },
    ["@keyword.repeat"] = { fg = c.green },
    ["@keyword.import"] = { fg = c.orange },
    ["@keyword.exception"] = { fg = c.green },
    ["@operator"] = { fg = c.fg },
    ["@punctuation.bracket"] = { fg = c.fg },
    ["@punctuation.delimiter"] = { fg = c.fg },
    ["@punctuation.special"] = { fg = c.fg },
    ["@comment"] = { fg = c.base1, italic = true },
    ["@type"] = { fg = c.yellow },
    ["@type.builtin"] = { fg = c.yellow },
    ["@type.definition"] = { fg = c.yellow },
    ["@attribute"] = { fg = c.orange },
    ["@property"] = { fg = c.fg },
    ["@tag"] = { fg = c.blue },
    ["@tag.attribute"] = { fg = c.cyan },
    ["@tag.delimiter"] = { fg = c.fg },

    -- LSP Semantic Tokens
    ["@lsp.type.class"] = { fg = c.yellow },
    ["@lsp.type.decorator"] = { fg = c.orange },
    ["@lsp.type.enum"] = { fg = c.yellow },
    ["@lsp.type.enumMember"] = { fg = c.cyan },
    ["@lsp.type.function"] = { fg = c.blue },
    ["@lsp.type.interface"] = { fg = c.yellow },
    ["@lsp.type.macro"] = { fg = c.orange },
    ["@lsp.type.method"] = { fg = c.blue },
    ["@lsp.type.namespace"] = { fg = c.fg },
    ["@lsp.type.parameter"] = { fg = c.fg },
    ["@lsp.type.property"] = { fg = c.fg },
    ["@lsp.type.struct"] = { fg = c.yellow },
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
    DiagnosticVirtualTextError = { fg = c.red, bg = "#eee8d5" },
    DiagnosticVirtualTextWarn = { fg = c.yellow, bg = "#eee8d5" },
    DiagnosticVirtualTextInfo = { fg = c.blue, bg = "#eee8d5" },
    DiagnosticVirtualTextHint = { fg = c.cyan, bg = "#eee8d5" },

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
    WhichKey = { fg = c.violet },
    WhichKeyGroup = { fg = c.blue },
    WhichKeyDesc = { fg = c.fg },
    WhichKeySeperator = { fg = c.fg_subtle },
    WhichKeySeparator = { fg = c.fg_subtle },
    WhichKeyFloat = { bg = c.bg_highlight },

    -- Lazy
    LazyH1 = { fg = c.bg, bg = c.blue, bold = true },
    LazyButton = { fg = c.fg, bg = c.bg_highlight },
    LazyButtonActive = { fg = c.bg, bg = c.blue },
    LazySpecial = { fg = c.violet },

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
    NotifyTRACEBorder = { fg = c.violet },
    NotifyERRORIcon = { fg = c.red },
    NotifyWARNIcon = { fg = c.yellow },
    NotifyINFOIcon = { fg = c.blue },
    NotifyDEBUGIcon = { fg = c.fg_subtle },
    NotifyTRACEIcon = { fg = c.violet },
    NotifyERRORTitle = { fg = c.red },
    NotifyWARNTitle = { fg = c.yellow },
    NotifyINFOTitle = { fg = c.blue },
    NotifyDEBUGTitle = { fg = c.fg_subtle },
    NotifyTRACETitle = { fg = c.violet },

    -- Cmp
    CmpItemAbbr = { fg = c.fg },
    CmpItemAbbrDeprecated = { fg = c.fg_subtle, strikethrough = true },
    CmpItemAbbrMatch = { fg = c.blue, bold = true },
    CmpItemAbbrMatchFuzzy = { fg = c.blue, bold = true },
    CmpItemKind = { fg = c.violet },
    CmpItemMenu = { fg = c.fg_subtle },

    -- Lualine
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
