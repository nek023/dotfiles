execute 'update installed packages' do
  command 'yum update -y'
end

node[:packages].each do |pkg|
  name, options = pkg.split(' ', 2)

  package name do
    options options if options
    not_if "rpm -q #{pkg}"
  end
end
