function benchmark
    argparse -n benchmark 'c/count=' -- $argv || return

    set -l cnt $_flag_count
    test -z "$cnt" && set cnt 1

    if test -z "$argv"
        echo 'usage: benchmark [--count=<num>] <command>'
        return
    end

    set -l sum 0
    for i in (seq 1 $cnt)
        set res (gtime -f "%e" $argv 2>&1 | tail -n 1)
        set sum (math $sum + (gtime -f "%e" $argv 2>&1 > /dev/null | tail -n 1))
    end

    echo (math $sum \* 1000 / $cnt) ms
end
