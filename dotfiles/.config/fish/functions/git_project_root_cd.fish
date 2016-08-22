function git_project_root_cd
  cd ./(git rev-parse --show-cdup)
end
