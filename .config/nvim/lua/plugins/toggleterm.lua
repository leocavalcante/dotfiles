return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>co", function()
      local Terminal = require("toggleterm.terminal").Terminal
      local copilot_yolo = Terminal:new({
        cmd = "copilot --yolo",
        direction = "float",
        float_opts = {
          border = "curved",
        },
        close_on_exit = false,
        hidden = true,
        on_open = function(term)
          -- Map 'jj' in terminal mode to escape back to normal mode
          vim.api.nvim_buf_set_keymap(term.bufnr, "t", "jj", [[<C-\><C-n>]], { noremap = true, silent = true })
        end,
      })
      copilot_yolo:toggle()
    end, desc = "Copilot YOLO" },
  },
  opts = {},
}
