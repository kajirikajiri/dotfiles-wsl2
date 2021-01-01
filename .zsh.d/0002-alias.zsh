alias ..='cd ..'
alias ...='cd ../..'
alias ga='git add'
alias ga.='git add .'
alias gs='git status'
alias gd='git diff'
alias gp='git pull'
alias gpu='git push'
alias gco='git checkout'
alias gco.='git checkout .'
alias ci='code-insiders'
alias ci.='code-insiders .'
alias l='ls -la'
alias gg='ghq get'
alias d="docker"
alias dc="docker-compose"
alias dcu="docker-compose up"
alias dcrr="docker-compose run --rm"

# git commit -m $@
function gcm() {
	git commit -m "'$@'"
}

# change windows terminal title
function changetitle() {
	echo -ne "\033]0;$@\a"
}

# git checkout feature/issue-
function gcof() {
  git checkout feature/issue-"$@"
}
# git checkout develop
function gcod() {
  git checkout develop && git pull
}
# git checkout master
function gcom() {
  git checkout master && git pull
}
# git current branch
function currentBranch {
  git branch | grep \* | cut -d ' ' -f2
}
# git push first
function gpuf {
  currentBranch=$(currentBranch)
  git push --set-upstream origin $currentBranch
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
	changetitle ${selected_dir##*/}
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

zdf() {
	local file
	file="$(fzf +m -q "$*" \
		--preview="${FZF_PREVIEW_CMD}" \
		--preview-window='right:hidden:wrap' \
		--bind=ctrl-v:toggle-preview \
		--bind=ctrl-x:toggle-sort \
		--header='(view:ctrl-v) (sort:ctrl-x)' \
	)"
	vi "$file" || return
}
