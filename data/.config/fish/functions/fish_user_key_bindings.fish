function fish_user_key_bindings
  bind \c{ backward-word
  bind \c} forward-word

  bind \cj __expand_global_alias
  bind \r  __expand_global_alias
end
