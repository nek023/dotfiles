include_recipe '../install_from_source/default.rb'

# Remove vim if it's already installed via package manager
package 'vim' do
  action :remove
end

# Install vim
version = node[:vim][:version]
url = "https://github.com/vim/vim/archive/v#{version}.tar.gz"

install_script = './configure && make && sudo make install'
if node[:vim] && node[:vim][:configure_options]
  options = node[:vim][:configure_options]
  install_script = "./configure #{options} && make && sudo make install"
end

install_from_source 'vim' do
  source_url url
  install_script install_script
end
