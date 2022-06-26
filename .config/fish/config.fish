#Setup brew for macOS
switch (uname)
    case Darwin
        eval ("/opt/homebrew/bin/brew" shellenv)
end

# Sourced from Garuda Linux's fish config skeleton.
# Really nice defaults.

set fish_greeting
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

#Starship prompt
if status is-interactive
    pokemon-colorscripts --name furret -s | tail -n+2
    switch (uname)
        case Linux
             source ("/usr/bin/starship" init fish --print-full-init | psub)
        case Darwin
             source ("/opt/homebrew/bin/starship" init fish --print-full-init | psub)
    end
end

## Useful aliases
# Replace ls with exa
alias ls='exa -al --color=always --group-directories-first --icons' # preferred listing
alias la='exa -a --color=always --group-directories-first --icons'  # all files and dirs
alias ll='exa -l --color=always --group-directories-first --icons'  # long format
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l.="exa -a | egrep '^\.'"                                     # show only dotfiles

# Replace some more things with better alternatives
alias cat='bat --style header --style rules --style snip --style changes --style header'
[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

mcfly init fish | source
op completion fish | source

function git_work
    git config --local user.name "Chloe Stars"
    git config --local user.email "chloe.stars@thoughtworks.com"
    echo "Git config setup for work ✨"
end

function git_personal
    git config --local user.name "Chloe Stars"
    git config --local user.email "c.stars@icloud.com"
end

# Setting PATH for Python 3.10
# The original version is saved in /Users/chloe/.config/fish/config.fish.pysave
# set -x PATH "/Library/Frameworks/Python.framework/Versions/3.10/bin" "$PATH"

# Tracked dotfiles setup
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# Set up environment variables
set -x TALISMAN_HOME $HOME/.talisman/bin
# Platform dependent env variables
switch (uname)
    case Darwin
        set -x SSH_AUTH_SOCK "~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock"
end

# Set up extra PATHs.
fish_add_path $TALISMAN_HOME
fish_add_path $HOME/.cargo/bin

# Provide feedback about setup on Talisman
alias talisman talisman_darwin_arm64
