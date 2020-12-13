# zshをメインで使っているが、初回でrbenvをインストールするためだけに、bashrcを使用している
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
