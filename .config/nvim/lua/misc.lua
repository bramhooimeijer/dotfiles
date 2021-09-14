-- Theme
require'lualine'.setup {
  options = {
    theme = 'ayu_dark'
  }
}

-- Enable treesitter syntax highlighting
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  highlight = {
    enable = true,              -- false will disable the whole extension
  },
}
