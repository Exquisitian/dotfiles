# .zprofile is sourced by all login shells

# ---- PATH ----
# PATH set in .zshenv may be overritten by /etc/porfile
PATH="/usr/local/bin:$PATH"                       # Path to all installed executables
PATH="$HOME/.local/bin:$PATH"                     # Add custom shell scripts to path
PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH" # Path to homebrew executable

if [ -d "/opt/homebrew/opt/ruby/bin" ]; then
  PATH="/opt/homebrew/opt/ruby/bin:$PATH"         # Path to ruby executabe
  PATH="`gem environment gemdir`/bin:$PATH"       # Path to ruby gem
fi

export PATH
