-- Sane colorcolumn defaults for popular style guides
-----------------------------------------------------------------------------

local GUIDES = {
  _default = 0,

  -- Language-specific overrides
  c          = 80,   -- Linux kernel / GNU
  cpp        = 80,   -- Google, LLVM, ISO
  java       = 100,  -- Google Java Style
  python     = 88,   -- PEP 8 (Black's default)
  rust       = 100,  -- rustfmt default
  go         = 0,    -- Go encourages no hard limit; disable
  javascript = 100,  -- Airbnb / Google JS
  typescript = 100,
  jsx        = 100,
  tsx        = 100,
  vue        = 100,
  svelte     = 100,
  lua        = 80,

  -- ML and DS stuff
  cuda       = 80,   -- CUDA C/C++ (.cu files)
  ipynb      = 0,    -- Jupyter notebooks (JSON-based, disable)
  r          = 80,   -- R language
  matlab     = 80,   -- MATLAB/Octave
  scala      = 100,  -- Scala (used in Spark/ML)
  sql        = 80,   -- SQL queries
  sh         = 80,   -- Shell scripts (bash/zsh)
  dockerfile = 80,   -- Docker files
  proto      = 80,   -- Protocol buffers
  toml       = 80,   -- Configuration files (PyTorch, etc.)
  ini        = 80,   -- Configuration files
  cfg        = 80,   -- Configuration files
  conf       = 80,   -- Configuration files
  tex        = 80,   -- LaTeX (research papers)
  bib        = 80,   -- BibTeX (citations)

  -- data files to exclude
  json       = 0,
  yaml       = 0,
  markdown   = 0,
  csv        = 0,    -- Data files, disable
  tsv        = 0,    -- Data files, disable
  pkl        = 0,    -- Pickle files, disable
  h5         = 0,    -- HDF5 files, disable
  parquet    = 0,    -- Parquet files, disable
}

-- Helper: set cc for the current buffer
local function set_cc()
  local ft = vim.bo.filetype
  local width = GUIDES[ft] or GUIDES._default
  vim.wo.colorcolumn = width > 0 and tostring(width) or ''
end

-- Auto-command group so we don't create duplicates on re-source
local group = vim.api.nvim_create_augroup('ColorColumnByFt', { clear = true })
vim.api.nvim_create_autocmd({ 'FileType' }, {
  group    = group,
  callback = set_cc,
})

-- (Optional) If you want the same logic for new buffers before they
-- get a filetype you can also do:
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  group    = group,
  callback = set_cc,
})

