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

    # Loading secrets if they exist
    set secrets_file "$HOME/.config/fish/fish_secrets"
    if test -f $secrets_file
        source $secrets_file
    end

    # General variables
    set -gx PAGER bat
    set -gx GREP_OPTIONS "--color=auto"
    set -gx LC_CTYPE "en_US.UTF-8"
    set -gx LANG "en_US.UTF-8"
    set -gx TERM "wezterm"
    set -gx XDG_CONFIG_HOME "$HOME/.config"

    # eza setup (replacement for ls)
    if type -q eza
        alias ls "eza --header --git"
    end

    # NeoVim as editor for everything
    set -gx EDITOR (which nvim)
    set -gx VISUAL $EDITOR
    set -gx SUDO_EDITOR $EDITOR
    set -gx MANPAGER "nvim +Man! -"

    # Fish
    set fish_emoji_width 2

    # Set aliases
    alias nv='nvim'
    alias gst='git status'
    alias gl='git pull'
    alias gp='git push'
    alias glog='git log --oneline --graph --decorate -n 20'
    alias gca='git commit -a'
    alias gc='git commit' 
    alias gd='git diff'
    alias gpristine='git reset --hard && git clean --force -dfx'
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
        set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
        --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
        --color=marker:#b7bdf8,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796 \
        --color=selected-bg:#494d64 \
        --multi"
    else
        # Light theme stuff
        set -gx DELTA_FEATURES "light-mode"
        set -gx LS_COLORS (vivid generate catppuccin-latte)
        fish_config theme choose "Catppuccin Latte"
        set -Ux FZF_DEFAULT_OPTS "\
        --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
        --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
        --color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
        --color=selected-bg:#bcc0cc \
        --multi"
    end
end

