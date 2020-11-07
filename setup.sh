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

# zshがなければinstallする
if has "zsh"; then
  echo
  echo
  echo 'zsh is present!'
else
  sudo apt update
  sudo apt install -y zsh
  chsh -s $(which zsh) || true # for skipping in CI
  echo
  echo
  echo 'installed zsh'
fi

# golangがなければinstallする
if has "go"; then
  echo
  echo
  echo 'go is present!'
else
  sudo add-apt-repository ppa:longsleep/golang-backports
  sudo apt update
  sudo apt install -y golang-go
  go get github.com/x-motemen/ghq
  echo
  echo
  echo 'installed go'
fi

# fzfがなければinstallする
if has "fzf"; then
  echo
  echo
  echo 'fzf is present!'
else
  sudo apt-get update
  sudo apt-get install -y fzf
  echo
  echo
  echo 'installed fzf'
fi

# xeyes を使えるようにする
if has "google-chrome"; then
  echo
  echo
  echo 'google-chrome present!'
else
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y xfce4-terminal xfce4-session xfce4
  sudo apt-get update
  sudo apt-get install -y x11-apps
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
  sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo apt update
  sudo apt install -y google-chrome-stable
  echo
  echo
  echo 'installed google-chrome'
fi

# hub を使えるようにする
if has "hub"; then
  echo
  echo
  echo 'hub present!'
else
  sudo apt update
  sudo apt install -y hub
  echo
  echo
  echo 'installed hub'
fi

# yarn を使えるようにする
if has "yarn"; then
  echo 'yarn present!'
else
  sudo apt install -y nodejs npm
  sudo npm install n -g
  sudo n stable
  sudo apt purge -y nodejs npm
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update && sudo apt install -y yarn
  sudo apt purge -fy libuv1 nodejs
  echo 'installed yarn'
fi
