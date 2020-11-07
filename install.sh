#...

DOTPATH_NAME=dotfiles-wsl2
DOTPATH="~/.${DOTPATH_NAME}"
GITHUB_URL="http://github.com/kajirikajiri/${DOTPATH_NAME}.git"
TARBALL="https://github.com/kajirikajiri/${DOTPATH_NAME}/archive/main.tar.gz"

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

sudo apt-get update
sudo apt update

# zshがなければinstallする
if has "zsh"; then
    echo 'zsh is present!'
else
# ない場合はinstallする
    echo 'install zsh'
    sudo apt install -y zsh
    chsh -s $(which zsh) || true # for skipping in CI
fi

# golangがなければinstallする
if has "go"; then
    echo 'go is present!'
else
    echo 'install go'
    sudo add-apt-repository ppa:longsleep/golang-backports
    sudo apt update
    sudo apt install -y golang-go
    go get github.com/x-motemen/ghq
fi

# fzfがなければinstallする
if has "fzf"; then
    echo 'fzf is present!'
else
    echo 'install fzf'
    sudo apt-get install fzf
fi
