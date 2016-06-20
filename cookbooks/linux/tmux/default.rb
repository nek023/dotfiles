include_recipe '../install_from_source/default.rb'

# Remove tmux if it's already installed via package manager
package 'tmux' do
  action :remove
end

# Install dependencies
%w[
  gcc
  kernel-devel
  libevent-devel
  make
  ncurses-devel
].each do |pkg|
  package pkg do
    not_if "rpm -q #{pkg}"
  end
end

# Install tmux
version = node[:tmux][:version]
url = "https://github.com/tmux/tmux/releases/download/#{version}/tmux-#{version}.tar.gz"

install_from_source 'tmux' do
  source_url url
end
