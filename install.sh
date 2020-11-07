#...

DOTPATH=~/.dotfiles-wsl2
GITHUB_URL=http://github.com/kajirikajiri/dotfiles-wsl2.git
TARBALL="https://github.com/kajirikajiri/dotfiles-wsl2/archive/main.tar.gz"
UNAME=$(uname)
# is_exists returns true if executable $1 exists in $PATH
is_exists() {
    type "$1" >/dev/null 2>&1
    return $?
}
# has is wrapper function
has() {
    is_exists "$@"
}
# die returns exit code error and echo error message
die() {
    e_error "$1" 1>&2
    exit "${2:-1}"
}

git clone --recursive "$GITHUB_URL" "$DOTPATH"

cd "$DOTPATH"
if [ $? -ne 0 ]; then
    die "not found: $DOTPATH"
fi

# 移動できたらリンクを実行する
for f in .??*
do
    [ "$f" = ".git" ] && continue

    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done

# zshがなければinstallする
if has "zsh"; then
    echo 'zsh is present!'
# ない場合はinstallする
elif has "apt"; then
    echo 'install zsh'
    sudo apt update
    sudo apt install -y zsh
    chsh -s $(which zsh) || true # for skipping in CI
else
    echo 'zsh, apt not found'
fi

# golangがなければinstallする
if has "go"; then
    echo 'go is present!'
# ない場合はinstallする
elif has "apt"; then
    echo 'install go'
    sudo add-apt-repository ppa:longsleep/golang-backports
    sudo apt update
    sudo apt install -y golang-go
    go get github.com/x-motemen/ghq
else
    echo 'go, apt not found'
fi

# fzfがなければinstallする
if has "fzf"; then
    echo 'fzf is present!'
# ない場合はinstallする
elif has "git"; then
    echo 'install fzf'
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
else
    echo 'fzf, git not found'
fi
