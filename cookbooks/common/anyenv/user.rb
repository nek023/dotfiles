include_recipe './resources.rb'

def anyenv_root(user, attrs)
  return attrs[:anyenv_root] if attrs[:anyenv_root]

  case node[:platform]
  when 'darwin'
    "/Users/#{user}/.anyenv"
  else
    "/home/#{user}/.anyenv"
  end
end

node[:anyenv][:users].each do |user, attrs|
  attrs = node[:anyenv].merge(attrs)
  anyenv_root = anyenv_root(user, attrs)

  anyenv 'install anyenv' do
    user user
    anyenv_root anyenv_root
  end

  anyenv_update 'install anyenv-update' do
    user user
    anyenv_root anyenv_root
  end

  next unless attrs.has_key?(:envs)

  attrs[:envs].each do |env, vers|
    anyenv_env env do
      user user
      anyenv_root anyenv_root
    end

    next if vers.nil?

    vers.each do |ver|
      anyenv_env_version env do
        user user
        anyenv_root anyenv_root
        version ver
      end
    end

    unless vers.empty?
      anyenv_env_version env do
        action :global
        user user
        anyenv_root anyenv_root
        version vers.first
      end
    end
  end
end
