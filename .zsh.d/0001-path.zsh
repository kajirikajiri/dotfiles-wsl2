export DISPLAY=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}'):0
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$PATH

