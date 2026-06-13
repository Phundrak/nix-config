{config, lib, ...}: {
  home.dev.ai = {
    enable = lib.mkDefault true;
    opencode = {
      tui = {
        mouse = true;
        theme = "nord";
        attention = {
          enabled = true;
          notifications = true;
        };
        keybinds = {
          leader = "ctrl+x";
          "command_list" = "<leader><leader>";
        };
      };
      settings = {
        autoupdate = false;
        provider = {
          ollama = {
            npm = "@ai-sdk/openai-compatible";
            name = "Ollama (marpa)";
            options.baseURL = "http://marpa:11434/v1";
          };
          models = {
            "qwen3.5:9b".name = "Qwen 3.5 Medium";
            "gemma4:e4b".name = "Gemma E4B";
            "qwen2.5-coder:1.5b-base".name = "Qwen 2.5 Coder Light";
          };
        };
        permission = {
          "*" = "ask";
          glob = "allow";
          grep = "allow";
          skill = "allow";
          question = "allow";
          read = {
            "*" = "allow";
            "*.env" = "deny";
            "*.env.*" = "deny";
            "*.env.example" = "allow";
          };
          "doom_loop" = "deny";
        };
        formatter.nixfmt = {
          command = ["nix" "fmt" "$FILE"];
          extensions = [".nix"];
        };
      };
      web = {
        enable = true;
        cors = config.sops.secrets."opencode/cors".path;
        mdns.enable = true;
      };
    };
  };
}
