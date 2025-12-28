-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map({ "n", "i", "v", "t" }, ";j", "<C-[>")
map({ "n", "v" }, "<leader>j", "10j", { desc = "Move bottom 10" })
map({ "n", "v" }, "<leader>k", "10k", { desc = "Move top 10" })
map({ "n", "v" }, "T", ":Bwipeout<CR>", { remap = true, desc = "Close buffer (Lsp safe)" }) -- 필수: "famiu/bufdelete.nvim" 설치 필요
map({ "n", "v" }, "<leader>t", "<C-/>", { remap = true, desc = "Terminal" })
map({ "n", "v" }, "<leader>l", vim.lsp.buf.format, { remap = true, desc = "Code Format" })
map({ "n", "i", "v" }, "<leader><Enter>", vim.lsp.buf.code_action, { remap = true, desc = "Code Action" })
map({ "i" }, "<leader>.", vim.lsp.buf.completion, { remap = true, desc = "Trigger completion" })
map({ "n" }, "<leader>.", vim.lsp.buf.signature_help, { remap = true, desc = "Signature help" })
map({ "n" }, "<leader>h", vim.lsp.buf.hover, { remap = true, desc = "Hover" })
map({ "n" }, "<leader>r", vim.lsp.buf.rename, { remap = true, desc = "Rename" })
map({ "n", "v" }, "<leader><leader>", "l", { remap = true, desc = "NONE" })

-- Noice 관련 키맵
map("n", "<leader>n", "", { remap = true, })
map("n", "<leader>nh", "<cmd>Noice history<CR>", { desc = "Noice history" })
map({ "n", "v" }, "<leader>nd", "<cmd>Noice dismiss<CR>", { desc = "Dismiss notifications" })

-- 여기에 d와 x가 클립보드에 복사되지 않도록 추가된 설정
map({ "n", "v" }, "d", '"_d', { desc = "Delete without yanking" })
map({ "n" }, "x", '"_x', { desc = "Delete character without yanking" })
map({ "n", "v" }, "D", '"_D', { desc = "Delete to end of line without yanking" })

-- 잘라내기는 오르직 이것 하나로
map({ "v" }, "x", "d", { desc = "Cut" })
