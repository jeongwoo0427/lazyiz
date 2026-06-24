-- 현재 셀/코드블록을 통째로 실행 (커서만 안에 두면 됨, 범위 지정 불필요)
--  · python  : `# %%` 마커 사이
--  · markdown : ``` 코드펜스 안쪽 (펜스 줄 제외)
local function run_current_cell()
  local cur, last = vim.fn.line("."), vim.fn.line("$")
  local s, e

  if vim.bo.filetype == "markdown" then
    local fence = "^%s*```"
    local open
    for l = cur, 1, -1 do
      if vim.fn.getline(l):match(fence) then open = l break end
    end
    if not open then return end -- 코드블록 밖이면 무시
    s, e = open + 1, last
    for l = open + 1, last do
      if vim.fn.getline(l):match(fence) then e = l - 1 break end
    end
  else
    local marker = "^#%s*%%%%" -- "# %%" / "#%%"
    s = 1
    for l = cur, 1, -1 do
      if vim.fn.getline(l):match(marker) then s = l break end
    end
    e = last
    for l = s + 1, last do
      if vim.fn.getline(l):match(marker) then e = l - 1 break end
    end
  end

  if s > e then return end
  vim.fn.MoltenEvaluateRange(s, e)
end

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
              -- molten venv를 기본 분석 대상으로 (VenvSelect로 프로젝트별 변경 가능)
              pythonPath = vim.fn.expand("~/.venvs/molten/bin/python"),
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
      backend = "kitty", -- wezterm 쓰면 "kitty" 그대로 동작, iTerm2면 "ueberzug"로 변경
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
    dependencies = {
      "3rd/image.nvim",
      build = false,
      opts = {
        rocks = {
          enabled = false,
        },
      }
    },
    init = function()
      -- 출력 창 최대 높이
      vim.g.molten_output_win_max_height = 12
      -- 셀 실행하면 floating 출력창(<leader>mo) 자동으로 띄우기
      vim.g.molten_auto_open_output = true
      -- 커서가 셀 밖으로 나가면 출력창 닫기
      vim.g.molten_auto_close_output_windows = true
      -- 마크다운 렌더링
      vim.g.molten_use_border_highlights = true
      -- 이미지 렌더러: image.nvim 사용
      vim.g.molten_image_provider = "image.nvim"
      -- virt text 출력은 끔 (켜져 있으면 실행 시 floating 창이 자동으로 안 뜸 — moltenbuffer.py:120)
      vim.g.molten_virt_text_output = false
      vim.g.molten_virt_lines_off_by_1 = true

      -- 출력 virt text 색을 주황색으로 (기본은 Comment에 연결돼 회색이라 안 보임)
      -- ColorScheme 적용 후에 덮어써야 살아남음
      local function set_molten_hl()
        vim.api.nvim_set_hl(0, "MoltenVirtualText", { fg = "#ff9e64", bold = true })
      end
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_molten_hl })
      set_molten_hl()
    end,
    keys = {
      -- 커널 초기화 / 선택
      { "<leader>mi", ":MoltenInit<CR>", desc = "Molten: 커널 초기화", ft = { "python", "julia", "markdown" } },
      { "<leader>md", ":MoltenDeinit<CR>", desc = "Molten: 커널 종료", ft = { "python", "julia", "markdown" } },
      -- 셀 실행
      { "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "Molten: 범위 실행 (operator)", ft = { "python", "julia", "markdown" } },
      { "<leader>ml", ":MoltenEvaluateLine<CR>", desc = "Molten: 현재 줄 실행", ft = { "python", "julia", "markdown" } },
      { "<leader>mr", ":MoltenReevaluateCell<CR>", desc = "Molten: 셀 재실행", ft = { "python", "julia", "markdown" } },
      -- 현재 셀/코드블록 통째로 실행 (커서만 안에 두면 됨)
      { "<leader>mc", run_current_cell, desc = "Molten: 현재 셀 실행", ft = { "python", "julia", "markdown" } },
      -- 비주얼 모드 실행
      { "<leader>mv", ":<C-u>MoltenEvaluateVisual<CR>gv", desc = "Molten: 선택 영역 실행", mode = "v", ft = { "python", "julia", "markdown" } },
      -- 출력 창
      { "<leader>mo", ":MoltenShowOutput<CR>", desc = "Molten: 출력 표시", ft = { "python", "julia", "markdown" } },
      { "<leader>mh", ":MoltenHideOutput<CR>", desc = "Molten: 출력 숨기기", ft = { "python", "julia", "markdown" } },
      -- 셀 이동
      { "[c", ":MoltenPrev<CR>", desc = "Molten: 이전 셀", ft = { "python", "julia", "markdown" } },
      { "]c", ":MoltenNext<CR>", desc = "Molten: 다음 셀", ft = { "python", "julia", "markdown" } },
      -- 셀 삭제
      { "<leader>mx", ":MoltenDelete<CR>", desc = "Molten: 셀 삭제", ft = { "python", "julia", "markdown" } },
      -- 인터럽트 / 재시작
      { "<leader>ms", ":MoltenInterrupt<CR>", desc = "Molten: 실행 중단", ft = { "python", "julia", "markdown" } },
      { "<leader>mR", ":MoltenRestart!<CR>", desc = "Molten: 커널 재시작", ft = { "python", "julia", "markdown" } },
    },
  },
}
