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

-- UltiSnips
vim.g.UltiSnipsExpandTrigger = "<tab>"
vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"


-- Plugins
require("lazy").setup({
	{ 
		"catppuccin/nvim", 
		name = "catppuccin", 
		priority = 1000 
	},
	{ 
		"nvim-telescope/telescope.nvim", 
		version = "0.1.0", 
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	{ 
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" }
	},
	-- { 
	-- 	"nvim-treesitter/nvim-treesitter",
	-- 	build = function()
	-- 		local ts_update = require('nvim-treesitter.install').update{ with_sync = true }
	-- 		ts_update()
	-- 	end
	-- },
	-- "nvim-treesitter/playground",
	"theprimeagen/harpoon",
	"theprimeagen/refactoring.nvim",
	"mbbill/undotree",
	"tpope/vim-fugitive",
	-- "nvim-treesitter/nvim-treesitter-context",
	-- {
	-- 	"VonHeikemen/lsp-zero.nvim",
	-- 	dependencies = {
	-- 	  -- LSP Support
	-- 	  'neovim/nvim-lspconfig',
	-- 	  'williamboman/mason.nvim',
	-- 	  'williamboman/mason-lspconfig.nvim',

	-- 	  -- Autocompletion
	-- 	  -- 'hrsh7th/nvim-cmp',
	-- 	  -- 'hrsh7th/cmp-buffer',
	-- 	  -- 'hrsh7th/cmp-path',
	-- 	  -- 'saadparwaiz1/cmp_luasnip',
	-- 	  -- 'hrsh7th/cmp-nvim-lsp',
	-- 	  -- 'hrsh7th/cmp-nvim-lua',

	-- 	  -- Snippets
	-- 	  -- 'L3MON4D3/LuaSnip',
	-- 	  -- 'rafamadriz/friendly-snippets',
	-- 	}
	-- },

	"folke/zen-mode.nvim",
	-- "eandrju/cellular-automaton.nvim",
	"laytan/cloak.nvim",
	"mattn/emmet-vim",
	-- "github/copilot.vim",
	"lervag/vimtex",
	"SirVer/ultisnips",
})

-- Emmet
vim.g.user_emmet_install_global = 0
vim.api.nvim_create_autocmd('FileType', {pattern= {"html","css","xml" }, command = "EmmetInstall"})

-- Copilot
-- vim.g.copilot_no_tab_map = true
-- vim.api.nvim_set_keymap("i", "<C-J>", "copilot#Accept('<CR>')", { silent = true, expr = true })

-- Neovide
vim.g.neovide_padding_top = 20
vim.g.neovide_padding_bottom = 20
vim.g.neovide_padding_right = 20
vim.g.neovide_padding_left = 20
vim.o.guifont = "VictorMono:h8"

-- Theme
local system_colorscheme = io.open(os.getenv("HOME") .. "/.config/colorscheme", "r"):read("*all"):gsub("%s+", "")
vim.cmd.colorscheme (system_colorscheme == "dark" and "catppuccin-mocha" or "catppuccin-latte")

-- Keybindings
require "keybindings"

-- Cloak
require("cloak").setup({
  enabled = true,
  cloak_character = "*",
  -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
  highlight_group = "Comment",
  patterns = {
    {
      -- Match any file starting with ".env".
      -- This can be a table to match multiple file patterns.
      file_pattern = {
          ".env*",
          "wrangler.toml",
          ".dev.vars",
      },
      -- Match an equals sign and any character after it.
      -- This can also be a table of patterns to cloak,
      -- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
      cloak_pattern = "=.+"
    },
  },
})

-- Refactoring
require('refactoring').setup({})

-- LSPs
-- require "lsp"

-- Treesitter
-- require'nvim-treesitter.configs'.setup {
--   -- A list of parser names, or "all"
--   ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "rust" },
-- 
--   -- Install parsers synchronously (only applied to `ensure_installed`)
--   sync_install = false,
-- 
--   -- Automatically install missing parsers when entering buffer
--   -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
--   auto_install = true,
-- 
--   highlight = {
--     -- `false` will disable the whole extension
--     enable = true,
-- 
--     -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
--     -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
--     -- Using this option may slow down your editor, and you may see some duplicate highlights.
--     -- Instead of true it can also be a list of languages
--     additional_vim_regex_highlighting = false,
--   },
-- }

