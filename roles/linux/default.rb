include_recipe './system.rb'
include_recipe './user.rb'
include_recipe './packages.rb'

include_recipe '../../cookbooks/linux/git/default.rb'
include_recipe '../../cookbooks/common/anyenv/user.rb'
include_recipe '../../cookbooks/linux/tmux/default.rb'
include_recipe '../../cookbooks/linux/vim/default.rb'
