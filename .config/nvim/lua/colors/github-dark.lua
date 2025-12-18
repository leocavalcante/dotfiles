-- GitHub Dark Default theme for Neovim
-- Colors extracted from iTerm2 GitHub-Dark-Default.itermcolors

local M = {}

M.colors = {
  bg = "#0d1117",
  bg_highlight = "#161b22",
  bg_visual = "#264f78",
  border = "#30363d",
  fg = "#e6edf3",
  fg_muted = "#8b949e",
  fg_subtle = "#6e7681",

  -- Syntax colors
  red = "#ff7b72",
  orange = "#ffa657",
  yellow = "#d29922",
  green = "#3fb950",
  cyan = "#39c5cf",
  blue = "#58a6ff",
  purple = "#bc8cff",
  magenta = "#d2a8ff",
  pink = "#ff9bce",

  -- Diff colors
  diff_add = "#238636",
  diff_delete = "#da3633",
  diff_change = "#1f6feb",
  diff_text = "#58a6ff",
}

function M.setup()
  local c = M.colors

  vim.cmd("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "github-dark"

  local highlights = {
    -- Editor
    Normal = { fg = c.fg, bg = c.bg },
    NormalFloat = { fg = c.fg, bg = c.bg_highlight },
    FloatBorder = { fg = c.border, bg = c.bg_highlight },
    ColorColumn = { bg = c.bg_highlight },
    Cursor = { fg = c.bg, bg = c.fg },
    CursorLine = { bg = c.bg_highlight },
    CursorLineNr = { fg = c.fg, bold = true },
    LineNr = { fg = c.fg_subtle },
    SignColumn = { fg = c.fg_subtle, bg = c.bg },
    VertSplit = { fg = c.border },
    WinSeparator = { fg = c.border },
    Folded = { fg = c.fg_muted, bg = c.bg_highlight },
    FoldColumn = { fg = c.fg_subtle, bg = c.bg },
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
    DiffAdd = { bg = "#244032" },
    DiffChange = { bg = "#272d43" },
    DiffDelete = { bg = "#3d2028" },
    DiffText = { bg = "#394b70" },

    -- Spelling
    SpellBad = { sp = c.red, undercurl = true },
    SpellCap = { sp = c.yellow, undercurl = true },
    SpellLocal = { sp = c.cyan, undercurl = true },
    SpellRare = { sp = c.purple, undercurl = true },

    -- Syntax
    Comment = { fg = c.fg_subtle, italic = true },
    Constant = { fg = c.blue },
    String = { fg = c.cyan },
    Character = { fg = c.cyan },
    Number = { fg = c.orange },
    Boolean = { fg = c.orange },
    Float = { fg = c.orange },
    Identifier = { fg = c.fg },
    Function = { fg = c.purple },
    Statement = { fg = c.red },
    Conditional = { fg = c.red },
    Repeat = { fg = c.red },
    Label = { fg = c.red },
    Operator = { fg = c.fg },
    Keyword = { fg = c.red },
    Exception = { fg = c.red },
    PreProc = { fg = c.red },
    Include = { fg = c.red },
    Define = { fg = c.red },
    Macro = { fg = c.purple },
    PreCondit = { fg = c.red },
    Type = { fg = c.orange },
    StorageClass = { fg = c.red },
    Structure = { fg = c.orange },
    Typedef = { fg = c.orange },
    Special = { fg = c.blue },
    SpecialChar = { fg = c.cyan },
    Tag = { fg = c.green },
    Delimiter = { fg = c.fg },
    SpecialComment = { fg = c.fg_subtle },
    Debug = { fg = c.orange },
    Underlined = { underline = true },
    Ignore = { fg = c.fg_subtle },
    Error = { fg = c.red },
    Todo = { fg = c.bg, bg = c.yellow, bold = true },

    -- Treesitter
    ["@variable"] = { fg = c.fg },
    ["@variable.builtin"] = { fg = c.blue },
    ["@variable.parameter"] = { fg = c.fg },
    ["@variable.member"] = { fg = c.fg },
    ["@constant"] = { fg = c.blue },
    ["@constant.builtin"] = { fg = c.blue },
    ["@constant.macro"] = { fg = c.blue },
    ["@module"] = { fg = c.fg },
    ["@label"] = { fg = c.blue },
    ["@string"] = { fg = c.cyan },
    ["@string.escape"] = { fg = c.blue },
    ["@string.special"] = { fg = c.blue },
    ["@character"] = { fg = c.cyan },
    ["@number"] = { fg = c.orange },
    ["@boolean"] = { fg = c.orange },
    ["@float"] = { fg = c.orange },
    ["@function"] = { fg = c.purple },
    ["@function.builtin"] = { fg = c.purple },
    ["@function.macro"] = { fg = c.purple },
    ["@function.method"] = { fg = c.purple },
    ["@constructor"] = { fg = c.orange },
    ["@keyword"] = { fg = c.red },
    ["@keyword.function"] = { fg = c.red },
    ["@keyword.operator"] = { fg = c.red },
    ["@keyword.return"] = { fg = c.red },
    ["@keyword.conditional"] = { fg = c.red },
    ["@keyword.repeat"] = { fg = c.red },
    ["@keyword.import"] = { fg = c.red },
    ["@keyword.exception"] = { fg = c.red },
    ["@operator"] = { fg = c.fg },
    ["@punctuation.bracket"] = { fg = c.fg },
    ["@punctuation.delimiter"] = { fg = c.fg },
    ["@punctuation.special"] = { fg = c.fg },
    ["@comment"] = { fg = c.fg_subtle, italic = true },
    ["@type"] = { fg = c.orange },
    ["@type.builtin"] = { fg = c.orange },
    ["@type.definition"] = { fg = c.orange },
    ["@attribute"] = { fg = c.purple },
    ["@property"] = { fg = c.fg },
    ["@tag"] = { fg = c.green },
    ["@tag.attribute"] = { fg = c.blue },
    ["@tag.delimiter"] = { fg = c.fg },

    -- LSP Semantic Tokens
    ["@lsp.type.class"] = { fg = c.orange },
    ["@lsp.type.decorator"] = { fg = c.purple },
    ["@lsp.type.enum"] = { fg = c.orange },
    ["@lsp.type.enumMember"] = { fg = c.blue },
    ["@lsp.type.function"] = { fg = c.purple },
    ["@lsp.type.interface"] = { fg = c.orange },
    ["@lsp.type.macro"] = { fg = c.purple },
    ["@lsp.type.method"] = { fg = c.purple },
    ["@lsp.type.namespace"] = { fg = c.fg },
    ["@lsp.type.parameter"] = { fg = c.fg },
    ["@lsp.type.property"] = { fg = c.fg },
    ["@lsp.type.struct"] = { fg = c.orange },
    ["@lsp.type.type"] = { fg = c.orange },
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
    DiagnosticVirtualTextError = { fg = c.red, bg = "#3d2028" },
    DiagnosticVirtualTextWarn = { fg = c.yellow, bg = "#3d3422" },
    DiagnosticVirtualTextInfo = { fg = c.blue, bg = "#1e3a5f" },
    DiagnosticVirtualTextHint = { fg = c.cyan, bg = "#1e3a3a" },

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
    NeoTreeNormal = { fg = c.fg, bg = c.bg },
    NeoTreeNormalNC = { fg = c.fg, bg = c.bg },
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
