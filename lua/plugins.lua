vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
    -- nvim uninstall itself without this, lel
    use 'wbthomason/packer.nvim'
    use {'morhetz/gruvbox', config = function() vim.cmd.colorscheme("gruvbox") end }
    use 'mattn/emmet-vim'
    use 'tpope/vim-rails'
    use 'tpope/vim-ragtag'
    use 'tpope/vim-surround'

    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'nvim-tree/nvim-web-devicons', opt = true }
    }
end)
