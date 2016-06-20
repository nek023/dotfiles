include_recipe './resources.rb'

user = node[:user]

xcode_command_line_tools 'install Xcode command line tools' do
  user user if user
end
