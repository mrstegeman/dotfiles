local dap = require("dap")
local dapui = require("dapui")
dapui.setup()

-- codelldb defaults; user can override via env CODELLDB_PATH and LLDB_LIBRARY
local codelldb_path = os.getenv("CODELLDB_PATH") or "/usr/local/bin/codelldb"
local lldb_lib = os.getenv("LLDB_LIBRARY")
  or "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB"
dap.adapters.codelldb = {
  type = "server",
  port = "${port}",
  executable = {
    command = codelldb_path,
    args = { "--port", "${port}" },
    env = { LLDB_LIBRARY = lldb_lib },
  },
}
dap.configurations.swift = {
  {
    name = "Debug Swift executable",
    type = "swift",
    request = "launch",
    program = function()
      if vim.g.swift_dap_executable then
        return vim.g.swift_dap_executable
      else
        vim.g.swift_dap_executable =
          vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/.build/debug/", "file")
      end

      return vim.g.swift_dap_executable
    end,
    cwd = "${workspaceFolder}",
    stopOnEntry = false,
    args = function()
      if vim.g.swift_dap_argv ~= nil then
        return vim.g.swift_dap_argv
      end

      local argv = {}
      local arg = vim.fn.input(string.format("Arguments: ", "", "file"))

      for a in string.gmatch(arg, "%S+") do
        table.insert(argv, a)
      end

      vim.g.swift_dap_argv = argv

      return argv
    end,
  },
}

-- Python debugpy
dap.adapters.python = {
  type = "executable",
  command = "python3",
  args = { "-m", "debugpy.adapter" },
}
dap.configurations.python = {
  {
    type = "python",
    request = "launch",
    name = "Launch file",
    program = "${file}",
    pythonPath = function()
      return vim.fn.input("Python path: ", "python3")
    end,
  },
}

-- Go (delve) if present
dap.adapters.go = {
  type = "server",
  host = "127.0.0.1",
  port = "${port}",
}

vim.keymap.set("n", "<F5>", function()
  require("dap").continue()
end)
vim.keymap.set("n", "<F10>", function()
  require("dap").step_over()
end)
vim.keymap.set("n", "<F11>", function()
  require("dap").step_into()
end)
vim.keymap.set("n", "<F12>", function()
  require("dap").step_out()
end)
vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>B", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Debug: Set Conditional Breakpoint" })

-- open Dap UI automatically when debug starts (e.g. after <F5>)
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end

-- close Dap UI with :DapCloseUI
vim.api.nvim_create_user_command("DapCloseUI", function()
  require("dapui").close()
end, {})

-- use <Alt-e> to eval expressions
vim.keymap.set({ "n", "v" }, "<M-e>", function()
  require("dapui").eval()
end)
