function __git_dir_path
  if test -d .git
    echo $PWD/.git;
  else
    git rev-parse --git-dir ^ /dev/null;
  end
end
