-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.autoformat = false -- 수정 마친 후 자동 정렬 활성 여부
vim.o.exrc = true -- 프로젝트별.nvim.lua 자동 실행 여부 
vim.o.secure = true -- .nvim.lua 안의 위험한 명령어 (:!, :luafile) 자동 차단 여부
vim.o.mouse = ""

