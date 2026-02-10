export XDG_CONFIG_HOME="$HOME/.config"

set -gx  LC_ALL en_US.UTF-8

if status is-interactive

    starship init fish | source

    alias c=clear

    alias ..=cd ..
    alias ...=cd ../..

    alias sshconfig="nvim ~/.ssh/config"

    alias pf="ps -ef | grep"

    alias ls=eza

    # ctrl-u to go up one directory, equalvelant to cd ..
    bind \cu "cd ..; commandline -f repaint"

    # ctrl-o to go back to the previous directory in directory history
    bind \co prevd-or-backward-word

    # ctrl-i to go to the next directory in directory history
    bind \ci nextd-or-forward-word

    alias k=kubectl

    alias lg=lazygit

    alias g=git

    alias v=nvim

    # fuzzy search file and copy path to clipboard
    alias fp='fzf | xargs -I {} realpath "{}"| pbcopy' 

    alias dp='pwd | pbcopy' 

    alias ccc='claude-chill claude'

end

function safe_source
    if test -e $argv[1]
		source $argv[1]
	end
end

# create a new tmux session for the current directory
function tn
    set session (basename (dirname (pwd)))/(basename (pwd))

    if not tmux has-session -t $session
    	tmux new-session -s $session -d
    end

    tmux switch-client -t $session
end

# attach to the last used tmux session or create a new one when there's no session.
function ta
	tmux a || tn
end

function zn
    set session (basename (pwd))
    zellij a -c $session
end

function zellij_tab_name_update_pre --on-event fish_preexec
    if set -q ZELLIJ
        set title (string split ' ' $argv)[1]
        command nohup zellij action rename-tab $title >/dev/null 2>&1
    end
end

function zellij_tab_name_update_post --on-event fish_prompt
    if set -q ZELLIJ
        set title "fish"
        command nohup zellij action rename-tab $title >/dev/null 2>&1
    end
end

set -g _ZL_CMD j
lua $HOME/.z.lua/z.lua --init fish | source

# prevent tab from completing autosuggestions.
bind \t 'commandline -f complete'

# ctrl-space to toggle search in pager.
bind nul pager-toggle-search

# override fish greeting message to nothing
function fish_greeting
end

if test -e "$VIRTUAL_ENV"
	source "$VIRTUAL_ENV/bin/activate.fish"
end


# Created by `userpath` on 2023-10-19 03:41:54
set PATH $PATH /Users/eddie.huang/.local/bin

safe_source $HOME/.local.fish

# Created by `pipx` on 2024-05-04 10:19:41
set PATH $PATH /Users/inoc/.local/bin

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.fish 2>/dev/null || :

# Added by Windsurf
fish_add_path ~/.codeium/windsurf/bin

# opencode
fish_add_path ~/.opencode/bin
