return {
	{ -- 필수: (Bwipeout)으로 버퍼 안전하게 닫기 (Lsp 유지용)
		"famiu/bufdelete.nvim",
	},
	{ -- Default colorscheme
		"LazyVim/LazyVim",
		opts = {
			colorscheme = "tokyonight-day"
		}
	},
	{ -- Auto Save
		"okuuva/auto-save.nvim",
		event = {"InsertLeave", "TextChanged"},
		opts = {
			execution_message = {
				enabled = false
			}
		}
	},
	{ -- Git support
	    "NeogitOrg/neogit",
	    dependencies = {
		    "nvim-lua/plenary.nvim",  -- required
		    "sindrets/diffview.nvim", -- Diff integration
		-- Only one of these is needed.
	    "nvim-telescope/telescope.nvim", -- optional
	    "ibhagwan/fzf-lua",              -- optional
	    "nvim-mini/mini.pick",           -- optional
	    "folke/snacks.nvim",             -- optional
	    },
	},
}
