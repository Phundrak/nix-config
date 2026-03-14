{lib, ...}: {
  home.shell.zellij = with lib; {
    enable = true;
    clearDefaultKeybinds = true;
    useUnlockFirst = true;
    settings.copy_on_select = true;
    extraSettings = ''
      plugins {
          about location="zellij:about"
          compact-bar location="zellij:compact-bar"
          configuration location="zellij:configuration"
          filepicker location="zellij:strider" {
              cwd "/"
          }
          plugin-manager location="zellij:plugin-manager"
          session-manager location="zellij:session-manager"
          status-bar location="zellij:status-bar"
          strider location="zellij:strider"
          tab-bar location="zellij:tab-bar"
          welcome-screen location="zellij:session-manager" {
              welcome_screen true
          }
      }
    '';
    keybinds = let
      # bépo layout
      left = ["c" "Left"];
      down = ["t" "Down"];
      up = ["s" "Up"];
      right = ["r" "Right"];
      numRow = ["\"" "«" "»" "(" ")" "@" "+" "-" "/" "*"];
    in {
      locked = [
        {
          bind = "Ctrl Alt g";
          actions = {SwitchToMode = "normal";};
        }
      ];
      pane = [
        {
          bind = left;
          actions = {MoveFocus = "Left";};
        }
        {
          bind = down;
          actions = {MoveFocus = "Down";};
        }
        {
          bind = up;
          actions = {MoveFocus = "Up";};
        }
        {
          bind = right;
          actions = {MoveFocus = "Right";};
        }
        {
          bind = "n";
          actions = {NewPane = [];};
          useUnlockFirst = true;
        }
        {
          bind = "T";
          actions = {NewPane = "Down";};
          useUnlockFirst = true;
        }
        {
          bind = "R";
          actions = {NewPane = "Right";};
          useUnlockFirst = true;
        }
        {
          bind = "S";
          actions = {NewPane = "stacked";};
          useUnlockFirst = true;
        }
        {
          bind = "N";
          actions = {SwitchToMode = "normal";};
        }
        {
          bind = "e";
          actions = {TogglePaneEmbedOrFloating = [];};
          useUnlockFirst = true;
        }
        {
          bind = "i";
          actions = {TogglePanePinned = [];};
        }
        {
          bind = "f";
          actions = {ToggleFocusFullscreen = [];};
          useUnlockFirst = true;
        }
        {
          bind = "F";
          actions = {ToggleFloatingPanes = [];};
        }
        {
          bind = "q";
          actions = {CloseFocus = [];};
          useUnlockFirst = true;
        }
        {
          bind = "p";
          actions = {SwitchToMode = "normal";};
        }
        {
          bind = "P";
          actions = {
            SwitchToMode = "renamepane";
            PaneNameInput = 0;
          };
        }
        {
          bind = "z";
          actions = {TogglePaneFrames = [];};
          useUnlockFirst = true;
        }
        {
          bind = "tab";
          actions = {SwitchFocus = [];};
        }
      ];
      resize = [
        {
          bind = "n";
          actions = {SwitchToMode = "locked";};
        }
        {
          bind = left;
          actions = {Resize = "Increase Left";};
        }
        {
          bind = down;
          actions = {Resize = "Increase Down";};
        }
        {
          bind = up;
          actions = {Resize = "Increase Up";};
        }
        {
          bind = right;
          actions = {Resize = "Increase Right";};
        }
        {
          bind = "C";
          actions = {Resize = "Decrease Left";};
        }
        {
          bind = "T";
          actions = {Resize = "Decrease Down";};
        }
        {
          bind = "S";
          actions = {Resize = "Decrease Up";};
        }
        {
          bind = "R";
          actions = {Resize = "Decrease Right";};
        }
        {
          bind = "+";
          actions = {Resize = "Increase";};
        }
        {
          bind = "-";
          actions = {Resize = "Decrease";};
        }
      ];
      move = [
        {
          bind = left;
          actions = {MovePane = "left";};
        }
        {
          bind = down;
          actions = {MovePane = "down";};
        }
        {
          bind = up;
          actions = {MovePane = "up";};
        }
        {
          bind = right;
          actions = {MovePane = "right";};
        }
        {
          bind = "m";
          actions = {SwitchToMode = "normal";};
        }
        {
          bind = ["n" "tab"];
          actions = {MovePane = [];};
        }
        {
          bind = "p";
          actions = {MovePaneBackwards = [];};
        }
      ];
      tab =
        [
          {
            bind = left ++ up;
            actions = {GoToPreviousTab = [];};
          }
          {
            bind = down ++ right;
            actions = {GoToNextTab = [];};
          }
          {
            bind = "[";
            actions = {BreakPaneLeft = [];};
            useUnlockFirst = true;
          }
          {
            bind = "]";
            actions = {BreakPaneRight = [];};
            useUnlockFirst = true;
          }
          {
            bind = "b";
            actions = {BreakPane = [];};
            useUnlockFirst = true;
          }
          {
            bind = "n";
            actions = {NewTab = [];};
            useUnlockFirst = true;
          }
          {
            bind = "R";
            actions = {
              SwitchToMode = "renametab";
              TabNameInput = 0;
            };
          }
          {
            bind = "s";
            actions = {ToggleActiveSyncTab = [];};
            useUnlockFirst = true;
          }
          {
            bind = "T";
            actions = {SwitchToMode = "normal";};
          }
          {
            bind = "x";
            actions = {CloseTab = [];};
            useUnlockFirst = true;
          }
          {
            bind = "tab";
            actions = {ToggleTab = [];};
          }
        ]
        ++ (lists.imap1 (i: key: {
            bind = key;
            actions = {GoToTab = i;};
            useUnlockFirst = true;
          })
          numRow);
    };
  };
}
