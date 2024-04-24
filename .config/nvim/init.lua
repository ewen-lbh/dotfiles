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
	"joerdav/templ.vim",
	{ "github/copilot.vim", 
      config = function()
			  vim.keymap.set('i', '<C-Space>', 'copilot#Accept("<CR>")', {
					  expr = true,
					  replace_keycodes = false
			  })
			  vim.g.copilot_no_tab_map = true
	  end
    },
	"L3MON4D3/LuaSnip",
	{ "hrsh7th/nvim-cmp",
	  dependencies = { "L3MON4D3/LuaSnip", "github/copilot.vim" },
	  config = function()
		local cmp = require("cmp")
		local snips = require("luasnip")
		local select_opts = { behavior = cmp.SelectBehavior.Select }
		cmp.setup({
				snippet = {
					expand = function(args)
						snips.lsp_expand(args.body)
					end,
				},
				sources = {
					{ name = "nvim_lsp", keyword_length = 1 },
					-- { name = "buffer", keyword_length = 3 }, annoying as hell lmao
					{ name = "path" },
				},
				mapping = {
						['<CR>'] = cmp.mapping.confirm({ select = true }),
						['<Tab>'] = cmp.mapping.confirm({ select = true }),
						['<Up>'] = cmp.mapping.select_prev_item(select_opts),
						['<Down>'] = cmp.mapping.select_next_item(select_opts),
						['<C-u>'] = cmp.mapping.scroll_docs(-4),
						['<C-d>'] = cmp.mapping.scroll_docs(4),
						['<C-e>'] = cmp.mapping.abort(),
				}
		})
	  end
    },
	-- "hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path",
	"hrsh7th/cmp-nvim-lsp",
	{ "neovim/nvim-lspconfig",
	dependencies = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-nvim-lsp" },
	config = function()
		local caps = require("cmp_nvim_lsp").default_capabilities()
		local conf = require("lspconfig")
		conf.yamlls.setup {
		    capabilities = caps,
			settings = {
				yaml = {
					validate = true,
					-- manually select schemas
					schemas = {
						['https://json.schemastore.org/kustomization.json'] = 'kustomization.{yml,yaml}',
						['https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json'] = 'docker-compose*.{yml,yaml}',
						["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json"] = "argocd-application.yaml",
					}
				}
			}
		}
		conf.lua_ls.setup({
				capapbilities = caps,
				settings = {
						Lua = {
								diagnostics = { globals = { "vim" } },
						}
				}
		})
		local servers = { 
				"pyright",
				"jsonls",
				"tsserver",
				"rust_analyzer",
				"ruby_lsp",
				"prismals",
				"nginx_language_server",
				"mdx_analyzer",
				"gopls",
				"templ",
		}
		for _, lsp in ipairs(servers) do
			conf[lsp].setup({ capabilities = caps })
		end
	end,

	},

})


-- Neovide
vim.g.neovide_padding_top = 20
vim.g.neovide_padding_bottom = 20
vim.g.neovide_padding_right = 20
vim.g.neovide_padding_left = 20
-- vim.o.guifont = "VictorMono:h8"

-- Prevent annoying flickering when no severity signs are shown
vim.opt.signcolumn = "number"

-- Regular settings
vim.opt.ts = 4
vim.opt.relativenumber = true
vim.opt.number = true

-- Copilot filtypes
vim.g.copilot_filetypes = {
	markdown = true
}

-- Theme
local system_colorscheme = io.open("/home/uwun/.config/colorscheme", "r"):read("*all"):gsub("%s+", "")
vim.cmd.colorscheme (system_colorscheme == "dark" and "catppuccin-mocha" or "catppuccin-latte")

-- Custom LSP UwU
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
		pattern = {"description.md", "*.yaml"},
		callback = function(event)
				print(string.format("starting ortfols for %s", vim.inspect(event)))
				vim.lsp.start {
						name = "ortfo",
						cmd = {"ortfodb", "-c", "/home/uwun/projects/portfolio/ortfodb.yaml", "lsp"},
						root_dir = vim.fs.dirname(
								vim.fs.find({'ortfodb.yaml'}, { upward = true })[1]
						),
				}
		end
})

-- LSP completions
vim.opt.completeopt = {"menu", "menuone", "noselect"}

-- LSP keybinds
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function()
    local bufmap = function(mode, lhs, rhs)
      local opts = {buffer = true}
      vim.keymap.set(mode, lhs, rhs, opts)
    end

    -- Displays hover information about the symbol under the cursor
    bufmap('n', 'gh', '<cmd>lua vim.lsp.buf.hover()<cr>')

    -- Jump to the definition
    bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')

    -- Jump to declaration
    bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')

    -- Lists all the implementations for the symbol under the cursor
    bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')

    -- Jumps to the definition of the type symbol
    bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

    -- Lists all the references 
    bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')

    -- Displays a function's signature information
    bufmap('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>')

    -- Renames all references to the symbol under the cursor
    bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')

    -- Selects a code action available at the current cursor position
    bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')

    -- Show diagnostics in a floating window
    bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')

    -- Move to the previous diagnostic
    bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')

    -- Move to the next diagnostic
    bufmap('n', '<F8>', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})
