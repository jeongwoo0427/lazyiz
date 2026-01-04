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
    event = { "InsertLeave", "TextChanged" },
    opts = {
      execution_message = {
        enabled = false
      }
    }
  },
  { -- 모든 파일 표시하기
    "folke/snacks.nvim",
    opts = {
      picker = {
        hidden = true,  -- for hidden files
        ignored = true, -- for .gitignore files
      },
    },
  },
  { -- Git support
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",         -- required
      "sindrets/diffview.nvim",        -- Diff integration
      -- Only one of these is needed.
      "nvim-telescope/telescope.nvim", -- optional
      "ibhagwan/fzf-lua",              -- optional
      "nvim-mini/mini.pick",           -- optional
      "folke/snacks.nvim",             -- optional
    },
  },
}
