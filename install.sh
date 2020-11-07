#...

source "install/has.sh"
source "install/die.sh"

DOTPATH_NAME=dotfiles-wsl2
DOTPATH="~/.${DOTPATH_NAME}"
GITHUB_URL="http://github.com/kajirikajiri/${DOTPATH_NAME}.git"
TARBALL="https://github.com/kajirikajiri/${DOTPATH_NAME}/archive/main.tar.gz"

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
