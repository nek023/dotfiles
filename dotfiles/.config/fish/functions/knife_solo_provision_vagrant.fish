function knife_solo_provision_vagrant
  select_vagrant_host | read -l vagrant_host; vagrant destroy -f && vagrant up && krepare $vagrant_host && kook $vagrant_host
end
