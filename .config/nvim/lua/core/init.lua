-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

require("core.options")
require("core.keymaps")
require("core.plugins")

require("core.lsp")
require("core.dap")
require("core.filetypes")
