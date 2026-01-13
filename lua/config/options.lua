-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false -- 수정 마친 후 자동 정렬 활성 여부
vim.o.exrc = true        -- 프로젝트별.nvim.lua 자동 실행 여부
vim.o.secure = true      -- .nvim.lua 안의 위험한 명령어 (:!, :luafile) 자동 차단 여부
vim.o.mouse = ""

-- 서버에서 로컬로의 복사(OSC 52)는 허용하되, 붙여넣기는 서버 내부 기록을 사용하여 보안과 속도를 챙기는 반자동 클립보드 공유 설정.
vim.o.clipboard = "unnamedplus"

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}
