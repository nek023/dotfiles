function knife_solo_provision_target
  select_target_host | read -l target_host; \
    and vagrant destroy -f; \
    and vagrant up; \
    and vagrant snapshot take init; \
    and knife solo prepare $target_host; \
    and vagrant snapshot take prepared; \
    and knife solo cook $target_host; \
    and vagrant snapshot take cooked
end
