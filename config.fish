if status is-interactive
    # Commands to run in interactive sessions can go here
    set -U fish_greeting # Disable greeting function

    # Homebrew setup
    if test -d /opt/homebrew
      set -gx ARCHFLAGS "-arch arm64"
      set -gx HOMEBREW_PREFIX "/opt/homebrew"
      set -gx HOMEBREW_NO_ANALYTICS 1
      set -gx PATH "/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
      if test -f "$HOME/.brew_api_token"
        source "$HOME/.brew_api_token"
      end
    end

    # General variables
    set -gx MANPAGER "less"
    set -gx GREP_OPTIONS "--color=auto"
    set -gx LC_CTYPE "en_US.UTF-8"
    set -gx LANG "en_US.UTF-8"
    set -gx PATH "$HOME/bin:$PATH"

    # SSH aliases
    alias trhau='mosh --ssh="ssh -C -p 9898" thorre@helio.home -- tmux -2 attach'
    alias srhau='ssh -C -p 9898 -t thorre@helio.home tmux -2 attach'

    # exa setup (replacement for ls)
    if type -q exa
      alias ls "exa -F --git --group-directories-first --color=auto"
    end

    # NeoVIM setup with fallback to vim
    if type -q nvim
      set -gx EDITOR "nvim"
      alias nv "nvim"
    else if type -q vim
      set -gx EDITOR "vim"
    end

#    # Source fish colors and create aliases
#    if test -d "$HOME/git/nightfox.nvim"
#      source "$HOME/.config/fish/themes/current.fish"
#      alias dayfish "ln -sf $HOME/git/nightfox.nvim/extra/dayfox/nightfox_fish.fish \
#        $HOME/.config/fish/themes/current.fish"
#      alias nightfish "ln -sf $HOME/git/nightfox.nvim/extra/nightfox/nightfox_fish.fish \
#        $HOME/.config/fish/themes/current.fish"
#    end
end
