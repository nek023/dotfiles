function benchmark
    argparse -n benchmark 'c/count=' -- $argv || return

    set -l cnt $_flag_count
    test -z "$cnt" && set cnt 1

    set -l cmd $argv
    if test -z "$cmd"
        echo 'usage: benchmark [--count=<num>] <command>'
        return
    end

    set -l sum 0 0 0
    for i in (seq 1 $cnt)
        set -l res (gtime -f "%U\t%S\t%e" $cmd 2>&1 > /dev/null | tail -n 1)
        for j in (seq 1 3)
            set sum[$j] (math $sum[$j] + (echo $res | cut -f $j))
        end
    end

    echo "cmd: $cmd"
    echo "cnt: $cnt"
    echo "usr:" (math $sum[1] \* 1000 / $cnt) ms
    echo "sys:" (math $sum[2] \* 1000 / $cnt) ms
    echo "rea:" (math $sum[3] \* 1000 / $cnt) ms
end
