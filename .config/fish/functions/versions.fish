function versions -a lang
    set -l files (find (ghq root) -name ".$lang-version" -type f -maxdepth 4)
    if test (count $files) -gt 0
        cat $files | sort | uniq
    end
end
