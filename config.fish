if status is-interactive
    # Set environment variables
    set -gx PAGER less

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
    set -gx MANPAGER "nvim +Man! -"
    set -gx GREP_OPTIONS "--color=auto"
    set -gx LC_CTYPE "en_US.UTF-8"
    set -gx LANG "en_US.UTF-8"
    set -gx PATH "$HOME/bin:$PATH"

    # exa setup (replacement for ls)
    if type -q exa
        alias ls "exa -F --git --group-directories-first --color=auto"
    end

    # NeoVIM setup with fallback to vim
    if type -q nvim
        set -gx EDITOR "nvim"
        set -gx VISUAL $EDITOR
        alias nv "nvim"
    else if type -q vim
        set -gx EDITOR "vim"
    end

    # Add directories to PATH
    fish_add_path $HOME//bin
    fish_add_path /usr/local/bin
    fish_add_path $HOME/.local/bin

    # Set aliases
    alias ll='ls -lah'
    alias g='git'
    alias dc='docker-compose'
    alias nv='nvim'

    zoxide init fish | source
    fzf --fish | source
    starship init fish | source

    # Configure fish greeting
    function fish_greeting
        echo "Welcome to fish, Thorsten! 🐟"
    end
end

