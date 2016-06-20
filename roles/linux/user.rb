require 'unix_crypt'

user = node[:user]

user 'create user' do
  username user
  password UnixCrypt::SHA256.build(user)
end

execute "add #{user} to wheel" do
  command "usermod -G wheel #{user}"
end

directory "/home/#{user}/.ssh" do
  owner user
  group user
  mode '700'
end

file "/home/#{user}/.ssh/authorized_keys" do
  owner user
  group user
  mode '600'
end
