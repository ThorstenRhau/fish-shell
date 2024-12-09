if status is-interactive
    #                                    ╭──────╮
    #                                    │ PATH │
    #                                    ╰──────╯
    # Initialize fish_user_paths if not already set
    set -q fish_user_paths; or set -x fish_user_paths

    # Function to safely add a directory to PATH
    function safe_add_path
        if test -d $argv[1]
            fish_add_path $argv[1]
        end
    end
    safe_add_path $HOME/bin
    safe_add_path $HOME/.local/bin
    safe_add_path $HOME/.cache/lm-studio/bin
    safe_add_path $HOME/.rd/bin
    safe_add_path /usr/local/bin
    safe_add_path /Applications/WezTerm.app/Contents/MacOS

    #                                  ╭──────────╮
    #                                  │ Homebrew │
    #                                  ╰──────────╯
    if test -d /opt/homebrew
        set -gx ARCHFLAGS "-arch arm64"
        set -gx HOMEBREW_PREFIX "/opt/homebrew"
        set -gx HOMEBREW_NO_ANALYTICS 1
        fish_add_path -p /opt/homebrew/sbin
        fish_add_path -p /opt/homebrew/bin
    end

    #                                  ╭───────────╮
    #                                  │ Variables │
    #                                  ╰───────────╯
    set -gx fish_greeting # Disable greeting function
    set -gx fish_history_limit 10000
    set -gx GREP_OPTIONS "--color=auto"
    set -gx LC_CTYPE "en_US.UTF-8"
    set -gx LANG "en_US.UTF-8"
    set -gx XDG_CONFIG_HOME "$HOME/.config"
    if test -d /Applications/WezTerm.app
        set -gx TERM "wezterm"
    end
    set -gx MOSH_ENABLE_WIDECHAR 1

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
        alias cat="bat -p"
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
    abbr ya 'yazi'
    alias ssh "TERM=xterm-256color command ssh"
    alias mosh "TERM=xterm-256color command mosh"
    alias trhau 'env TERM="xterm-256color" mosh --ssh="ssh -C -p 9898" thorre@helio.home -- tmux -2 attach'
    alias srhau 'env TERM="xterm-256color" ssh -C -p 9898 -t thorre@helio.home tmux -2 attach || env TERM="xterm-256color" ssh -C -p 9898 -t thorre@helio.home tmux -2 -u new'

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
    set -l appearance (defaults read -g AppleInterfaceStyle 2>/dev/null; or echo "Dark")

    if test "$appearance" = "Dark"
        # Dark theme stuff
        set -gx DELTA_FEATURES "dark-mode"
        fish_config theme choose "tokyonight_night"
        source ~/.config/fish/themes/tokyonight_night.fish
        set -gx BAT_THEME "tokyonight_night"
    else
        # Light theme stuff
        set -gx DELTA_FEATURES "light-mode"
        fish_config theme choose "tokyonight_day"
        source ~/.config/fish/themes/tokyonight_day.fish
        set -gx BAT_THEME "tokyonight_day"
    end
end
