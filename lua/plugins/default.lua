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
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    keys = {
      { "<leader>a",  nil,                              desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
      },
      -- Diff management
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
    },
  }
  -- { -- Terminal screen plugin
  --   "folke/snacks.nvim",
  --   opts = {
  --     terminal = {
  --       win = {
  --         position = "right", -- bottom에서 right로 변경
  --         width = 0.4,        -- 화면의 40% 너비
  --       },
  --     },
  --   },
  -- },
}
