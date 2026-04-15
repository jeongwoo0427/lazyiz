return {
  -- 가상환경 선택기
  {
    "linux-cultist/venv-selector.nvim",
    branch = "main",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    cmd = "VenvSelect",
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
      },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv", ft = "python" },
    },
  },

  -- pyright: 외부 라이브러리 코드 추적 + venv 자동 감지
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          settings = {
            python = {
              analysis = {
                useLibraryCodeForTypes = true,
                autoImportCompletions = true,
                diagnosticMode = "workspace",
              },
            },
          },
        },
      },
    },
  },

  -- 인라인 이미지 렌더링 (matplotlib 그래프 등)
  -- wezterm / kitty / iTerm2 터미널 사용 시 이미지 표시 가능
  {
    "3rd/image.nvim",
    lazy = true,
    opts = {
      backend = "kitty",       -- wezterm 쓰면 "kitty" 그대로 동작, iTerm2면 "ueberzug"로 변경
      integrations = {},
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
    },
  },

  -- Jupyter 커널 연동 (molten-nvim)
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",
    build = ":UpdateRemotePlugins",
    dependencies = { "3rd/image.nvim" },
    init = function()
      -- 출력 창 최대 높이
      vim.g.molten_output_win_max_height = 12
      -- 셀 실행 후 자동으로 출력창 열기
      vim.g.molten_auto_open_output = false
      -- 커서가 셀 밖으로 나가면 출력창 닫기
      vim.g.molten_auto_close_output_windows = true
      -- 마크다운 렌더링
      vim.g.molten_use_border_highlights = true
      -- 이미지 렌더러: image.nvim 사용
      vim.g.molten_image_provider = "image.nvim"
      -- 가상 텍스트로 셀 구분선 표시
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    keys = {
      -- 커널 초기화 / 선택
      { "<leader>mi", ":MoltenInit<CR>",                              desc = "Molten: 커널 초기화",         ft = { "python", "julia" } },
      { "<leader>md", ":MoltenDeinit<CR>",                           desc = "Molten: 커널 종료",           ft = { "python", "julia" } },
      -- 셀 실행
      { "<leader>me", ":MoltenEvaluateOperator<CR>",                 desc = "Molten: 범위 실행 (operator)", ft = { "python", "julia" } },
      { "<leader>ml", ":MoltenEvaluateLine<CR>",                     desc = "Molten: 현재 줄 실행",        ft = { "python", "julia" } },
      { "<leader>mr", ":MoltenReevaluateCell<CR>",                   desc = "Molten: 셀 재실행",           ft = { "python", "julia" } },
      -- 비주얼 모드 실행
      { "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv",            desc = "Molten: 선택 영역 실행",      mode = "v",                 ft = { "python", "julia" } },
      -- 출력 창
      { "<leader>mo", ":MoltenShowOutput<CR>",                       desc = "Molten: 출력 표시",           ft = { "python", "julia" } },
      { "<leader>mh", ":MoltenHideOutput<CR>",                       desc = "Molten: 출력 숨기기",         ft = { "python", "julia" } },
      -- 셀 이동
      { "[c",         ":MoltenPrev<CR>",                             desc = "Molten: 이전 셀",             ft = { "python", "julia" } },
      { "]c",         ":MoltenNext<CR>",                             desc = "Molten: 다음 셀",             ft = { "python", "julia" } },
      -- 셀 삭제
      { "<leader>mx", ":MoltenDelete<CR>",                           desc = "Molten: 셀 삭제",             ft = { "python", "julia" } },
      -- 인터럽트 / 재시작
      { "<leader>ms", ":MoltenInterrupt<CR>",                        desc = "Molten: 실행 중단",           ft = { "python", "julia" } },
      { "<leader>mR", ":MoltenRestart!<CR>",                         desc = "Molten: 커널 재시작",         ft = { "python", "julia" } },
    },
  },
}
