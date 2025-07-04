{
  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      # automatically import user SSH keys as age keys
      sshKeyPaths = [
        "/home/phundrak/.ssh/id_ed25519"
        "/etc/ssh/ssh_host_ed25519_key"
      ];
      # this will use an age key that is expected to already be in the filesystem
      keyFile = "/var/lib/sops-nix/key.txt";
      # generate a new key if the key specified above does not exist
      generateKey = true;
    };
  };
}
