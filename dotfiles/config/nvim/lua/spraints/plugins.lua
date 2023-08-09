-- After changing anything in this file, you probably need to run
-- :PackerSync and choose N when asked about deleteing packer.nvim.
local M = {}

function M.setup()
  local function plugins()
    use {
      "junegunn/fzf",
      run = "./install --all",
      event = "VimEnter",
    }

    use {
      "junegunn/fzf.vim",
      event = "BufEnter",
    }

    use {
      "williamboman/mason.nvim",
    }

    use {
      "williamboman/mason-lspconfig.nvim",
      requires = {
        "williamboman/mason.nvim",
        "ray-x/lsp_signature.nvim",
      },
      config = function()
        require("spraints.lsp").setup()
      end,
    }

    use {
      "neovim/nvim-lspconfig",
      requires = {
        "william-bowman/mason.nvim",
        "williambowman/mason-lspconfig.nvim",
      },
    }
  end

  local packer = require("packer")
  packer.startup(plugins)
end

return M
