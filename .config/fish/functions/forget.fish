function forget -a num
    set -l known_hosts ~/.ssh/known_hosts
    cp $known_hosts "$known_hosts".bak
    sed "$num"d "$known_hosts".bak > $known_hosts
end
