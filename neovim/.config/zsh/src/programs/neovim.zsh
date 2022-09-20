# MARK: Install neovim
zinit light-mode wait lucid from'gh-r' for \
    sbin'**/nvim -> nvim' \
    ver'v0.7.2' \
  @neovim/neovim \

# MARK: Useful alias for neovim
alias config_nvim="nvim $XDG_CONFIG_HOME/nvim/init.lua"            # Fast access to configuration file
alias plugins_nvim="cd $XDG_DATA_HOME/nvim/site/pack/packer/start" # Fast access to plugin directory
alias nvimdiff="nvim -d"                                           # Use nvim for diff

