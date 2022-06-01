-- After changing anything in this file, you probably need to run
-- :PackerSync and choose N when asked about deleteing packer.nvim.
local M = {}

function M.setup()
  local function plugins()
    use {
      "neovim/nvim-lspconfig",
      -- opt = true,
      event = "BufReadPre",
      wants = { "nvim-lsp-installer", "lsp_signature.nvim" },
      config = function()
        require("spraints.lsp").setup()
      end,
      requires = {
        "williamboman/nvim-lsp-installer",
        "ray-x/lsp_signature.nvim",
      },
    }
  end

  local packer = require("packer")
  packer.startup(plugins)
end

return M
