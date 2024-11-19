if status is-interactive
    # Add directories to PATH
    fish_add_path $HOME/bin
    fish_add_path $HOME/.local/bin
    fish_add_path /usr/local/bin
    fish_add_path /Applications/WezTerm.app/Contents/MacOS

    # Set environment variables
    set -gx PAGER less

    # Commands to run in interactive sessions can go here
    set -U fish_greeting # Disable greeting function

    # Homebrew setup
    if test -d /opt/homebrew
        set -gx ARCHFLAGS "-arch arm64"
        set -gx HOMEBREW_PREFIX "/opt/homebrew"
        set -gx HOMEBREW_NO_ANALYTICS 1
        fish_add_path -p /opt/homebrew/sbin
        fish_add_path -p /opt/homebrew/bin
        if test -f "$HOME/.brew_api_token"
            source "$HOME/.brew_api_token"
        end
    end

    # General variables
    set -gx MANPAGER "nvim +Man! -"
    set -gx GREP_OPTIONS "--color=auto"
    set -gx LC_CTYPE "en_US.UTF-8"
    set -gx LANG "en_US.UTF-8"
    set -gx TERM "wezterm"

    # eza setup (replacement for ls)
    if type -q eza
        alias ls "eza --header --git"
    end

    # NeoVIM setup with fallback to vim
    if type -q nvim
        set -gx EDITOR "nvim"
        set -gx VISUAL $EDITOR
        alias nv "nvim"
    else if type -q vim
        set -gx EDITOR "vim"
    end


    # Set aliases
    alias nv='nvim'
    alias gst='git status'
    alias gl='git pull'
    alias gp='git push'
    alias glog='git log --oneline --graph --decorate -n 20'
    alias gca='git commit -a'
    alias python='python3'
    alias pip='pip3'

    zoxide init fish | source

    fzf --fish | source

    set -gx STARSHIP_SHELL fish
    starship init fish | source

    # Zoxide interactive via ctrl-z
    bind \cz zi 

    # Read the AppleInterfaceStyle preference for light/dark appearance
    set -l appearance (defaults read -g AppleInterfaceStyle 2>/dev/null)

    if test "$appearance" = "Dark"
            # Dark theme stuff
            set -gx DELTA_FEATURES "dark-mode"
            set -gx LS_COLORS (vivid generate catppuccin-macchiato)
        echo dark mode set
    else
            # Light theme stuff
            set -gx DELTA_FEATURES "light-mode"
            set -gx LS_COLORS (vivid generate catppuccin-latte)
        echo light mode set
    end

    # Configure fish greeting
    function fish_greeting
        echo "Welcome to fish, Thorsten! 🐟"
    end
end

