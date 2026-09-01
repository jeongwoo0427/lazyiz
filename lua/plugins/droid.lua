-- Android (Kotlin/Compose) development.
--
-- Replaces the hand-rolled android.lua (:AndroidRun and friends) with
-- droid-nvim, which covers the same ground plus AVD management, scrcpy
-- mirroring, build variants and logcat filtering.
--
-- Command-driven, like :FlutterRun — no leader mappings. The <leader>a*
-- namespace droid-nvim's README suggests is already claudecode.nvim's.
--
--   :DroidRun            build, install and launch on the connected device
--   :DroidBuild          build a debug APK
--   :DroidBuildVariant   pick a build variant
--   :DroidInstall        install without launching
--   :DroidLogcat         tail logcat, filtered to this app
--   :DroidDevices        pick the target device
--   :DroidEmulator       start an AVD      :DroidMirror  scrcpy
--   :DroidSync :DroidClean :DroidTask :DroidUninstall

--- Drop "function name should start with a lowercase letter" on @Composable
--- functions, which are PascalCase by convention.
---
--- kotlin-lsp sends this one with no `code` field, so droid-nvim's
--- lsp.kotlin.suppress_diagnostics — which matches on the code — cannot reach
--- it. ktlint emits its own copy of the same warning; that one is handled
--- project-side in .editorconfig.
---
--- droid-nvim filters diagnostics by wrapping vim.diagnostic.set, so wrapping
--- it here too works whichever order the two wrappers end up in.
local function suppress_composable_naming()
  if vim.g.droid_composable_filter then
    return
  end
  vim.g.droid_composable_filter = true

  local set = vim.diagnostic.set
  vim.diagnostic.set = function(namespace, bufnr, diagnostics, opts)
    if diagnostics and #diagnostics > 0 and vim.api.nvim_buf_is_loaded(bufnr) then
      diagnostics = vim.tbl_filter(function(d)
        if not (d.message or ""):match("should start with a lowercase letter") then
          return true
        end
        -- The annotation sits a line or two above the reported function.
        local lnum = d.lnum or 0
        for _, line in ipairs(vim.api.nvim_buf_get_lines(bufnr, math.max(0, lnum - 5), lnum + 1, false)) do
          if line:match("@Composable") then
            return false
          end
        end
        return true
      end, diagnostics)
    end
    return set(namespace, bufnr, diagnostics, opts)
  end
end

return {
  {
    "rizukirr/droid-nvim",
    init = suppress_composable_naming,
    -- ft alone would leave the commands undefined until a source file is open,
    -- so the device/emulator ones are unreachable from a dashboard or terminal
    -- buffer. cmd stubs cover that.
    ft = { "kotlin", "java", "groovy", "xml" },
    cmd = {
      "DroidRun",
      "DroidBuild",
      "DroidBuildVariant",
      "DroidInstall",
      "DroidUninstall",
      "DroidClean",
      "DroidSync",
      "DroidTask",
      "DroidGradleStop",
      "DroidDevices",
      "DroidEmulator",
      "DroidEmulatorCreate",
      "DroidEmulatorStop",
      "DroidMirror",
      "DroidScreenshot",
      "DroidClearData",
      "DroidForceStop",
      "DroidLogcat",
      "DroidLogcatFilter",
      "DroidLogcatClear",
      "DroidLogcatStop",
      "DroidImports",
      "DroidFormat",
      "DroidRename",
      "DroidReferences",
      "DroidSymbols",
      "DroidWorkspaceSymbols",
      "DroidCodeAction",
      "DroidQuickFix",
      "DroidKdoc",
      "DroidHintsToggle",
      "DroidInlayHintsToggle",
      "DroidLspRestart",
      "DroidLspStop",
      "DroidLspLog",
      "DroidLspRefresh",
      "DroidCleanWorkspace",
      "DroidExportWorkspace",
    },
    dependencies = { "mason-org/mason.nvim" }, -- auto-installs kotlin-lsp
    opts = {
      lsp = {
        kotlin = {
          -- @Composable functions are PascalCase by convention, so the plain
          -- function-naming rule fires on them. ktlint's copy of that warning is
          -- handled project-side by .editorconfig
          -- (ktlint_function_naming_ignore_when_annotated_with = Composable).
          --
          -- kotlin-lsp emits its own copy intermittently, once analysis has
          -- fully settled. droid-nvim filters by diagnostic code, so read the
          -- code off a live one and add it here:
          --   :lua =vim.diagnostic.get(0)
          suppress_diagnostics = {},
        },
        -- Nothing here configures jdtls or the Groovy server; leave them on so
        -- Gradle build scripts still get a language server.
      },
      logcat = {
        mode = "horizontal",
        height = 15,
        filters = { package = "mine", log_level = "v" },
      },
    },
  },

  -- droid-nvim starts and owns the Kotlin LSP, so nothing else may.
  --
  -- LazyVim hands every server in opts.servers that it does not disable to
  -- mason-lspconfig's automatic_enable, which would start a second client with
  -- nvim-lspconfig's defaults and drop droid-nvim's settings. Disabling a
  -- server here is what puts it on LazyVim's mason_exclude list.
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- fwcd's server cannot resolve the Android classpath: every
        -- androidx/android symbol comes back "Unresolved reference". The
        -- lang.kotlin extra enables it, so turn it off again.
        kotlin_language_server = { enabled = false },
        -- JetBrains' kotlin-lsp — droid-nvim launches this one itself.
        kotlin_lsp = { enabled = false },
      },
    },
  },

  -- Highlighting for Kotlin sources, the manifest and Gradle files.
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, { "kotlin", "java", "xml", "groovy", "properties" })
    end,
  },
}
