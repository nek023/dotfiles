include_recipe './resources.rb'

user = node[:user]

node[:homebrew][:repositories].each do |repo|
  homebrew_repository repo do
    user user if user
  end
end

node[:homebrew][:packages].each do |pkg|
  name, options = pkg.split(' ', 2)
  
  homebrew_package name do
    user user if user
    options options if options
  end
end
