-- Add an empty ".minimal" file to only load minimal plugins
-- touch ~/.config/nvim/.minimal
vim.g.minimal = (vim.uv or vim.loop).fs_stat(vim.fn.stdpath("config") .. "/.minimal") ~= nil

require("config")
