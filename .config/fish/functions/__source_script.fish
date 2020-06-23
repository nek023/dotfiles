function __source_script -a script
    test -r $script && source $script
end
