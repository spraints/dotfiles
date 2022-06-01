local util = require("packer.util")

local function setup()
  -- local fn = vim.fn
  -- local bootstrap = not fn.filereadable(util.join_paths(fn.stdpath('config'), 'plugin', 'packer_compiled.lua'))
  local packer = require("packer")
  packer.init(packer_conf)
  packer.startup(packer_plugins)
  -- if bootstrap then
  --   print "You'll need to restart Neovim to use plugins"
  --   require("packer").sync()
  -- end
end

local packer_conf = {
  profile = {
    enable = true,
    threshold = 50,
  },
  display = {
    open_fn = function()
      return util.float { border = "rounded" }
    end
  }
}

-- After changing anything here, you'll want to run :PackerSync.
function packer_plugins()
  use { "wbthomason/packer.nvim" }

  use {
    "neovim/nvim-lspconfig",
    opt = true,
    event = "BufReadPre",
    -- wants = { "nvim-lsp-installer", "lsp_signature.nvim", "cmp-nvim-lsp" },  -- for nvim-cmp
    wants = { "nvim-lsp-installer", "lsp_signature.nvim" },
    config = config_lsp,
    requires = {
      "williamboman/nvim-lsp-installer",
      "ray-x/lsp_signature.nvim",
    },
  }
end

function config_lsp()
  local function on_attach(client, buffer)
    -- vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    vim.api.nvim_buf_set_option(0, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    -- require("config.lsp.keymaps").setup(client, bufnr)
  end

  install_lsp({
    gopls = {},
    html = {},
    rust_analyzer = {},
    tsserver = {},
  }, {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    },
  })
end

function install_lsp(servers, options)
  local lsp_install_servers = require "nvim-lsp-installer.servers"

  for server_name, server_opts in pairs(servers) do
    print("Setting up " .. server_name)
    local server_available, server = lsp_installer_servers.get_server(server_name)

    if server_available then
      server:on_ready(function()
        local opts = vim.tbl_deep_extend("force", options, server_opts)
        server:setup(opts)
      end)

      if not server:is_installed() then
        server:install()
      end
    else
      print("Server not available: " .. server_name)
    end
  end
end

setup()
