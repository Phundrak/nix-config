{inputs, ...}: {
  flake.modules.homeManager.sops-user-phundrak = {config, ...}: {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      secrets."ssh/hosts" = {};
      age = {
        # automatically import user SSH keys as age keys
        sshKeyPaths = ["${config.home.homeDirectory}/.ssh/id_ed25519"];
        # this will use an age key that is expected to already be in the filesystem
        keyFile = "${config.home.homeDirectory}/.local/sops-nix/key.txt";
        # generate a new key if the key specified above does not exist
        generateKey = true;
      };
    };
  };
}
