vim.keymap.set('n', '<Space>', '', {})
vim.g.mapleader = ' '

require("options")
require("plugins")

vim.keymap.set('n', 'bp', ':bprevious<CR>')
vim.keymap.set('n', 'bn', ':bnext<CR>')
vim.keymap.set('n', 'tp', ':tabprevious<CR>')
vim.keymap.set('n', 'tn', ':tabnext<CR>')
vim.keymap.set('n', '<Leader>nhl', ':nohlsearch<CR>')
vim.keymap.set('n', '<Leader>w', ':write<CR>')
vim.keymap.set('n', '<Leader>o', ':edit ')
vim.keymap.set('n', '<Leader>q', ':q<CR> ')

vim.cmd "filetype plugin indent on"
-- vim.cmd [[
--     au VimEnter * !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Escape'
--     au VimLeave * !xmodmap -e 'clear Lock' -e 'keycode 0x42 = Caps_Lock'
-- ]]

vim.api.nvim_create_autocmd("VimEnter", {
    pattern = "*",
    callback = function()
        vim.api.nvim_set_hl(0, "Normal", { bg = 'none'})
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = 'none'})
    end
})

require('lualine').setup {
    options = {
        icons_enabled = true,
        theme = 'auto'
    },
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename'},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    },
}
