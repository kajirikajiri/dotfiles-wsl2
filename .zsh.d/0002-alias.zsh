alias ..='cd ..'
alias ...='cd ../..'
alias ga='git add'
alias ga.='git add .'
alias gs='git status'
alias gd='git diff'
alias gp='git pull'
alias gpu='git push'
alias gco.='git checkout .'
alias ci='code-insiders'
alias ci.='code-insiders .'
alias l='ls -la'
alias gg='ghq get'
alias d="docker"
alias dc="docker-compose"
alias dcu="docker-compose up"
alias dcrr="docker-compose run --rm"
alias dck="docker-compose kill"

function gco() {
	git checkout $@ && changetitle "${PWD##*/}[$(currentBranch)]"
}
function gcb() {
  git checkout -b "$@" && changetitle "${PWD##*/}[$(currentBranch)]"
}

# git commit -m $@
function gcm() {
  # そのまま渡すと個別の引数として認識されたのでblankでjoin
	joined="$(IFS=' '; echo $@)"
	git commit -m "$joined" 
}

# git commit -m $@ --no-verify
function gcmn() {
	joined="$(IFS=' '; echo $@)"
	git commit -m "$joined" --no-verify
}

# change windows terminal title
function changetitle() {
	echo -ne "\033]0;$@\a"
}

# gco feature/issue-
function gcof() {
  gco feature/issue-"$@"
}
# gco develop
function gcod() {
  gco develop && git pull
}
# gco master
function gcom() {
  gco master && git pull
}
# git current branch
function currentBranch {
  git branch | grep \* | cut -d ' ' -f2
}
# git push first
function gpuf {
  git push --set-upstream origin "$(currentBranch)"
}
# git checkout -b $@
function gcob() {
  echo "$(currentBranch) -> $@\ny/n"
  if read -q; then
    echo "\n"
    gcb "$@"
  fi
}
# git checkout -b feature/issue-
function gcobf() {
  echo "$(currentBranch) -> feature/issue-$@\ny/n"
  if read -q; then
    echo "\n"
    gcb feature/issue-"$@"
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
    # BUFFER="cd $(ghq root)/${selected_dir}"
    cd "$(ghq root)/${selected_dir}"
		changetitle "${PWD##*/}[$(currentBranch)]"
    zle accept-line
  fi
  zle reset-prompt
	# changetitle "${selected_dir##*/}[$(currentBranch)]"
}
zle -N ghq-fzf
bindkey "^G" ghq-fzf

# gh-repo-view current dir fzf
function gh-repo-view() {
  BUFFER="gh repo view --web"
  zle accept-line
  zle reset-prompt
}
zle -N gh-repo-view
bindkey "^O" gh-repo-view

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

# obsidian backup
function obsidian() {
	local current_dir
	current_dir="$(pwd)"
	cd /mnt/c/Obsidian
	git add .
	git commit -m "$(date +%Y%m%d%H%M%S)"
	git push
	cd $current_dir
}
