return {
  {
    "lervag/vimtex",
    -- VimTeX should load at startup; filetype detection handles the rest.
    lazy = false,
    init = function()
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_compiler_latexmk = {
        out_dir = "out",
      }
      vim.g.vimtex_view_method = "zathura"
    end,
  },
}
