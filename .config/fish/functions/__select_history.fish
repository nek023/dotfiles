function __select_history
  set -l buffer (commandline)
  set -l cmd (history | fzf +m +s)
  test -n "$command" && commandline "$command"
  commandline -f repaint
end
