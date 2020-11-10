#...

DOTPATH=~/.dotfiles-wsl2
GITHUB_URL="http://github.com/kajirikajiri/dotfiles-wsl2.git"
TARBALL="https://github.com/kajirikajiri/dotfiles-wsl2/archive/main.tar.gz"

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
  echo -e "\n"
  echo 'zsh is present!'
  echo -e "\n"
else
  sudo apt update
  sudo apt install -y zsh
  chsh -s $(which zsh) || true # for skipping in CI
  echo -e "\n"
  echo 'installed zsh'
  echo -e "\n"
fi

# zsh-autosuggestion
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

# golangがなければinstallする
if has "go"; then
  echo -e "\n"
  echo 'go is present!'
  echo -e "\n"
else
  sudo add-apt-repository ppa:longsleep/golang-backports
  sudo apt update
  sudo apt install -y golang-go
  go get github.com/x-motemen/ghq
  echo -e "\n"
  echo 'installed go'
  echo -e "\n"
fi

# fzfがなければinstallする
if has "fzf"; then
  echo -e "\n"
  echo 'fzf is present!'
  echo -e "\n"
else
	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
	~/.fzf/install
  echo -e "\n"
  echo 'installed fzf'
  echo -e "\n"
fi

# google-chrome を使えるようにする
if has "google-chrome"; then
  echo -e "\n"
  echo 'google-chrome present!'
  echo -e "\n"
else
  sudo apt update && sudo apt upgrade -y
  sudo apt install -y xfce4-terminal xfce4-session xfce4
  sudo apt-get update
  sudo apt-get install -y x11-apps
  sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
  sudo wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo apt update
  sudo apt install -y google-chrome-stable
  echo -e "\n"
  echo 'installed google-chrome'
  echo -e "\n"
fi

# hub を使えるようにする
if has "hub"; then
  echo -e "\n"
  echo 'hub present!'
  echo -e "\n"
else
  sudo apt update
  sudo apt install -y hub
  echo -e "\n"
  echo 'installed hub'
  echo -e "\n"
fi

# yarn を使えるようにする
if has "yarn"; then
  echo -e "\n"
  echo 'yarn present!'
  echo -e "\n"
else
  sudo apt install -y nodejs npm
  sudo npm install n -g
  sudo n stable
  sudo apt purge -y nodejs npm
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update && sudo apt install -y yarn
  sudo apt purge -fy libuv1 nodejs
  echo -e "\n"
  echo 'installed yarn'
  echo -e "\n"
fi


