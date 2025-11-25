vim.bo.commentstring = "<!-- %s -->"

-- don't run vim ftplugin on top
vim.api.nvim_buf_set_var(0, "did_ftplugin", true)

-- markdown vs. quarto hacks
local ns = vim.api.nvim_create_namespace("QuartoHighlight")
vim.api.nvim_set_hl(ns, "@markup.strikethrough", { strikethrough = false })
vim.api.nvim_set_hl(ns, "@markup.doublestrikethrough", { strikethrough = true })
vim.api.nvim_win_set_hl_ns(0, ns)
