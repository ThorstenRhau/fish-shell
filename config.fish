if status is-interactive
    # Cursor styles
    set -gx fish_vi_force_cursor 1
    set -gx fish_cursor_default block
    set -gx fish_cursor_insert line blink
    set -gx fish_cursor_visual block
    set -gx fish_cursor_replace_one underscore

    # Add directories to PATH
    set -x fish_user_paths
    fish_add_path $HOME/bin
    fish_add_path $HOME/.local/bin
    fish_add_path /usr/local/bin
    fish_add_path /Applications/WezTerm.app/Contents/MacOS

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
    set -gx PAGER less

    # eza setup (replacement for ls)
    if type -q eza
        alias ls "eza --header --git"
    end

    # NeoVim as editor for everything
    set -gx EDITOR (which nvim)
    set -gx VISUAL $EDITOR
    set -gx SUDO_EDITOR $EDITOR

    # Fish
    set fish_emoji_width 2

    # Set aliases
    alias nv='nvim'
    alias gst='git status'
    alias gl='git pull'
    alias gp='git push'
    alias glog='git log --oneline --graph --decorate -n 20'
    alias gca='git commit -a'
    alias python='python3'
    alias pip='pip3'
    alias ssh "TERM=xterm-256color command ssh"
    alias mosh "TERM=xterm-256color command mosh"
    alias trhau='env TERM="xterm-256color" mosh --ssh="ssh -C -p 9898" thorre@helio.home -- tmux -2 attach'
    alias srhau='env TERM="xterm-256color" ssh -C -p 9898 -t thorre@helio.home tmux -2 attach || env TERM="xterm-256color" ssh -C -p 9898 -t thorre@helio.home tmux -2 -u new'

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
        fish_config theme choose "Catppuccin Macchiato"
    else
        # Light theme stuff
        set -gx DELTA_FEATURES "light-mode"
        set -gx LS_COLORS (vivid generate catppuccin-latte)
        fish_config theme choose "Catppuccin Latte"
    end
end

