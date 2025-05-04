{
  programs.wofi = {
    enable = true;
    settings = {
      modi = "ssh,drun,combi";
      sidebar-mode = false;
      width = 30;
      line-margin = 10;
      lines = 6;
      columns = 2;
      display-ssh = "";
      display-run = "";
      display-drun = "";
      display-window = "";
      display-combi = "";
      show-icons = true;
    };
    # from https://github.com/alxndr13/wofi-nord-theme
    style = ''
      * {
        font-family: "Hack", monospace;
      }

      window {
        background-color: #3B4252;
      }

      #input {
        margin: 5px;
        border-radius: 0px;
        border: none;
        background-color: #3B4252;
        color: white;
      }

      #inner-box {
        background-color: #383C4A;
      }

      #outer-box {
        margin: 2px;
        padding: 10px;
        background-color: #383C4A;
      }

      #scroll {
        margin: 5px;
      }

      #text {
        padding: 4px;
        color: white;
      }

      #entry:nth-child(even){
        background-color: #404552;
      }

      #entry:selected {
        background-color: #4C566A;
      }

      #text:selected {
        background: transparent;
      }
    '';
  };
}
