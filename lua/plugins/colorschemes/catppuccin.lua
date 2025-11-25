return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000, -- Make sure to load this before all the other start plugins.
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require("catppuccin").setup {
        styles = {
          comments = { "italic" }, -- "italic" would enables italics in comments. Testing without. 
        },
      }

      -- Load the colorscheme here.
      -- Like many other themes, this one has different styles, and you could load
      -- any other, such as "catppuccin-latte" (light), "catppuccin-frappe" (dark, but slightly lighter), or "catppuccin-mocha" (dark).
      vim.cmd.colorscheme "catppuccin-macchiato"
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
