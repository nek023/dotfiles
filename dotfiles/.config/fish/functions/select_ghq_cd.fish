function select_ghq_cd
  commandline | read -l buffer
  ghq list --full-path | \
        sed -e "s|$HOME/||g" | \
        fzf --query "$buffer" | \
        read -l repository_path
  if test -n "$repository_path"
    commandline cd ~/(echo $repository_path | sed -e 's/ /\\ /g')
    commandline -f execute
  end
  commandline -f repaint
end
