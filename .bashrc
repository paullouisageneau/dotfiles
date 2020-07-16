#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

source /usr/share/bash-completion/bash_completion
source /usr/share/git/completion/git-prompt.sh

#PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(__git_ps1 "(%s)")\$ '

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
alias mutt='neomutt'
alias mpvf='mpv --fs'
alias autoremove='yay -Rcs $(yay -Qdtq)'
alias audit='arch-audit'
alias cmake='cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias dotfiles='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'

alias s='ssh'
alias z='zsh'
complete -F _known_hosts s

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
alias gr='git rebase'
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
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'
alias gmt='git mergetool'

source /usr/share/git/completion/git-completion.bash
__git_complete dotfiles _git
__git_complete g   _git
__git_complete gi  _git_init
__git_complete gco _git_checkout
__git_complete gb  _git_branch
__git_complete gbd _git_branch
__git_complete gl  _git_pull
__git_complete gp  _git_push
__git_complete gf  _git_fetch
__git_complete gm  _git_merge
__git_complete gr  _git_rebase
__git_complete grs _git_reset
__git_complete gst _git_stash
__git_complete gcp  _git_cherry_pick
__git_complete gpo _git_branch # Hack to get branch completion

export EDITOR="vim"
export VISUAL="vim"

export PATH=$PATH:~/scripts
export PATH=$PATH:~/.local/bin

# Emscripten SDK
source ~/src/emsdk/emsdk_env.sh &> /dev/null

notes() {
  if [ ! -z "$1" ]; then
    # Using the "$@" here will take all parameters passed into
    # this function so we can place everything into our file.
    echo "$@" >> "$HOME/notes.md"
  else
    # If no arguments were passed we will take stdout and place
    # it into our notes instead.
    cat - >> "$HOME/notes.md"
  fi
}

