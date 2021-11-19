# .zlogin

# Launch fish shell
FISH_PATH=$(which fish)
test -x "$FISH_PATH" && exec -l "$FISH_PATH"
