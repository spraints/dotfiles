local M = {}

local function on_attach(client, bufnr)
  require("spraints.lsp.keymaps").setup(client, bufnr)
end

function M.setup()
  local lsp_signature = require("lsp_signature")
  lsp_signature.setup {
    bind = true,
    handler_opts = {
      border = "rounded"
    }
  }

  require("mason").setup()

  require("mason-lspconfig").setup {
    ensure_installed = {
      "dockerls",
      "gopls",
      "rust_analyzer",
      "tsserver",
    },

    handlers = {
      function (server_name)
        require("lspconfig")[server_name].setup {
          flags = { debounce_text_changes = 150 },
          on_attach = on_attach
        }
      end,
    },
  }
end

return M
