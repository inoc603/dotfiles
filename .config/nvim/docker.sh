TMP=/tmp/my-vim/tmp
mkdir -p $TMP/bin $TMP/share/nvim $TMP/lib
cp /usr/local/bin/nvim $TMP/bin/nvim
cp -r /usr/local/share/nvim $TMP/share/nvim
cp /usr/local/lib/libvterm* $TMP/lib

