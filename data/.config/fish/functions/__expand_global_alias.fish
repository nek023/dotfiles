function __expand_global_alias
  commandline    | read -l entire_buffer
  commandline -t | read -l alias_name
  echo "$entire_buffer" | string replace -r " $alias_name" '' | string trim | read -l command

  switch $alias_name
  case 'GH'
    git fzf | read -l git_hash
    commandline "$command $git_hash"
  case 'GST'
    __select_git_status | read -l files
    commandline "$command $files"
    commandline -f execute
  case 'RET'
    commandline "env RAILS_ENV=test $command"
  case 'SPEC'
    find ./spec -follow | fzf | read -l spec
    commandline "$command $spec"
    commandline -f execute
  case 'TH'
    __select_target_host | read -l host
    commandline "$command $host"
    commandline -f execute
  case 'VH'
    __select_vagrant_host | read -l host
    commandline "$command $host"
    commandline -f execute
  case '*'
    commandline -f execute
  end
  commandline -f repaint
end
