# http://fnwiya.hatenablog.com/entry/2015/11/03/191902
# これで~/.zsh.d内にある*.zshという名称のファイルを読み込んでくれるので .zsh.dというフォルダを作り、alias.zshなどというファイル名で中身は通常通りzshの設定を記述します。
# 読み込み順はおそらくアルファベット順なので制御したい場合は01などと数字を振ればいいと思います（未検証）

ZSHHOME="${HOME}/.zsh.d"
if [ -d $ZSHHOME -a -r $ZSHHOME -a \
     -x $ZSHHOME ]; then
    for i in $ZSHHOME/*; do
        [[ ${i##*/} = *.zsh ]] &&
            [ \( -f $i -o -h $i \) -a -r $i ] && . $i
    done
fi
