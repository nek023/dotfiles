function __select_history
  set -l buffer (commandline)
  set -l cmd (history | fzf +m +s)
  test -n "$cmd" && commandline "$cmd"
  commandline -f repaint
end
