define :install_from_source, cwd: '/usr/local/src', source_url: nil, install_script: './configure && make && sudo make install' do
  name = params[:name]
  user = params[:user]
  cwd = params[:cwd]
  source_url = params[:source_url]
  install_script = params[:install_script]

  file_name = "#{name}-#{File.basename(source_url)}"
  dir_name = "#{file_name}-extracted"

  execute "download #{name}" do
    user user if user
    cwd cwd
    command "wget #{source_url} -O #{file_name}"
  end

  directory "#{dir_name}" do
    user user if user
    cwd cwd
  end

  execute "unarchive #{name}" do
    user user if user
    cwd cwd
    command "tar xvf #{file_name} -C #{dir_name} --strip-components=1"
  end

  execute "install #{name}" do
    user user if user
    cwd File.join(cwd, dir_name)
    command install_script
  end
end
