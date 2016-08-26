function fish_prompt --description 'Write out the prompt'
	set -l last_status $status

	if not set -q __fish_prompt_hostname
		set -g __fish_prompt_hostname (hostname | cut -d . -f 1)
	end

	set -l minifish
	set -l minifish_color
	if test $last_status -eq 0
		set minifish '<・))><'
		set minifish_color blue
	else
		set minifish '<ｘ))><'
		set minifish_color red
	end

	set -l suffix
	switch $USER
	case root toor
		set suffix '#'
	case '*'
		set suffix '$'
	end

	echo -s (set_color green) "$USER" @ "$__fish_prompt_hostname" (set_color normal) : (set_color blue) (prompt_pwd) (set_color red) (__fish_git_prompt) (set_color 555) " [" (date '+%H:%M:%S') "]"
	echo -n -s (set_color $minifish_color) "$minifish " (set_color normal) "$suffix "
end
