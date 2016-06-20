BREW_INSTALL_URL = 'https://raw.githubusercontent.com/Homebrew/install/master/install'.freeze
BREW_UNINSTALL_URL = 'https://raw.githubusercontent.com/Homebrew/install/master/uninstall'.freeze

define :homebrew, action: :install do
  user = params[:user]

  case params[:action]
  when :install
    execute 'install homebrew' do
      user user if user
      command "ruby -e \"$(curl -fsSL #{BREW_INSTALL_URL})\""
      not_if "command -v brew"
    end

  when :uninstall
    execute 'uninstall homebrew' do
      user user if user
      command "ruby -e \"$(curl -fsSL #{BREW_UNINSTALL_URL})\""
      only_if "command -v brew"
    end
  end
end

define :homebrew_repository, action: :tap do
  name = params[:name]
  user = params[:user]

  case params[:action]
  when :tap
    execute "brew tap #{name}" do
      user user if user
      command "brew tap #{name}"
      not_if "brew tap | grep #{name}"
    end

  when :untap
    execute "brew untap #{name}" do
      user user if user
      command "brew untap #{name}"
      only_if "brew tap | grep #{name}"
    end
  end
end

define :homebrew_package, action: :install, options: nil do
  name = params[:name]
  user = params[:user]
  options = params[:options]

  name_with_opts = options ? "#{name_with_opts} #{options}" : name
  case params[:action]
  when :install
    execute "brew install #{name_with_opts}" do
      user user if user
      command "brew install #{name_with_opts}"
      not_if "brew list | grep #{name}"
    end

  when :uninstall
    execute "brew uninstall #{name}" do
      user user if user
      command "brew uninstall #{name}"
      only_if "brew list | grep #{name}"
    end

  when :upgrade
    execute "brew upgrade #{name}" do
      user user if user
      command "brew upgrade #{name}"
      only_if "brew list | grep #{name}"
    end
  end
end
