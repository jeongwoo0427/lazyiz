return {
  { -- Flutter support
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim", -- optional
    },
    config = function()
      require("flutter-tools").setup({
        flutter_path = "/Path/to/flutter",
        dev_tools = {
          autostart = true,
          auto_open_browser = true,
        },
        fvm = false, -- FVM 사용시 경로 변경 필수
        dev_log = {
          enabled = true,
          notify_errors = true,
          open_cmd = "15split",
          focus_on_open = false,
        },
        debugger = {
          enabled = false, -- DAP 사용할 경우 true
          run_via_dap = false,
          exception_breakpoints = {},
        },
        lsp = {               -- LanguageServerProtocol 관련 설정
          settings = {
            lineLength = 120, -- 코 정리시 라인 길이 기준
          }
        },
      }) -- 기본 설정으로 실행
    end
  },
}
