-- auto install packer if not installed
local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end
local packer_bootstrap = ensure_packer() -- true if packer was just installed

-- autocommand that reloads neovim and installs/updates/removes plugins
-- when file is saved
vim.cmd([[ 
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
    augroup end
]])

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	print("packer was not loaded")
    return
end

return packer.startup(function(use)
    use("wbthomason/packer.nvim")
    use("safv12/andromeda.vim") -- color scheme

    use("nvim-lua/plenary.nvim")

    -- tmux and split window navigation
    use("christoomey/vim-tmux-navigator")

    -- maximise split windows
    use("szw/vim-maximizer")

    -- essentials
    use("tpope/vim-surround")
    use("vim-scripts/ReplaceWithRegister")

    -- comment with gc
    use("numToStr/Comment.nvim")
    
    -- file explorer
    use("nvim-tree/nvim-tree.lua")

    -- icons
    use("kyazdani42/nvim-web-devicons")

    -- statusline
    use("nvim-lualine/lualine.nvim")

    -- fuzzy finder: telescope
    -- use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
    use({ "nvim-telescope/telescope.nvim", branch = "0.1.x" }) -- fuzzy finder

    -- completion: CoC
    use({'neoclide/coc.nvim', branch = 'release'})

    -- Github copilot
    use("github/copilot.vim")

    use({
        "nvim-treesitter/nvim-treesitter",
        run = function()
          local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
          ts_update()
        end,
    })

    -- git integration
    use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side
    if packer_bootstrap then
        require("packer").sync()
    end
end)

