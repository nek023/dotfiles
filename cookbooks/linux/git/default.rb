include_recipe '../install_from_source/default.rb'

# Remove git if it's already installed via package manager
package 'git' do
  action :remove
end

# Install dependencies
%w[
  curl-devel
  expat-devel
  gettext-devel
  openssl-devel
  zlib-devel
  perl-ExtUtils-MakeMaker
].each do |pkg|
  package pkg do
    not_if "rpm -q #{pkg}"
  end
end

# Install git
version = node[:git][:version]
url = "https://github.com/git/git/archive/v#{version}.tar.gz"
install_script = 'make prefix=/usr/local all && sudo make prefix=/usr/local install'

install_from_source 'git' do
  source_url url
  install_script install_script
end
