-- formatting
vim.keymap.set("n", "<leader>F", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format text" })

vim.api.nvim_create_user_command("PackUpdate", function()
  vim.pack.update()
end, { nargs = 0, desc = "Update vim.pack plugins." })
