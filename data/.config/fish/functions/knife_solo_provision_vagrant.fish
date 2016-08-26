function knife_solo_provision_vagrant
  __select_vagrant_host | read -l vagrant_host; \
    and vagrant destroy -f; \
    and vagrant up; \
    and vagrant snapshot take init; \
    and knife solo prepare $vagrant_host; \
    and vagrant snapshot take prepared; \
    and knife solo cook $vagrant_host; \
    and vagrant snapshot take cooked
end
