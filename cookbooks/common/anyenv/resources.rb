ANYENV_REPO_URL = 'https://github.com/riywo/anyenv'.freeze
ANYENV_UPDATE_REPO_URL = 'https://github.com/znz/anyenv-update.git'.freeze

define :anyenv, action: :install, anyenv_root: nil do
  user = params[:user]
  anyenv_root = params[:anyenv_root]

  case params[:action]
  when :install
    git anyenv_root do
      user user if user
      repository ANYENV_REPO_URL
      not_if "test -d #{anyenv_root}"
    end
  end
end

define :anyenv_update, action: :install, anyenv_root: nil do
  user = params[:user]
  anyenv_root = params[:anyenv_root]
  anyenv_update_root = File.join(anyenv_root, 'plugins', 'anyenv-update')

  case params[:action]
  when :install
    git anyenv_update_root do
      user user if user
      repository ANYENV_UPDATE_REPO_URL
      not_if "test -d #{anyenv_update_root}"
    end
  end
end

define :anyenv_env, action: :install, anyenv_root: nil do
  user = params[:user]
  anyenv_root = params[:anyenv_root]
  env = params[:name]

  anyenv_bin_path = File.join(anyenv_root, '/bin')
  init_cmd =  %(export PATH=$PATH:#{anyenv_bin_path};)
  init_cmd << %(eval "$(anyenv init -)";)

  case params[:action]
  when :install
    execute "anyenv install #{env}" do
      user user if user
      command "#{init_cmd} yes | anyenv install #{env}"
      not_if "#{init_cmd} command -v #{env}"
    end
  end
end

define :anyenv_env_version, action: :install, anyenv_root: nil, version: nil do
  user = params[:user]
  anyenv_root = params[:anyenv_root]
  version = params[:version]
  env = params[:name]
  ver = params[:version]

  anyenv_bin_path = File.join(anyenv_root, '/bin')
  init_cmd =  %(export PATH=$PATH:#{anyenv_bin_path};)
  init_cmd << %(eval "$(anyenv init -)";)

  case params[:action]
  when :install
    execute "#{env} install #{ver}" do
      user user if user
      command "#{init_cmd} yes | #{env} install #{ver}"
      not_if "#{init_cmd} #{env} versions | grep #{ver}"
    end

  when :global
    execute "#{env} global #{ver}" do
      user user if user
      command "#{init_cmd} #{env} global #{ver}; #{env} rehash"
      not_if "#{init_cmd} #{env} global | grep #{ver}"
    end
  end
end
