{ pkgs, ... }:

{
  launchd.user.agents.ollama = {
    serviceConfig = {
      ProgramArguments = [ "${pkgs.ollama}/bin/ollama" "serve" ];
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "/tmp/ollama.out.log";
      StandardErrorPath = "/tmp/ollama.err.log";
    };
  };
}
