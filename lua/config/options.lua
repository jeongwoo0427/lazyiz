-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false -- 수정 마친 후 자동 정렬 활성 여부
vim.o.exrc = true        -- 프로젝트별.nvim.lua 자동 실행 여부
vim.o.secure = true      -- .nvim.lua 안의 위험한 명령어 (:!, :luafile) 자동 차단 여부
vim.o.mouse = ""

-- 시스템 클립보드와 동기화 설정
vim.opt.clipboard = "unnamedplus"

-- OSC 52를 사용하여 원격 복사 활성화 (Neovim 0.10+ 기준)
if vim.fn.has('wsl') == 0 and vim.fn.executable('pbcopy') == 0 and vim.fn.executable('xclip') == 0 and vim.fn.executable('wl-copy') == 0 then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
      ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
    },
    paste = {
      ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
      ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
    },
  }
end

