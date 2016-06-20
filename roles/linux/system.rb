# Configure sudoers
remote_file '/etc/sudoers' do
  owner 'root'
  group 'root'
  mode '440'
  source './files/sudoers'
end

# Configure locale
locale = node[:locale]
execute 'set locale' do
  command "localectl set-locale LANG=#{locale}"
end

# Configure timezone
timezone = node[:timezone]
execute 'set timezone' do
  command "timedatectl set-timezone #{timezone}"
end

# Configure firewall
service 'firewalld' do
  action :enable
end

service 'firewalld' do
  action :start
end

execute 'add http service to firewall' do
  command 'firewall-cmd --permanent --add-service=http --zone=public'
end

execute 'reload firewall configurations' do
  command 'firewall-cmd --reload'
end
