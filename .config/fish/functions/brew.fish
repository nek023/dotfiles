function brew
    # 一時的にpyenvのconfig scriptにパスを通さないようにする
    env PATH=(string join : (string match -e pyenv/shims -v $PATH)) brew $argv
end
