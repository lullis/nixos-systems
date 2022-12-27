{
  enable = true;
  enableAutosuggestions = true;
  enableCompletion = true;
  enableSyntaxHighlighting = true;
  enableVteIntegration = true;
  defaultKeymap = "emacs";

  oh-my-zsh = {
    enable = true;
    plugins = ["ag" "docker" "docker-compose" "git" "git-flow" "sudo" ];
    theme = "refined";
  };
}
