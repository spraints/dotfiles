local M = {}

local servers = {
  dockerls = {},
  gopls = {},
  rust_analyzer = {},
  tsserver = {},
}

local lsp_signature = require("lsp_signature")
lsp_signature.setup {
  bind = true,
  handler_opts = {
    border = "rounded"
  }
}

local function on_attach(client, bufnr)
  require("spraints.lsp.keymaps").setup(client, bufnr)
end

local opts = {
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  }
}

function M.setup()
  require("spraints.lsp.installer").setup(servers, opts)
end

return M
