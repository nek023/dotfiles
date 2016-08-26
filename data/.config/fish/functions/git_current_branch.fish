function git_current_branch
  set -l ref (command git symbolic-ref --quiet HEAD ^ /dev/null)
  if test $status != 0
    test $status -eq 128; and return # no git repo.
    set ref (command git rev-parse --short HEAD ^ /dev/null); or return
  end
  echo (string replace 'refs/heads/' '' $ref)
end
