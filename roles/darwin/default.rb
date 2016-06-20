include_recipe './defaults.rb'

include_recipe '../../cookbooks/darwin/xcode_command_line_tools/default.rb'
include_recipe '../../cookbooks/common/anyenv/user.rb'
include_recipe '../../cookbooks/darwin/homebrew/default.rb'
