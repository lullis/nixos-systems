{ tmuxPlugins, ... }:
{
  enable = true;
  plugins = with tmuxPlugins; [
    sensible
    yank
    {
      plugin = dracula;
      extraConfig = ''
          set -g @dracula-show-battery false
          set -g @dracula-show-network false
          set -g @dracula-show-weather false
          set -g @dracula-show-fahrenheit false
          set -g @dracula-show-powerline true
          set -g @dracula-show-flags true
          set -g @dracula-military-time true
          set -g @dracula-border-contrast true
          set -g @dracula-day-month true
        '';
    }
  ];

  extraConfig = ''
      # remap prefix from 'C-b' to 'C-a'
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix
      set -g status-keys emacs
      set -g mode-keys   emacs

      # split panes using | and -
      bind | split-window -h
      bind - split-window -v
      unbind '"'
      unbind %

      # switch panes using Alt-arrow without prefix
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D
      set -g mouse on
    '';
}
