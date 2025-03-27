local function join_paths(...)
	-- directory separator
	-- https://www.lua.org/manual/5.2/manual.html#pdf-package.config
    local separator = package.config:sub(1, 1)
    return table.concat({...}, separator)
end

--------------------------------------------------

-- ~/.local/share/nvim/mason/bin
local LSP_PATH = join_paths(vim.fn.stdpath "data", "mason")
local BIN_PATH = join_paths(LSP_PATH, "bin")

--------------------------------------------------

local configs = {

luals = {
	cmd = { join_paths(BIN_PATH, "lua-language-server") },
	filetypes = {'lua'},
	root_markers = { '.luarc.json', '.luarc.jsonc' },
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" }
		}
	}
},

pylsp = {
	cmd = {
		join_paths(BIN_PATH, "basedpyright-langserver"),
		"--stdio"
	},
	filetypes = {'python'},
	root_markers = { ".pyproject.toml", "setup.py", "requirements.txt" },
},

tsls = {
	cmd = {
		join_paths(BIN_PATH, "typescript-language-server"),
		"--stdio"
	},
	filetypes = {'typescript', 'javascript'},
	root_markers = {"package.json", "tsconfig.json", "jsconfig.json"},
},

cxxls = {
	cmd = { join_paths(BIN_PATH, "clangd") },
	filetypes = {'c', 'cpp', 'cuda'},
	root_markers = {"Makefile", "CMakeLists.txt"}
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
	lsp_path = LSP_PATH,
	apply_config = apply_config
}
