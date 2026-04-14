return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          before_init = function(_, config)
            local venv = vim.fn.getcwd() .. "/.venv/bin/python"
            if vim.fn.executable(venv) == 1 then
              config.settings = config.settings or {}
              config.settings.python = config.settings.python or {}
              config.settings.python.pythonPath = venv
            end
          end,
        },
      },
    },
  },
}
