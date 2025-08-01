-- like a statusbar but on top, and buffer local

local M = {}

M.config = {
  enabled = true,
  show_file_path = true,        -- relative to cwd
  show_modified = true,         -- file modified indicator
  show_readonly = true,         -- read only indicator
  show_treesitter_scope = true, -- show current function/class context
  max_path_length = 80,         -- truncation limit
  max_scope_length = 30,        -- treesitter scope truncation limit

  -- Icons
  icons = {
    modified = " ●",
    readonly = " R",
    separator = " ",
    scope_separator = " ⟩ ",
    scope_prefix = " » ",
    path_separator = "/",
  },

  -- Highlight groups (matching statusline)
  highlights = {
    background = "StatusLine",
    path = "StatusLine",
    file_name = "StatusLine",
    modified = "StatusLine",
    readonly = "StatusLine",
    scope = "StatusLine",
    separator = "StatusLine",
  },

  -- Exclude filetypes
  exclude_filetypes = {
    "help",
    "startify",
    "dashboard",
    "packer",
    "neogitstatus",
    "NvimTree",
    "Trouble",
    "alpha",
    "lir",
    "Outline",
    "spectre_panel",
    "toggleterm",
    "qf",
  },

  -- Exclude buftypes
  exclude_buftypes = {
    "terminal",
    "nofile",
    "quickfix",
    "prompt",
  },
}

--------------------------------------------------
--                   Helpers
--------------------------------------------------

-- Helper function to check if winbar should be shown
local function should_show_winbar()
  local buftype = vim.bo.buftype
  local filetype = vim.bo.filetype

  -- Skip excluded buftypes
  if vim.tbl_contains(M.config.exclude_buftypes, buftype) then
    return false
  end

  -- Skip excluded filetypes
  if vim.tbl_contains(M.config.exclude_filetypes, filetype) then
    return false
  end

  -- Skip empty buffers
  if vim.api.nvim_buf_get_name(0) == "" then
    return false
  end

  return true
end

-- Truncate path if too long
local function truncate_path(path, max_length)
  if #path <= max_length then
    return path
  end

  return "..." .. path:sub(-(max_length - 3))
end


-- Get file path relative to current working directory
local function get_file_path()
  local filepath = vim.fn.expand("%:~:.")

  if not M.config.show_file_path then
    return "%#" .. M.config.highlights.file_name .. "#" .. vim.fn.expand("%:t") -- Just filename
  end

  -- Replace path separator with custom separator
  local path_parts = vim.split(filepath, "/")
  local formatted_path = table.concat(path_parts, M.config.icons.path_separator)

  return "%#" .. M.config.highlights.path .. "#" .. truncate_path(formatted_path, M.config.max_path_length)
end


-- Get file status indicators
local function get_file_status()
  local status = ""

  if M.config.show_modified and vim.bo.modified then
    status = status .. "%#" .. M.config.highlights.modified .. "#" .. M.config.icons.modified
  end

  if M.config.show_readonly and vim.bo.readonly then
    status = status .. "%#" .. M.config.highlights.readonly .. "#" .. M.config.icons.readonly
  end

  return status
end


-- Get treesitter scope context
local function get_treesitter_scope()
  if not M.config.show_treesitter_scope then
    return ""
  end

  -- Check if treesitter is available
  local ok, ts_utils = pcall(require, "nvim-treesitter.ts_utils")
  if not ok then
    return ""
  end

  -- Get the current buffer and cursor position
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1 -- treesitter uses 0-based indexing

  -- Get the parser for the current buffer
  local ok_parser, parser = pcall(vim.treesitter.get_parser, bufnr)
  if not ok_parser or not parser then
    return ""
  end

  -- Get the syntax tree
  local tree = parser:parse()[1]
  if not tree then
    return ""
  end

  local root = tree:root()

  -- Find the innermost node containing the cursor
  local current_node = root:descendant_for_range(row, 0, row, -1)
  if not current_node then
    return ""
  end

  -- Look for function/class/method nodes
  local scope_types = {
    "function_definition",
    "function_declaration",
    "method_definition",
    "class_definition",
    "class_declaration",
    "interface_declaration",
    "struct_declaration",
    "enum_declaration",
    "function",
    "method",
    "class",
    "interface",
    "struct",
    "enum",
    "impl_item",
    "trait_definition",
    "namespace_definition",
    "module_definition",
  }

  local scopes = {}
  local node = current_node

  -- Traverse up the tree to find scope nodes
  while node do
    local node_type = node:type()

    if vim.tbl_contains(scope_types, node_type) then
      -- Try to get the name of the scope
      local name = get_scope_name(node, node_type)
      if name and name ~= "" then
        table.insert(scopes, 1, name) -- Insert at beginning to maintain order
      end
    end

    node = node:parent()
  end

  if #scopes == 0 then
    return ""
  end

  -- Join scopes with separator and truncate if needed
  local scope_text = table.concat(scopes, M.config.icons.scope_separator)
  scope_text = truncate_path(scope_text, M.config.max_scope_length)

  return "%#" .. M.config.highlights.scope .. "#" .. M.config.icons.scope_prefix .. scope_text
end

-- Helper function to extract scope name from treesitter node
function get_scope_name(node, node_type)
  local name = ""

  -- Look for name/identifier child nodes
  for child in node:iter_children() do
    local child_type = child:type()

    if child_type == "identifier" or child_type == "name" then
      name = vim.treesitter.get_node_text(child, 0)
      break
    elseif child_type == "function_name" or child_type == "class_name" then
      -- Some languages have specific name node types
      name = vim.treesitter.get_node_text(child, 0)
      break
    end
  end

  -- If no direct name found, try to find it in nested structures
  if name == "" then
    for child in node:iter_children() do
      for grandchild in child:iter_children() do
        local grandchild_type = grandchild:type()
        if grandchild_type == "identifier" or grandchild_type == "name" then
          name = vim.treesitter.get_node_text(grandchild, 0)
          break
        end
      end
      if name ~= "" then break end
    end
  end

  return name
end


--------------------------------------------------
--                 Construction
--------------------------------------------------

function M.get_winbar()
  if not M.config.enabled or not should_show_winbar() then
    return ""
  end

  local file_path = get_file_path()
  local file_status = get_file_status()
  local scope = get_treesitter_scope()

  -- Build content without individual highlights first
  local content = file_path:gsub("%%#.-#", "") -- Strip existing highlights

  if scope ~= "" then
    content = content .. scope:gsub("%%#.-#", "")
  end

  if file_status ~= "" then
    content = content .. M.config.icons.separator .. file_status:gsub("%%#.-#", "")
  end

  -- Apply single background highlight to entire content
  return "%#" .. M.config.highlights.background .. "#" .. content .. "%*"
end


-- Setup function to configure winbar
function M.setup(opts)
  -- Merge user config with defaults
  M.config = vim.tbl_deep_extend("force", M.config, opts or {})

  -- Set up autocommands to update winbar
  local group = vim.api.nvim_create_augroup("CustomWinbar", { clear = true })

  vim.api.nvim_create_autocmd({
    "BufEnter",
    "BufWritePost",
    "TextChanged",
    "TextChangedI",
    "WinEnter",
    "CursorMoved",
    "CursorMovedI",
  }, {
    group = group,
    callback = function()
      if should_show_winbar() then
        vim.wo.winbar = M.get_winbar()
      else
        vim.wo.winbar = nil
      end
    end,
  })
end

-- Manual update function
function M.update()
  if should_show_winbar() then
    vim.wo.winbar = M.get_winbar()
  else
    vim.wo.winbar = nil
  end
end

return M

