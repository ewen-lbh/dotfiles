-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
	{ "catppuccin/nvim", name = "catppuccin", priority = 1000 },
	"wakatime/vim-wakatime",
	"github/copilot.vim",
})


-- Neovide
vim.g.neovide_padding_top = 20
vim.g.neovide_padding_bottom = 20
vim.g.neovide_padding_right = 20
vim.g.neovide_padding_left = 20
-- vim.o.guifont = "VictorMono:h8"

-- Copilot filtypes
vim.g.copilot_filetypes = {
	markdown = true
}

-- Theme
local system_colorscheme = io.open("/home/uwun/.config/colorscheme", "r"):read("*all"):gsub("%s+", "")
vim.cmd.colorscheme (system_colorscheme == "dark" and "catppuccin-mocha" or "catppuccin-latte")
