alias ga.='git add .'
alias gcm='git commit -m'
alias gs='git status'
alias gd='gid diff'
alias gp='git pull'
alias gpu='git push'
alias ci='code-insiders'
alias ci.='code-insiders .'
alias l='ls -la'
alias gg='ghq get'
alias d="docker"
alias dc="docker-compose"
alias dcrr="docker-compose run --rm"

# git checkout feature/issue-
function gcof() {
  git checkout feature/issue-"$@"
}
# git checkout issue-
function gcod() {
  git checkout develop && git pull
}
# git checkout -b feature/issue-
function gcobf() {
  echo "$(currentBranch) -> feature/issue-$@\ny/n"
  if read -q; then
    echo "\n"
    git checkout -b feature/issue-"$@";
  fi
}

# history fzf
function history-fzf() {
  local tac

  if which tac > /dev/null; then
    tac="tac"
  else
    tac="tail -r"
  fi

  BUFFER=$(history -n 1 | eval $tac | fzf --query "$LBUFFER")
  CURSOR=$#BUFFER

  zle reset-prompt
}
zle -N history-fzf
bindkey '^R' history-fzf


# ghq fzf
function ghq-fzf() {
  local selected_dir=$(ghq list | fzf --query="$LBUFFER")
  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ghq-fzf
bindkey "^G" ghq-fzf

# hub browse current dir fzf
function hub-browse() {
  BUFFER="hub browse"
  zle accept-line
  zle reset-prompt
}
zle -N hub-browse
bindkey "^O" hub-browse
