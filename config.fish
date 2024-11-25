if status is-interactive
    #                                    ╭──────╮
    #                                    │ PATH │
    #                                    ╰──────╯
    set -x fish_user_paths
    fish_add_path $HOME/bin
    fish_add_path $HOME/.local/bin
    fish_add_path /usr/local/bin
    fish_add_path /Applications/WezTerm.app/Contents/MacOS

    #                                  ╭──────────╮
    #                                  │ Homebrew │
    #                                  ╰──────────╯
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

    #                                  ╭───────────╮
    #                                  │ Variables │
    #                                  ╰───────────╯
    set -gx fish_greeting # Disable greeting function
    set -gx fish_history_limit 10000
    set -gx GREP_OPTIONS "--color=auto"
    set -gx LC_CTYPE "en_US.UTF-8"
    set -gx LANG "en_US.UTF-8"
    set -gx TERM "wezterm"
    set -gx XDG_CONFIG_HOME "$HOME/.config"

    #                                     ╭─────╮
    #                                     │ eza │
    #                                     ╰─────╯
    if type -q eza
        alias ls "eza --header --git"
    end

    #                                   ╭────────╮
    #                                   │ neovim │
    #                                   ╰────────╯
    if type nvim > /dev/null
        abbr nv 'nvim'
        set -gx EDITOR (which nvim)
        set -gx VISUAL $EDITOR
        set -gx SUDO_EDITOR $EDITOR
        set -gx MANPAGER "nvim +Man! -"
    end

    #                                   ╭─────────╮
    #                                   │ Secrets │
    #                                   ╰─────────╯
    set secrets_file "$HOME/.config/fish/secrets.fish"
    if test -r $secrets_file
        source $secrets_file
    end

    #                                     ╭─────╮
    #                                     │ bat │
    #                                     ╰─────╯
    if type bat > /dev/null
        alias cat=bat
        set -gx PAGER bat
    end

    #                               ╭────────────────╮
    #                               │ abbr and alias │
    #                               ╰────────────────╯
    abbr gst 'git status'
    abbr gl 'git pull'
    abbr gp 'git push'
    abbr glog 'git log --oneline --graph --decorate -n 20'
    abbr gca 'git commit -a'
    abbr gc 'git commit' 
    abbr gd 'git diff'
    abbr gpristine 'git reset --hard && git clean --force -dfx'
    abbr python 'python3'
    abbr pip 'pip3'
    abbr ssh "TERM=xterm-256color command ssh"
    abbr mosh "TERM=xterm-256color command mosh"
    abbr trhau 'env TERM="xterm-256color" mosh --ssh="ssh -C -p 9898" thorre@helio.home -- tmux -2 attach'
    abbr srhau 'env TERM="xterm-256color" ssh -C -p 9898 -t thorre@helio.home tmux -2 attach || env TERM="xterm-256color" ssh -C -p 9898 -t thorre@helio.home tmux -2 -u new'

    #                                   ╭────────╮
    #                                   │ zoxide │
    #                                   ╰────────╯
    zoxide init fish | source
    bind \cz zi 
    alias cd z

    #                                     ╭─────╮
    #                                     │ fzf │
    #                                     ╰─────╯
    fzf --fish | source
    set -gx FZF_DEFAULT_COMMAND 'fd --type f --hidden --exclude .git'
    set -gx FZF_CTRL_T_COMMAND 'fd --type f --hidden --exclude .git'
    set -gx FZF_CTRL_T_OPTS '--preview "bat --style=numbers --color=always {}" --preview-window=right:60% --border'
    set -gx FZF_ALT_C_COMMAND 'fd --type d --hidden --exclude .git'
    set -gx FZF_ALT_C_OPTS '--preview "ls -al {}" --preview-window=down:40%'
    set -gx FZF_CTRL_R_OPTS '--height 40% --layout=reverse --info=inline --border'
    set -gx FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'
    set -gx FZF_TMUX 0
    set -gx FZF_COMPLETION_TRIGGER '**'

    #                       ╭────────────────────────────────╮
    #                       │ macOS light / dark theme setup │
    #                       ╰────────────────────────────────╯
    set -l appearance (defaults read -g AppleInterfaceStyle 2>/dev/null)

    if test "$appearance" = "Dark"
        # Dark theme stuff
        set -gx DELTA_FEATURES "dark-mode"
        set -gx LS_COLORS (vivid generate catppuccin-macchiato)
        fish_config theme choose "Catppuccin Macchiato"
        set -gx FZF_DEFAULT_OPTS "\
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
        set -gx FZF_DEFAULT_OPTS "\
        --color=bg+:#ccd0da,bg:#eff1f5,spinner:#dc8a78,hl:#d20f39 \
        --color=fg:#4c4f69,header:#d20f39,info:#8839ef,pointer:#dc8a78 \
        --color=marker:#7287fd,fg+:#4c4f69,prompt:#8839ef,hl+:#d20f39 \
        --color=selected-bg:#bcc0cc \
        --multi"
    end

    #                                  ╭──────────╮
    #                                  │ Starship │
    #                                  ╰──────────╯
    set -gx STARSHIP_SHELL fish
    starship init fish | source

end
