return {
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        sources = {
          explorer = {
            hidden = true, -- show dotfiles
            ignored = true, -- show gitignored files
          },
          files = {
            hidden = true, -- show dotfiles in file searches (including smart)
            ignored = true, -- include gitignored files in file searches
          },
          grep = {
            hidden = true, -- show dotfiles in file searches (including smart)
            ignored = true, -- include gitignored files in file searches
          },
        },
      },
    },
  },
}
