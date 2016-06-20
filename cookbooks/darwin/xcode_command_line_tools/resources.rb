define :xcode_command_line_tools, action: :install do
  user = params[:user]

  command = <<'EOS'
xcode-select --install
while :
do
  xcode-select -p
  if [ $? -eq 0 ]; then
    break
  fi
  sleep 5
done
EOS

  case params[:action]
  when :install
    execute 'install Xcode command line tools' do
      user user if user
      command command
      not_if 'xcode-select -p'
    end
  end
end
