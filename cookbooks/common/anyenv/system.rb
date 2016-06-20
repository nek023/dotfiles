DEFAULT_SYSTEM_ANYENV_ROOT = '/usr/local/anyenv'.freeze

include_recipe './resources.rb'

def anyenv_root(attrs)
  return attrs[:anyenv_root] if attrs[:anyenv_root]
  DEFAULT_SYSTEM_ANYENV_ROOT
end

attrs = node[:anyenv]
anyenv_root = anyenv_root(attrs)

anyenv 'install anyenv' do
  anyenv_root anyenv_root
end

anyenv_update 'install anyenv-update' do
  anyenv_root anyenv_root
end

if attrs.has_key?(:envs)
  attrs[:envs].each do |env, vers|
    anyenv_env env do
      anyenv_root anyenv_root
    end

    next if vers.nil?

    vers.each do |ver|
      anyenv_env_version env do
        anyenv_root anyenv_root
        version ver
      end
    end

    unless vers.empty?
      anyenv_env_version env do
        action :global
        anyenv_root anyenv_root
        version vers.first
      end
    end
  end
end
