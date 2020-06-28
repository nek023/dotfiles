function __ghq_cd
    set -l buffer (commandline)
    set -l repo_path (ghq list -p | sed -e "s|$HOME/||g" | fzf -q "$buffer")
    if test -n "$repo_path"
        commandline "cd ~/$repo_path"
        commandline -f execute
    end
    commandline -f repaint
end
