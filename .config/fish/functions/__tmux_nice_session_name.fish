function __tmux_nice_session_name
  set num 0
  for name in (tmux ls -F "#{session_name}" | string join0 | sort -z | string split0)
    if string match -qr '^\d+$' -- $name
      if test $num -lt (math $name)
        break
      else
        set num (math $num + 1)
      end
    end
  end
  echo $num
end
