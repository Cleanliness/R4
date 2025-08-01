-- Clear existing highlights and set colorscheme name
vim.cmd('highlight clear')
if vim.fn.exists('syntax_on') then
  vim.cmd('syntax reset')
end

vim.g.colors_name = 'minilight'


-- dark palette
local col_d = {
  bg = '#1e1e1e',
  fg2 = '#4e4b42',
  fg = '#635f54',

  -- general
  white = '#ebe6d2',
  red = '#bd9d83',
  green = '#a4a48c',
  yellow = '#e1d8aa',
  blue = '#8b98a3',
  cyan = '#8ba3a3',
  magenta = '#a38ba0',
  black = '#000000',
  gray = '#808080',

  -- vim/code specific
  comment = '#635f54',
  selection = '#4e4b42',
  line_number = '#858585',
  -- text = '',
}

-- light palette
local col_l = {
  bg = '#cdc8b0',
  fg = '#4e4b42',
}

-- Helper function to set highlights
local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Basic UI highlights
hl('Normal', { fg = col_d.fg, bg = col_d.bg })
hl('CursorLine', { bg = '#2d2d2d' })
hl('LineNr', { fg = col_d.line_number })
hl('CursorLineNr', { fg = col_d.yellow, bold = true })
hl('Visual', { bg = col_d.selection })
hl('Search', { fg = col_d.black, bg = col_d.yellow })
hl('StatusLine', { fg = col_d.fg, bg = '#007acc' })
hl('VertSplit', { fg = col_d.gray })

-- Syntax highlighting
hl('Comment', { fg = col_d.comment, italic = true })
hl('Constant', { fg = col_d.blue })
hl('String', { fg = col_d.green })
hl('Character', { fg = col_d.green })
hl('Number', { fg = col_d.cyan })
hl('Boolean', { fg = col_d.blue })
hl('Float', { fg = col_d.cyan })

hl('Identifier', { fg = col_d.blue })
hl('Function', { fg = col_d.yellow })

hl('Statement', { fg = col_d.magenta })
hl('Conditional', { fg = col_d.magenta })
hl('Repeat', { fg = col_d.magenta })
hl('Label', { fg = col_d.magenta })
hl('Operator', { fg = col_d.fg })
hl('Keyword', { fg = col_d.blue })
hl('Exception', { fg = col_d.magenta })

hl('PreProc', { fg = col_d.magenta })
hl('Include', { fg = col_d.magenta })
hl('Define', { fg = col_d.magenta })
hl('Macro', { fg = col_d.magenta })
hl('PreCondit', { fg = col_d.magenta })

hl('Type', { fg = col_d.blue })
hl('StorageClass', { fg = col_d.blue })
hl('Structure', { fg = col_d.blue })
hl('Typedef', { fg = col_d.blue })

hl('Special', { fg = col_d.yellow })
hl('SpecialChar', { fg = col_d.yellow })
hl('Tag', { fg = col_d.red })
hl('Delimiter', { fg = col_d.fg })
hl('SpecialComment', { fg = col_d.comment })
hl('Debug', { fg = col_d.red })

-- Error and warning highlights
hl('Error', { fg = col_d.red, bold = true })
hl('ErrorMsg', { fg = col_d.red, bold = true })
hl('WarningMsg', { fg = col_d.yellow, bold = true })

-- Diff highlights
hl('DiffAdd', { fg = col_d.green })
hl('DiffChange', { fg = col_d.yellow })
hl('DiffDelete', { fg = col_d.red })
hl('DiffText', { fg = col_d.blue, bold = true })


