vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "telescope-fzf-native.nvim" and (kind == "install" or kind == "update") then
      vim.system({ "make" }, { cwd = ev.data.path })
    end
  end,
})

local packages = {
  { src = "https://github.com/folke/tokyonight.nvim" },
  { src = "https://github.com/akinsho/toggleterm.nvim" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- dependency
  { src = "https://github.com/nvim-lualine/lualine.nvim" },
  { src = "https://github.com/stevearc/conform.nvim" },
  { src = "https://github.com/mfussenegger/nvim-lint" },
  {
    src = "https://github.com/lukas-reineke/indent-blankline.nvim",
    version = vim.version.range("*"),
    name = "ibl",
  },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
  { src = "https://github.com/nvim-tree/nvim-tree.lua", version = vim.version.range("*") },
  {
    src = "https://github.com/neovim/nvim-lspconfig",
    version = vim.version.range("*"),
  },
  { src = "https://github.com/nvim-neotest/nvim-nio" }, -- dependency
  { src = "https://github.com/nvim-lua/plenary.nvim" }, -- dependency
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
  { src = "https://github.com/mfussenegger/nvim-dap" },
  { src = "https://github.com/nvim-neotest/neotest", version = vim.version.range("*") },
  {
    src = "https://github.com/fredrikaverpil/neotest-golang",
    version = vim.version.range("*"),
  },
  { src = "https://github.com/nvim-neotest/neotest-python" },
  { src = "https://github.com/nvim-neotest/neotest-jest" },
  { src = "https://github.com/rcarriga/nvim-dap-ui" },
  { src = "https://github.com/hrsh7th/cmp-nvim-lsp" },
  { src = "https://github.com/hrsh7th/cmp-buffer" },
  { src = "https://github.com/hrsh7th/cmp-path" },
  { src = "https://github.com/hrsh7th/cmp-cmdline" },
  { src = "https://github.com/hrsh7th/nvim-cmp" },
  { src = "https://github.com/apple/pkl-neovim" },
  { src = "https://github.com/Darazaki/indent-o-matic" },
  -- { src = "https://codeberg.org/mmllr/neotest-swift-testing" },
}

vim.pack.add(packages)

-- tokyonight setup
require("tokyonight").setup({})
vim.cmd.colorscheme("tokyonight")

-- toggleterm setup
require("toggleterm").setup({})

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set("t", "<esc>", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
  vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- lualine setup
require("lualine").setup({
  options = { theme = "auto" },
})

-- conform setup
require("conform").setup({
  format_on_save = {
    timeout_ms = 5000,
    lsp_format = "fallback",
  },
  formatters_by_ft = {
    c = { "clang-format" },
    cpp = { "clang-format" },
    dockerfile = { "dockerfmt" },
    go = { "goimports", "gofmt" },
    javascript = { "eslint_d" },
    lua = { "stylua" },
    markdown = { "rumdl" },
    objc = { "clang-format" },
    pkl = { "pkl" },
    python = { "ruff_fix", "ruff_format", "ruff_organize_import" },
    swift = { "swift" },
    toml = { "tombi" },
    typescript = { "eslint_d" },
    ["*"] = { "trim_whitespace", "trim_newlines" },
  },
  formatters = {
    ["clang-format"] = {
      prepend_args = { "-style=file", "-fallback-style=WebKit" },
    },
    ["dockerfmt"] = {
      prepend_args = { "-n" },
    },
  },
})

vim.keymap.set("n", "<leader>f", function()
  require("conform").format({ bufnr = 0 })
end)

-- lint setup
local lint = require("lint")

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()
    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()
  end,
})

lint.linters_by_ft = {
  go = { "golangcilint" },
  javascript = { "eslint_d" },
  javascriptreact = { "eslint_d" },
  markdown = { "rumdl" },
  python = { "ruff" },
  typescript = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  swift = { "swift-format" },
}

lint.linters["swift-format"] = function()
  return {
    cmd = "swift-format",
    args = { "lint", "-" },
    stdin = true,
    parser = require("lint.parser").from_pattern(
      "^([^:]+):(%d+):(%d+): (%w+): (.*)$",
      { "filename", "lnum", "col", "severity", "message" },
      {
        error = vim.diagnostic.severity.ERROR,
        hint = vim.diagnostic.severity.HINT,
        info = vim.diagnostic.severity.INFO,
        warning = vim.diagnostic.severity.WARN,
      },
      { ["source"] = "swift-format" }
    ),
    stream = "both",
    ignore_exitcode = true,
  }
end

-- ibl setup
require("ibl").setup()

-- telescope setup
require("telescope").setup({})
require("telescope").load_extension("fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope: Files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope: Live grep" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope: Buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Telescope: Help tags" })

-- tree setup
require("nvim-tree").setup({})

vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer" })

-- treesitter setup
vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == "nvim-treesitter" and kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

require("nvim-treesitter").setup({})

local langs = {
  "go",
  "javascript",
  "jsx",
  "typescript",
  "tsx",
  "python",
  "pkl",
  "swift",
}

require("nvim-treesitter").install(langs)

-- neotest setup
require("neotest").setup({
  adapters = {
    require("neotest-golang")(),
    require("neotest-jest")({
      jestCommand = "npm test --",
      jestConfigFile = "jest.config.mjs",
      extensions = { "js", "jsx", "ts", "tsx" },
    }),
    require("neotest-python")({}),
    -- require("neotest-swift-testing")({}),
  },
  quickfix = {
    open = true,
  },
})

-- bridge neotest and dap: open dapui when debugging tests
local dap = require("dap")
dap.listeners.after.event_initialized["neotest_dap"] = function()
  require("dapui").open()
end
dap.listeners.before.event_terminated["neotest_dap"] = function()
  require("dapui").close()
end
dap.listeners.before.event_exited["neotest_dap"] = function()
  require("dapui").close()
end

vim.keymap.set("n", "<leader>tr", function()
  require("neotest").run.run({
    suite = false,
    testify = true,
  })
end, { desc = "Neotest: Run nearest test" })

vim.keymap.set("n", "<leader>tv", function()
  require("neotest").summary.toggle()
end, { desc = "Neotest: Toggle summary" })

vim.keymap.set("n", "<leader>ts", function()
  require("neotest").run.run({
    suite = true,
    testify = true,
  })
end, { desc = "Neotest: Run test suite" })

vim.keymap.set("n", "<leader>ta", function()
  require("neotest").run.run(vim.fn.getcwd())
end, { desc = "Neotest: Run all tests" })

vim.keymap.set("n", "<leader>td", function()
  require("neotest").run.run({
    suite = false,
    testify = true,
    strategy = "dap",
  })
end, { desc = "Neotest: Debug nearest test" })

vim.keymap.set("n", "<leader>to", function()
  require("neotest").output_panel.open()
end, { desc = "Neotest: Open test output" })

-- cmp setup
local cmp = require("cmp")
cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<tab>"] = cmp.mapping(function(original)
      if cmp.visible() then
        cmp.select_next_item() -- run completion selection if completing
      else
        original() -- run the original behavior if not completing
      end
    end, { "i", "s" }),
    ["<S-tab>"] = cmp.mapping(function(original)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        original()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
  }, {
    { name = "buffer" },
  }),
})

-- pkl setup
require("pkl-neovim").init()

-- indent-o-matic setup
require("indent-o-matic").setup({})
