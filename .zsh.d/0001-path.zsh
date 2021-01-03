export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export GOPATH=$HOME/go
export YARN_GLOBAL=$(yarn global bin)
export PATH=$GOPATH/bin:$YARN_GLOBAL:$PATH
export BROWSER="wslview"

