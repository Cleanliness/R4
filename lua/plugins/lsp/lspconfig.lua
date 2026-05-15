local function join_paths(...)
  -- directory separator
  -- https://www.lua.org/manual/5.2/manual.html#pdf-package.config
  local separator = package.config:sub(1, 1)
  return table.concat({...}, separator)
end


--------------------------------------------------

local configs = {

-- LUA
luals = {
  cmd = { "lua-language-server" },
  filetypes = {'lua'},
  root_markers = { '.luarc.json', '.luarc.jsonc' },
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" }
    }
  }
},

-- python
pylsp = {
  cmd = {
    "pyrefly",
    "lsp",
  },
  filetypes = {'python'},
  root_markers = { ".pyproject.toml", "setup.py", "requirements.txt" },
},

-- js
tsls = {
  cmd = {
    "vtsls",
    "--stdio"
  },
  filetypes = {'typescript', 'javascript'},
  root_markers = {"package.json", "tsconfig.json", "jsconfig.json"},
},

-- c
cxxls = {
  cmd = { "clangd" },
  filetypes = {'c', 'cpp', 'cuda'},
  root_markers = {"Makefile", "CMakeLists.txt"}
},

-- rust
rsls = {
  cmd = { "rust-analyzer" },
  filetypes = {'rust'},
  root_markers = { "Cargo.toml", "rust-project.json" },
}

} -- /configs

--------------------------------------------------

local apply_config = function()
  for k, v in pairs(configs) do
    vim.lsp.config(k, v)
    vim.lsp.enable(k)
  end
end

return {
  apply_config = apply_config,
}
