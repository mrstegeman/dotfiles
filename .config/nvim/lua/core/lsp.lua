local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = vim.lsp.protocol.make_client_capabilities()
if cmp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    -- common keymaps per buffer
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "LSP: Hover", buffer = args.buf })
    vim.keymap.set(
      "n",
      "gd",
      vim.lsp.buf.definition,
      { desc = "LSP: Go to definition", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "gD",
      vim.lsp.buf.declaration,
      { desc = "LSP: Go to declaration", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "gi",
      vim.lsp.buf.implementation,
      { desc = "LSP: Go to implementation", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "gr",
      vim.lsp.buf.references,
      { desc = "LSP: Show references", buffer = args.buf }
    )
    vim.keymap.set(
      "n",
      "gs",
      vim.lsp.buf.signature_help,
      { desc = "LSP: Signature help", buffer = args.buf }
    )
    vim.keymap.set("n", "gn", vim.lsp.buf.rename, { desc = "LSP: Rename", buffer = args.buf })
    vim.keymap.set(
      "n",
      "<leader>sd",
      vim.diagnostic.open_float,
      { desc = "LSP: Show current diagnostic", buffer = args.buf }
    )

    -- format on save if supported
    -- if client.server_capabilities.documentFormattingProvider then
    --   vim.api.nvim_create_autocmd("BufWritePre", {
    --     buffer = args.buf,
    --     callback = function()
    --       vim.lsp.buf.format({ args.buf = bufnr })
    --     end,
    --   })
    -- end
  end,
})

-- Lua
vim.lsp.config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      format = {
        enable = true,
        defaultConfig = {
          indent_style = "space",
          indent_size = "2",
        },
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {
          "vim",
          "require",
        },
      },
    },
  },
})
vim.lsp.enable("lua_ls")

-- Python
vim.lsp.config("ty", { capabilities = capabilities })
vim.lsp.enable("ty")
vim.lsp.config("ruff", { capabilities = capabilities })
vim.lsp.enable("ruff")

-- TypeScript
vim.lsp.config("vtsls", { capabilities = capabilities })
vim.lsp.enable("vtsls")

-- Go
vim.lsp.config("gopls", { capabilities = capabilities })
vim.lsp.enable("gopls")

-- Swift (sourcekit-lsp)
vim.lsp.config("sourcekit", { capabilities = capabilities })
vim.lsp.enable("sourcekit")

-- TOML
vim.lsp.config("tombi", { capabilities = capabilities })
vim.lsp.enable("tombi")

-- Markdown
vim.lsp.config("rumdl", { capabilities = capabilities })
vim.lsp.enable("rumdl")

-- Harper (grammar checker)
vim.lsp.config("harper_ls", { capabilities = capabilities })
vim.lsp.enable("harper_ls")

-- pkl
vim.g.pkl_neovim = {
  start_command = { "pkl-lsp" },
  pkl_cli_path = "/opt/homebrew/bin/pkl",
}

-- diagnostics
-- :help diagnostic-defaults
vim.diagnostic.config({
  -- update_in_insert = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
  -- virtual_lines = true,
})
