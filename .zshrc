HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

setopt appendhistory autocd extendedglob nomatch notify
unsetopt beep

autoload -Uz compinit promptinit
compinit
promptinit

# Use vim mode
bindkey -v
bindkey '^P' up-history
bindkey '^N' down-history
bindkey '^?' backward-delete-char
bindkey '^h' backward-delete-char
bindkey '^w' backward-kill-word
bindkey '^r' history-incremental-search-backward
export KEYTIMEOUT=1

autoload -Uz add-zsh-hook
function xterm_title_precmd () {
	print -Pn -- '\e]2;%n@%m %~\a'
	[[ "$TERM" == 'screen'* ]] && print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-}\e\\'
}
function xterm_title_preexec () {
	print -Pn -- '\e]2;%n@%m %~ %# ' && print -n -- "${(q)1}\a"
	[[ "$TERM" == 'screen'* ]] && { print -Pn -- '\e_\005{g}%n\005{-}@\005{m}%m\005{-} \005{B}%~\005{-} %# ' && print -n -- "${(q)1}\e\\"; }
}
if [[ "$TERM" == (screen*|xterm*|rxvt*|tmux*|putty*|konsole*|gnome*) ]]; then
	add-zsh-hook -Uz precmd xterm_title_precmd
	add-zsh-hook -Uz preexec xterm_title_preexec
fi

zstyle :compinstall filename '/home/paulo/.zshrc'

zstyle ':completion:*' menu select
zstyle ':completion:*:*:git:*' script /usr/share/git/completion/git-completion.zsh

autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*' formats '(%b) %m%u%c'
zstyle ':vcs_info:git*' actionformats '(%b|%a) %m%u%c'
vcs_info_precmd() { vcs_info }
add-zsh-hook -Uz precmd vcs_info_precmd

setopt prompt_subst
PROMPT='$(prompt_exit_code)%B%F{green}%n@%m%f:%F{blue}%1~%f%b%# '
RPROMPT='%F{green}%~%F{white}${vcs_info_msg_0_}%f'

prompt_exit_code() {
	local CODE=$?
	if [[ $CODE -ne 0 ]]; then
	    echo "%B%F{red}[${CODE}]%f%b "
	fi
}

if ! pgrep -u "$USER" ssh-agent > /dev/null; then
    ssh-agent > ~/.ssh-agent-thing
fi
if [[ "$SSH_AGENT_PID" == "" ]]; then
    eval "$(<~/.ssh-agent-thing)" > /dev/null
fi

alias ..='cd ..'
alias ....='cd ../..'

alias vi='vim'
alias ls='ls --color=auto'
alias ssh='TERM=xterm-256color ssh'
alias mutt='neomutt'
alias mpvf='mpv --fs'
alias autoremove='yay -Rcs $(yay -Qdtq)'
alias audit='arch-audit'
alias cmake='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

alias s='ssh'
alias b='bash'

alias g='git'
alias gi='git init'
alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gss='git status --short'
alias gc='git commit'
alias gca='git commit --all'
alias gcm='git commit --message'
alias gd='git diff'
alias gda='git diff HEAD'
alias gg='git grep'
alias glo='git log --oneline --decorate'
alias glog='git log --graph --oneline --decorate --all'
alias glod='git log --pretty=format:"%h %ad %s" --date=short --all'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gb='git branch'
alias gbd='git branch --delete'
alias gbl='git blame'
alias gl='git pull'
alias glr='git pull --rebase'
alias glo='git pull origin'
alias gp='git push'
alias gpo='git push --set-upstream origin'
alias gf='git fetch'
alias gfa='git fetch --all --prune'
alias gm='git merge'
alias gma='git merge --abort'
alias gmc='git merge --continue'
alias gr='git rebase --rebase-merges'
alias gra='git rebase --abort'
alias grc='git rebase --continue'
alias grs='git reset'
alias grsh='git reset --hard'
alias gmv='git mv'
alias gst='git stash'
alias gsta='git stash apply'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash save'

export EDITOR='vim'
export VISUAL='vim'

export PATH=$PATH:~/scripts
export PATH=$PATH:~/.local/bin

# Emscripten SDK
source ~/src/emsdk/emsdk_env.sh > /dev/null

