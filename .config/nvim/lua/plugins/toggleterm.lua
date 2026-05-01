return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>z", function()
      local Terminal = require("toggleterm.terminal").Terminal

      if not _ZSH_TERM then
        _ZSH_TERM = Terminal:new({
          cmd = "zsh",
          dir = vim.fn.getcwd(),
          direction = "float",
          float_opts = {
            border = "curved",
          },
          close_on_exit = true,
          hidden = true,
          env = { TMUX = vim.env.TMUX, TMUX_PANE = vim.env.TMUX_PANE },
          on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, "t", "jj", [[<C-\><C-n>]], { noremap = true, silent = true })
          end,
          on_exit = function(term)
            term:close()
            _ZSH_TERM = nil
          end,
        })
      end

      _ZSH_TERM:toggle()
    end, desc = "Zsh" },
    { "<leader>ico", function()
      local Terminal = require("toggleterm.terminal").Terminal

      -- Reuse the same terminal instance across toggles
      if not _COPILOT_TERM then
        _COPILOT_TERM = Terminal:new({
          cmd = "copilot --allow-all --banner --disable-builtin-mcps --experimental --no-auto-update",
          direction = "float",
          float_opts = {
            border = "curved",
          },
          close_on_exit = true,
          hidden = true,
          on_open = function(term)
            vim.api.nvim_buf_set_keymap(term.bufnr, "t", "jj", [[<C-\><C-n>]], { noremap = true, silent = true })
          end,
          on_exit = function(term)
            term:close()
            _COPILOT_TERM = nil
          end,
        })
      end

      _COPILOT_TERM:toggle()
    end, desc = "Copilot" },
  },
  opts = {},
}

