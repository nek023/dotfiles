{ ... }:

{
  services.ollama.enable = true;

  # The module leaves both of these unset, so launchd would start the agent
  # only on demand and discard its output.
  launchd.agents.ollama.config = {
    RunAtLoad = true;
    StandardOutPath = "/tmp/ollama.out.log";
    StandardErrorPath = "/tmp/ollama.err.log";
  };
}
