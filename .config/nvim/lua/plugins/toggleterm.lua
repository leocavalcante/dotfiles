return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>co", function()
      local Terminal = require("toggleterm.terminal").Terminal

      -- Reuse the same terminal instance across toggles
      if not _COPILOT_TERM then
        _COPILOT_TERM = Terminal:new({
          cmd = "copilot --allow-all --banner --disable-builtin-mcps --experimental --no-auto-update",
          direction = "float",
          float_opts = {
            border = "curved",
          },
          close_on_exit = false,
          hidden = true,
          on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, "t", "jj", [[<C-\><C-n>]], { noremap = true, silent = true })
          end,
        })
      end

      _COPILOT_TERM:toggle()
    end, desc = "Copilot YOLO" },
  },
  opts = {},
}

