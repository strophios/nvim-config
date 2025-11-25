return {
  { -- Opening dashboard, allows for easy resumption of saved sessions
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require "alpha"
      local dashboard = require "alpha.themes.dashboard"

      -- Set header
      -- dashboard.section.header.val = {}

      -- Set menu
      dashboard.section.buttons.val = {
        dashboard.button("e", "  > New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("f", "󰈞  > Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "  > Recent", ":Telescope oldfiles<CR>"),
        dashboard.button("w", "󰙅  > Session list", ":SessionManager load_session<CR>"),
        dashboard.button("s", "  > Settings", ":e $MYVIMRC | :cd %:p:h<cr>"),
        dashboard.button("q", "󰅚  > Quit NVIM", ":qa<CR>"),
      }

      -- Send config to alpha
      alpha.setup(dashboard.opts)
    end,
  },
  { -- Easy buffer management
    "j-morano/buffer_manager.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    keys = {
      {
        "<leader>bb",
        function()
          require("buffer_manager.ui").toggle_quick_menu()
        end,
        desc = "Open buffer manager",
      },
    },
  },
  { -- File tree within neovim 
    "nvim-neo-tree/neo-tree.nvim",
    version = "*",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    keys = {
      { "\\", ":Neotree reveal position=float<CR>", desc = "NeoTree reveal", silent = true },
      { "<C-\\>", ":Neotree position=float<CR>", desc = "NeoTree float browser", silent = true },
    },
    opts = {
      filesystem = {
        window = {
          mappings = {
            ["\\"] = "close_window",
          },
        },
      },
    }, 
  },
  { -- Convenient session management based on base neovim capabilities 
    "Shatur/neovim-session-manager",
    dependencies = "nvim-lua/plenary.nvim",
    cmd = "SessionManager",
    keys = {
      {
        "<leader>wS",
        "<cmd>SessionManager save_current_session<cr>",
        desc = "[W]orkspace: [S]ave current session (and modified buffers)",
      },
      {
        "<leader>ws",
        "<cmd>SessionManager! save_current_session<cr>",
        desc = "[W]orkspace: [s]ave current session (not modified buffers)",
      },
      {
        "<leader>wL",
        "<cmd>SessionManager load_session<cr>",
        desc = "[W]orkspace: [L]oad session (save modified buffers)",
      },
      {
        "<leader>wl",
        "<cmd>SessionManager! load_session<cr>",
        desc = "[W]orkspace: [l]oad session (don't save modified buffers)",
      },
    },
    config = true, 
  },


}
