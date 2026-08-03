{ pkgs, ... }:

{
  home.file = {
    ".config/zsh/.zim/zimfw.zsh".source = "${pkgs.zimfw}/zimfw.zsh";
    ".local/share/zsh/git-prompt.sh".source =
      "${pkgs.git}/share/git/contrib/completion/git-prompt.sh";
  };
}
