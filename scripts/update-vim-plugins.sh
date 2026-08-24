#!/bin/bash

set -eu

SNAPSHOT="${HOME}/.vim/plug-snapshot.vim"

if [ ! -f ~/.vim/autoload/plug.vim ]; then
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi

if command -v vim >/dev/null 2>&1; then
  vim +PlugUpgrade +PlugUpdate +"PlugSnapshot! ${SNAPSHOT}" +qa

  # PlugSnapshot は 2 行目に生成時刻を書くので、更新が無くても差分になる。落とす。
  # stow の symlink を壊さないよう mv ではなくリダイレクトで上書きする。
  tmp="$(mktemp)"
  sed '2d' "${SNAPSHOT}" > "${tmp}"
  cat "${tmp}" > "${SNAPSHOT}"
  rm -f "${tmp}"
fi
