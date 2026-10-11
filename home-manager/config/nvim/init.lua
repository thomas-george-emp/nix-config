vim.g.mapLeader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.o.termguicolors = true
vim.o.number = true
vim.o.expandtab = true
vim.o.shiftwidth = 2

-- Theme
vim.o.background = "dark"
vim.cmd.colorscheme("gruvbox-flat")

-- Syntax highlighting via treesitter
vim.api.nvim_create_autocmd("FileType", {
  callback = function(args) pcall(vim.treesitter.start, args.buf) end,
})

-- LSP
vim.lsp.config("lua_ls", {
  settings = { Lua = { diagnostics = { globals = { "vim" } } } },
})
vim.lsp.enable({
  "lua_ls",
  "nil_ls",
  "clangd",
  "rust_analyzer",
  "zls",
  "jdtls",
  "pyright",
})

-- Formatting
require("conform").setup({
  formatters_by_ft = {
    lua    = { "stylua" },
    nix    = { "nixfmt" },
    c      = { "clang-format" },
    cpp    = { "clang-format" },
    rust   = { "rustfmt" },
    zig    = { "zigfmt" },
    java   = { "google-java-format" },
    python = { "ruff_format" },
  },
  format_on_save = { timeout_ms = 1000, lsp_format = "fallback" },
})
