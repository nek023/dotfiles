# dotfiles

## Install on local

Make sure that `git` and `ruby` is installed.

```
$ git clone git@github.com:questbeat/dotfiles.git
$ cd dotfiles
$ make
```


## Install on remote

```
$ git clone git@github.com:questbeat/dotfiles.git
$ cd dotfiles
$ gem install bundler
$ bundle install --path=vendor/bundle
$ bundle exec itamae ssh --host HOST roles/linux/default.rb -y nodes/linux.yml
```

If you deploy to vagrant, use `--vagrant` option.

```
$ bundle exec itamae ssh --vagrant --host HOST roles/linux/default.rb -y nodes/linux.yml
```
