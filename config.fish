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

    #                            ╭──────────────────────╮
    #                            │ sourcing local files │
    #                            ╰──────────────────────╯
    set secrets_file "$HOME/.config/fish/secrets.fish"
    if test -r $secrets_file
        source $secrets_file
    end

    set local_file "$HOME/.config/fish/local.fish"
    if test -r $local_file
        source $local_file
    end

    #                               ╭────────────────╮
    #                               │ abbr and alias │
    #                               ╰────────────────╯
    abbr gc 'git commit' 
    abbr gca 'git commit -a'
    abbr gd 'git diff'
    abbr gl 'git pull'
    abbr glg 'git log --oneline --graph --decorate -n 20'
    abbr gp 'git push'
    abbr gpristine 'git reset --hard && git clean --force -dfx'
    abbr gst 'git status'
    abbr pip 'pip3'
    abbr python 'python3'
    abbr ya 'yazi'
    alias mosh "TERM=xterm-256color command mosh"
    alias ssh "TERM=xterm-256color command ssh"

    #                                     ╭─────╮
    #                                     │ bat │
    #                                     ╰─────╯
    if type bat > /dev/null
        alias cat="bat -p"
        set -gx PAGER bat
    end


    #                                   ╭────────╮
    #                                   │ zoxide │
    #                                   ╰────────╯
    if type zoxide > /dev/null
        zoxide init fish | source
        bind \cz zi 
        alias cd z
    end

    #                                     ╭─────╮
    #                                     │ fzf │
    #                                     ╰─────╯
    if type fzf > /dev/null
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
    end


    #                       ╭────────────────────────────────╮
    #                       │ macOS light / dark theme setup │
    #                       ╰────────────────────────────────╯

    # macOS check for light/dark appearance
    if type -q defaults
        set -gx appearance (defaults read -g AppleInterfaceStyle 2>/dev/null)
    else
        set -gx appearance "Dark"
    end


    # LazyGit themes and settings
    if type -q lazygit
        abbr lg 'lazygit'
        bind \e\cg "lazygit"
        bind \e\cs "lazygit status"
        bind \e\cl "lazygit log"
        # Creating configuration directory if it does not exist
        if not test -d "$HOME/.config/lazygit"
            mkdir -p "$HOME/.config/lazygit"
        end
        if test -f "$HOME/.config/fish/themes/lazygit/tokyonight_day.conf"
            set -gx lazygit_config "$HOME/.config/lazygit/config.yml"
            if test "$appearance" = "Dark"
                ln -sf "$HOME/.config/fish/themes/lazygit/tokyonight_night.yml" "$lazygit_config"
            else
                ln -sf "$HOME/.config/fish/themes/lazygit/tokyonight_day.yml" "$lazygit_config"
            end
        end
    end

    # Setting fzf theme
    if type -q fzf
        if test -f $HOME/.config/fish/themes/fzf/tokyonight_night.sh
            if test "$appearance" = "Dark"
                source $HOME/.config/fish/themes/fzf/tokyonight_night.sh
            else
                source $HOME/.config/fish/themes/fzf/tokyonight_day.sh
            end
        end
    end


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

    #                                  ╭──────────╮
    #                                  │ Starship │
    #                                  ╰──────────╯
    starship init fish | source

end
