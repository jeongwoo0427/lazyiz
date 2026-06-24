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
  { -- 파일/코드 통째로 실행 (:FlutterRun 스타일, 언어 무관)
    "CRAG666/code_runner.nvim",
    cmd = { "RunCode", "RunFile", "RunProject", "RunClose" },
    opts = {
      -- 출력 표시 방식: "term"(하단 터미널) | "tab" | "toggleterm" | "float"
      mode = "term",
      focus = true,
      startinsert = false,
      term = {
        position = "bot", -- 하단에 열기
        size = 12,
      },
      filetype = {
        -- 언어별 실행 커맨드 (필요한 언어 여기에 추가)
        python = "python3 -u", -- -u: 출력 버퍼링 끄기 (실시간 출력)
        javascript = "node",
        sh = "bash",
      },
    },
    keys = {
      { "<leader>rr", "<cmd>RunFile<cr>",  desc = "Run: 현재 파일 실행" },
      { "<leader>rc", "<cmd>RunClose<cr>", desc = "Run: 출력창 닫기" },
    },
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
  { -- markdown/마크업 문서의 코드블록에 LSP 붙이기 (언어 무관: python/js/ts 등)
    "jmbuhr/otter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown" },
    config = function()
      local function activate()
        require("otter").activate() -- 인자 없음 = 문서에 있는 모든 언어 대상
      end
      vim.api.nvim_create_autocmd("FileType", { pattern = "markdown", callback = activate })
      -- 플러그인을 처음 로드시킨 버퍼는 FileType 이벤트가 이미 지나갔으므로 즉시 활성화
      if vim.bo.filetype == "markdown" then
        activate()
      end
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    ft = { "markdown" },
    opts = {},
  },
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    opts = {
      -- Server Configuration
      port_range = { min = 10000, max = 65535 },
      auto_start = true,
      log_level = "info", -- "trace", "debug", "info", "warn", "error"
      terminal_cmd = nil, -- Custom terminal command (default: "claude")
      -- For local installations: "~/.claude/local/claude"
      -- For native binary: use output from 'which claude'

      -- Send/Focus Behavior
      -- When true, successful sends will focus the Claude terminal if already connected
      focus_after_send = false,

      -- Selection Tracking
      track_selection = true,
      visual_demotion_delay_ms = 50,

      -- Terminal Configuration
      terminal = {
        split_side = "right", -- "left" or "right"
        split_width_percentage = 0.30,
        provider = "auto",    -- "auto", "snacks", "native", "external", "none", or custom provider table
        auto_close = true,
        snacks_win_opts = {}, -- Opts to pass to `Snacks.terminal.open()` - see Floating Window section below

        -- Provider-specific options
        provider_opts = {
          -- Command for external terminal provider. Can be:
          -- 1. String with %s placeholder: "alacritty -e %s" (backward compatible)
          -- 2. String with two %s placeholders: "alacritty --working-directory %s -e %s" (cwd, command)
          -- 3. Function returning command: function(cmd, env) return "alacritty -e " .. cmd end
          external_terminal_cmd = nil,
        },
      },

      -- Diff Integration
      diff_opts = {
        auto_close_on_accept = true,
        vertical_split = true,
        open_in_current_tab = true,
        keep_terminal_focus = true, -- If true, moves focus back to terminal after diff opens
      },
    },
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
