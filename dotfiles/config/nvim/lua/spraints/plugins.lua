local M = {}

function M.setup()
  vim.pack.add({
    "https://github.com/junegunn/fzf",
    "https://github.com/junegunn/fzf.vim",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/neovim/nvim-lspconfig",
  })

  -- fzf's own install script builds the fzf binary; vim.pack has no
  -- build-hook field, so run it via the PackChanged event instead.
  vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(ev)
      local data = ev.data
      if data.spec.name == "fzf" and (data.kind == "install" or data.kind == "update") then
        vim.system({ "./install", "--all" }, { cwd = data.path }):wait()
      end
    end,
  })

  require("mason").setup()

  -- See https://vonheikemen.github.io/learn-nvim/feature/lsp-setup.html#lsp-defaults
  -- for keymaps.
  --
  -- See
  -- https://github.com/mjlbach/starter.nvim/blob/6a8329eb0874014bcde92e7f78fe3176595e5a45/init.lua#L225
  -- for more keymap ideas.
  vim.lsp.enable("gopls")
  vim.lsp.enable("protols")
  vim.lsp.enable("rust_analyzer")
  -- vim.lsp.enable("ts_ls")
  vim.lsp.enable("zls")
end

return M
