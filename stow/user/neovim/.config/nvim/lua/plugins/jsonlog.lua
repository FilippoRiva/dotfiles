return {
  "ll931217/jsonlogs.nvim",
  ft = "jsonl", -- Lazy load on .jsonl files
  opts = {
    -- Custom configuration (optional)
    prefix = "<leader>jl",
    auto_open = true,
  },
  keys = {
    { "<leader>jl", "<cmd>JsonLogs<CR>", desc = "Open JSONL viewer" },
  },
}
