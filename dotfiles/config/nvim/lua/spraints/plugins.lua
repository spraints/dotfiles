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
      "mason-org/mason.nvim",
      config = function()
        require("mason").setup()
      end,
    }

    use {
      "neovim/nvim-lspconfig",
      requires = {
        "mason-org/mason.nvim",
      },
      config = function()
        -- See https://vonheikemen.github.io/learn-nvim/feature/lsp-setup.html#lsp-defaults
        -- for keymaps.
        --
        -- See
        -- https://github.com/mjlbach/starter.nvim/blob/6a8329eb0874014bcde92e7f78fe3176595e5a45/init.lua#L225
        -- for more keymap ideas.
        vim.lsp.enable("gopls")
        vim.lsp.enable("rust_analyzer")
        vim.lsp.enable("ts_ls")
      end,
    }
  end

  local packer = require("packer")
  packer.startup(plugins)
end

return M
