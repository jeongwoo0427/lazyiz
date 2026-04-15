-- 현재 파일 기준으로 상위 디렉토리까지 venv 탐색
local function find_python()
  -- 1. 활성화된 venv 환경변수 우선
  local venv_env = os.getenv("VIRTUAL_ENV")
  if venv_env then
    return venv_env .. "/bin/python"
  end

  -- 2. 현재 버퍼 디렉토리에서 상위로 탐색
  local buf_dir = vim.fn.expand("%:p:h")
  if buf_dir == "" then
    buf_dir = vim.fn.getcwd()
  end

  for _, name in ipairs({ ".venv", "venv", "env" }) do
    local found = vim.fn.finddir(name, buf_dir .. ";")
    if found ~= "" then
      local python = vim.fn.fnamemodify(found, ":p") .. "bin/python"
      if vim.fn.executable(python) == 1 then
        return python
      end
    end
  end

  return "python3"
end

return {
  -- 가상환경 선택기
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
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
          -- pyright 시작 시 프로젝트 루트 기준으로 venv python 자동 설정
          on_new_config = function(config, root_dir)
            for _, name in ipairs({ ".venv", "venv", "env" }) do
              local python = root_dir .. "/" .. name .. "/bin/python"
              if vim.fn.executable(python) == 1 then
                config.settings = config.settings or {}
                config.settings.python = config.settings.python or {}
                config.settings.python.pythonPath = python
                break
              end
            end
          end,
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

  -- Python 테스트 (neotest-python)
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-python",
    },
    opts = {
      adapters = {
        ["neotest-python"] = {
          runner = "pytest",
          python = find_python,
        },
      },
    },
  },

  -- Python DAP (디버깅)
  {
    "mfussenegger/nvim-dap-python",
    -- stylua: ignore
    keys = {
      { "<leader>dPt", function() require("dap-python").test_method() end, desc = "Debug Method", ft = "python" },
      { "<leader>dPc", function() require("dap-python").test_class() end,  desc = "Debug Class",  ft = "python" },
    },
    config = function()
      require("dap-python").setup(find_python())
    end,
  },
}
