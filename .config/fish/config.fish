# Atlassian setup
# https://www.atlassian.com/git/tutorials/dotfiles
# Config file derived from https://gitlab.com/garuda-linux/themes-and-settings/settings/garuda-fish-config/-/blob/master/config.fish

set fish_greeting
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

# Set settings for https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 10000
set -U __done_notification_urgency_level low

## Environment setup
# Apply .profile: use this to put fish compatible .profile stuff in
if test -f ~/.fish_profile
  source ~/.fish_profile
end

# Add ~/.local/bin to PATH
if test -d ~/.local/bin
    if not contains -- ~/.local/bin $PATH
        set -p PATH ~/.local/bin
    end
end

# Add depot_tools to PATH
if test -d ~/Applications/depot_tools
    if not contains -- ~/Applications/depot_tools $PATH
        set -p PATH ~/Applications/depot_tools
    end
end

# Add homebrew to PATH
switch (uname)
    case Darwin
        eval ("/opt/homebrew/bin/brew" shellenv)
end

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

## Advanced command-not-found hook
switch (uname)
    case Linux
        source /usr/share/doc/find-the-command/ftc.fish
end

## Functions
# Functions needed for !! and !$ https://github.com/oh-my-fish/plugin-bang-bang
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# Fish command history
function history
    builtin history --show-time='%F %T '
end

function backup --argument filename
    cp $filename $filename.bak
end

# Copy DIR1 DIR2
function copy
    set count (count $argv | tr -d \n)
    if test "$count" = 2; and test -d "$argv[1]"
	set from (echo $argv[1] | trim-right /)
	set to (echo $argv[2])
        command cp -r $from $to
    else
        command cp $argv
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
switch (uname)
    case Darwin
        alias talisman talisman_darwin_arm64
    case Linux
        alias talisman talisman_linux_amd64
end

# iTerm2 tools setup
switch (uname)
    case Darwin
        test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
end