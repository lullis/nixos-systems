{ pythonElpy, ... }:
{
  enable = true;

  init = {
    enable = true;
    recommendedGcSettings = true;

    prelude = ''
        ;; Disable startup message.
        (setq inhibit-startup-message t
              inhibit-startup-echo-area-message (user-login-name))

        (setq initial-major-mode 'fundamental-mode
              initial-scratch-message nil)

        ;; Set frame title.
        (setq frame-title-format
              '("" invocation-name ": "(:eval
                                        (if (buffer-file-name)
                                            (abbreviate-file-name (buffer-file-name))
                                          "%b"))))

        ;; Disable some GUI distractions.
        (tool-bar-mode -1)
        (scroll-bar-mode -1)
        (menu-bar-mode -1)
        (blink-cursor-mode 0)

        ;; Accept 'y' and 'n' rather than 'yes' and 'no'.
        (defalias 'yes-or-no-p 'y-or-n-p)

        ;; Don't want to move based on visual line.
        (setq line-move-visual nil)

        ;; Stop creating backup and autosave files.
        (setq make-backup-files nil
              auto-save-default nil)

        ;; Always show line and column number in the mode line.
        (line-number-mode)
        (column-number-mode)

        ;; Enable some features that are disabled by default.
        (put 'narrow-to-region 'disabled nil)

        ;; Typically, I only want spaces when pressing the TAB key. I also
        ;; want 4 of them.
        (setq-default indent-tabs-mode nil
                      tab-width 4
                      c-basic-offset 4)

        ;; Trailing white space are banned!
        (setq-default show-trailing-whitespace t)
        (add-to-list 'write-file-functions 'delete-trailing-whitespace)

        ;; Make a reasonable attempt at using one space sentence separation.
        (setq sentence-end "[.?!][]\"')}]*\\($\\|[ \t]\\)[ \t\n]*"
              sentence-end-double-space nil)

        ;; I typically want to use UTF-8.
        (prefer-coding-system 'utf-8)

        ;; Nicer handling of regions.
        (transient-mark-mode 1)

        ;; Make moving cursor past bottom only scroll a single line rather
        ;; than half a page.
        (setq scroll-step 1
              scroll-conservatively 5)

        ;; Improved handling of clipboard in GNU/Linux and otherwise.
        (setq select-enable-clipboard t
              select-enable-primary t
              save-interprogram-paste-before-kill t)

        ;; Pasting with middle click should insert at point, not where the
        ;; click happened.
        (setq mouse-yank-at-point t)

        ;; Enable a few useful commands that are initially disabled.
        (put 'upcase-region 'disabled nil)
        (put 'downcase-region 'disabled nil)

        ;; When finding file in non-existing directory, offer to create the
        ;; parent directory.
        (defun with-buffer-name-prompt-and-make-subdirs ()
          (let ((parent-directory (file-name-directory buffer-file-name)))
            (when (and (not (file-exists-p parent-directory))
                       (y-or-n-p (format "Directory `%s' does not exist! Create it? " parent-directory)))
              (make-directory parent-directory t))))

        (add-to-list 'find-file-not-found-functions #'with-buffer-name-prompt-and-make-subdirs)

        ;; Shouldn't highlight trailing spaces in terminal mode.
        (add-hook 'term-mode (lambda () (setq show-trailing-whitespace nil)))
        (add-hook 'term-mode-hook (lambda () (setq show-trailing-whitespace nil)))

        ;; Global shortcuts and keybindings
        (global-set-key [(shift f1)] 'call-last-kbd-macro)
      '';

    usePackage = {
      abbrev = {
        enable = true;
        diminish = [ "abbrev-mode" ];
        command = [ "abbrev-mode" ];
      };

      ag = { enable = true; };

      alchemist = {
        enable = true;
      };

      adoc-mode = {
        enable = true;
        mode = [ ''"\\.txt\\'"'' ''"\\.adoc\\'"'' ];
      };

      ansi-color = {
        enable = true;
        command = [ "ansi-color-apply-on-region" ];
      };

      autorevert = {
        enable = true;
        diminish = [ "auto-revert-mode" ];
        command = [ "auto-revert-mode" ];
      };

      beacon = {
        enable = true;
        command = [ "beacon-mode" ];
        diminish = [ "beacon-mode" ];
        defer = 1;
        config = "(beacon-mode 1)";
      };

      blacken = {
        enable = true;
        hook = ["(python-mode . blacken-mode)"];
      };

      cc-mode = {
        enable = true;
        defer = true;
        hook = [''
            (c-mode-common . (lambda ()
                               (subword-mode)
                               (c-set-offset 'arglist-intro '++)))
          ''];
      };

      deadgrep = {
        enable = true;
        bind = { "C-x f" = "deadgrep"; };
      };

      diff-hl = { enable = true; };

      direnv = {
        enable = true;
        command = [ "direnv-mode" "direnv-update-environment" ];
      };

      dockerfile-mode = {
        enable = true;
        mode = [ ''"Dockerfile\\'"'' ];
      };

      doom-themes = {
        enable = true;
        config = ''
            ;; Global settings (defaults)
            (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
                  doom-themes-enable-italic t) ; if nil, italics is universally disabled
            (load-theme 'doom-dracula t)
          '';
      };

      drag-stuff = {
        enable = true;
        bind = {
          "M-<up>" = "drag-stuff-up";
          "M-<down>" = "drag-stuff-down";
        };
      };

      dumb-jump = {
        enable = true;
      };

      easy-hugo = {
        enable = true;
        config = ''
            (setq easy-hugo-basedir "~/code/personal/site/")
            (setq easy-hugo-url "https://raphael.lullis.net")
            (setq easy-hugo-postdir "content/post")
            (setq easy-hugo-amazon-s3-bucket-name "net.lullis.raphael")
            (setq easy-hugo-previewtime "300")

            (setq easy-hugo-bloglist
                  '(
                  ;; Communick Blog
                  (
                    (easy-hugo-basedir . "~/code/communick/blog/")
                    (easy-hugo-url . "https://blog.communick.com")
                    (easy-hugo-postdir . "content/posts")
                    (easy-hugo-amazon-s3-bucket-name . "communick.blog")
                  )

                  ;; Hub20 Blog
                  (
                    (easy-hugo-basedir . "~/code/hub20/dev/blog/")
                    (easy-hugo-url . "https://blog.hub20.io")
                    (setq easy-hugo-postdir "content")
                  )
                  ))
             '';
      };

      ediff = {
        enable = true;
        defer = true;
        config = ''
            (setq ediff-window-setup-function 'ediff-setup-windows-plain)
          '';
      };

      eldoc = {
        enable = true;
        diminish = [ "eldoc-mode" ];
        command = [ "eldoc-mode" ];
      };

      elpy = {
        enable = true;
        hook = ["(after-init . elpy-enable)"];
        config = ''
            ;; Leave C-c C-s for project search
            (unbind-key "C-c C-s" elpy-mode-map)
            (unbind-key "C-c C-f" elpy-mode-map)

            ;; Use the virtualenv with all required packages
            (setq elpy-rpc-virtualenv-path "${pythonElpy}")
            (add-hook 'elpy-mode-hook (lambda ()
                      (add-hook 'before-save-hook
                      'elpy-black-fix-code nil t)))

            ;; Jump to definition is broken on elpy 1.35. Revisit this after the issue on
            ;; https://github.com/jorgenschaefer/elpy/issues/1795#issuecomment-816889633
            ;; is solved. Recommended workaround is to use dump-jump.
            (advice-add 'elpy--xref-backend :override #'dumb-jump-xref-activate)
          '';
      };

      # Enable Electric Indent mode to do automatic indentation on RET.
      electric = {
        enable = true;
        command = [ "electric-indent-local-mode" ];
        hook = [
          "(prog-mode . electric-indent-mode)"

          # Disable for some modes.
          "(nix-mode . (lambda () (electric-indent-local-mode -1)))"
        ];
      };

      etags = {
        enable = true;
        defer = true;
        # Avoid spamming reload requests of TAGS files.
        config = "(setq tags-revert-without-query t)";
      };

      groovy-mode = {
        enable = true;
        mode = [ ''"\\.gradle\\'"'' ''"\\.groovy\\'"'' ''"Jenkinsfile\\'"'' ];
      };

      scss-mode = {
        enable = true;
        config = "(setq css-indent-offset 2)";
      };

      # Javascript Development

      add-node-modules-path = {
        enable = true;
      };

      js = {
        enable = true;
        mode = [ ''("\\.js\\'" . js-mode)'' ''("\\.json\\'" . js-mode)'' ''("\\.mjs\\'" . js-mode)''];
        config = ''
            (setq js-indent-level 2)
          '';
      };

      json-mode = {
        enable = true;
      };

      prettier-js = {
        enable = true;
        config = ''
            ;; prettier is installed on NODE_PATH, so we need to make
            ;; it available to emacs via add-node-modules-path
            (setq prettier-js-args '(
              "--semi" "false"
              "--single-quote" "true"
              "--bracket-spacing" "false"
              "--print-width" "96"
              "--trailing-comma" "es5"
              "--arrow-parens" "avoid"
            ))
          '';
      };

      typescript-mode = {
        enable = true;
        mode = [ ''("\\.ts\\'" . typescript-mode)''];
      };

      tide = {
        enable = true;
        after = ["typescript-mode" "company" "flycheck" ];
        hook = [
          "(typescript-mode . tide-setup)"
          "(typescript-mode . tide-hl-identifier-mode)"
        ];
      };

      vue-mode = {
        enable = true;
        mode = [ ''("\\.vue\\'" . vue-mode)'' ];
        hook = [ "(vue-mode . lsp)" ];

        config = ''
            (setq vue-html-tab-width 2)
            (rainbow-mode)
          '';
        bind = {
          "C-c C-l" = "vue-mode-reparse";
          "C-c C-e" = "vue-mode-edit-indirect-at-point";
        };
      };

      notifications = {
        enable = true;
        command = [ "notifications-notify" ];
      };

      # Remember where we where in a previously visited file. Built-in.
      saveplace = {
        enable = true;
        config = ''
            (setq-default save-place t)
            (setq save-place-file (locate-user-emacs-file "places"))
          '';
      };

      # More helpful buffer names. Built-in.
      uniquify = {
        enable = true;
        config = ''
            (setq uniquify-buffer-name-style 'post-forward)
          '';
      };

      which-key = {
        enable = true;
        defer = 2;
        config = "(which-key-mode)";
      };

      # Enable winner mode. This global minor mode allows you to
      # undo/redo changes to the window configuration. Uses the
      # commands C-c <left> and C-c <right>.
      winner = {
        enable = true;
        config = "(winner-mode 1)";
      };

      writeroom-mode = {
        enable = true;
        command = [ "writeroom-mode" ];
        bind = {
          "M-[" = "writeroom-decrease-width";
          "M-]" = "writeroom-increase-width";
        };
        hook = [ "(writeroom-mode . visual-line-mode)" ];
      };

      buffer-move = {
        enable = true;
        bind = {
          "C-S-<up>" = "buf-move-up";
          "C-S-<down>" = "buf-move-down";
          "C-S-<left>" = "buf-move-left";
          "C-S-<right>" = "buf-move-right";
        };
      };

      counsel = {
        enable = true;
        bind = {
          "C-x C-d" = "counsel-dired-jump";
          "C-x C-r" = "counsel-recentf";
          "C-x C-y" = "counsel-yank-pop";
        };
        diminish = [ "counsel-mode" ];
      };

      counsel-projectile = {
        enable = true;
        bind = {
          "C-c C-s" = "counsel-projectile-ag";
          "C-c C-f" = "counsel-projectile-find-file";
        };
      };

      # Configure magit, a nice mode for the git SCM.
      magit = {
        enable = true;
        bind = { "C-c g" = "magit-status"; };
        config = ''
            (add-to-list 'git-commit-style-convention-checks
                         'overlong-summary-line)
          '';
      };

      magit-gitflow = {
        enable = true;
        hook = [ "(magit-mode . turn-on-magit-gitflow)"];
      };

      git-messenger = {
        enable = true;
        bind = { "C-x v p" = "git-messenger:popup-message"; };
      };

      nix-sandbox = {
        enable = true;
        command = [ "nix-current-sandbox" "nix-shell-command" ];
      };

      lsp-ui = {
        enable = true;
        command = [ "lsp-ui-mode" ];
        bind = {
          "C-c r d" = "lsp-ui-doc-show";
          "C-c f s" = "lsp-ui-find-workspace-symbol";
        };
        config = ''
            (setq lsp-ui-sideline-enable t
                  lsp-ui-sideline-show-symbol nil
                  lsp-ui-sideline-show-hover nil
                  lsp-ui-sideline-show-code-actions nil
                  lsp-ui-sideline-update-mode 'point
                  lsp-ui-doc-enable nil)
          '';
      };

      lsp-ui-flycheck = {
        enable = true;
        command = [ "lsp-ui-flycheck-enable" ];
        after = [ "flycheck" "lsp-ui" ];
      };

      lsp-mode = {
        enable = true;
        command = [ "lsp" ];
        bind = {
          "C-c r r" = "lsp-rename";
          "C-c r f" = "lsp-format-buffer";
          "C-c r g" = "lsp-format-region";
          "C-c r a" = "lsp-execute-code-action";
          "C-c f r" = "lsp-find-references";
        };
        config = ''
            (setq lsp-eldoc-render-all nil
                  lsp-prefer-flymake nil)
          '';
      };

      lsp-rust = {
        enable = true;
        hook = [''
            (rust-mode . (lambda ()
                           (direnv-update-environment)
                           (lsp)))
          ''];
      };

      markdown-mode = {
        enable = true;
        mode = [ ''"\\.mdwn\\'"'' ''"\\.markdown\\'"'' ''"\\.md\\'"'' ];
      };

      pandoc-mode = {
        enable = true;
        after = [ "markdown-mode" ];
        hook = [ "markdown-mode" ];
        bindLocal = {
          markdown-mode-map = { "C-c C-c" = "pandoc-run-pandoc"; };
        };
      };

      nix-mode = {
        enable = true;
        mode = [ ''"\\.nix\\'"'' ];
        hook = [ "(nix-mode . subword-mode)" ];
      };

      rainbow-mode = { enable = true; };

      # Use ripgrep for fast text search in projects. I usually use
      # this through Projectile.
      ripgrep = {
        enable = true;
        command = [ "ripgrep-regexp" ];
      };

      org = {
        enable = true;
        bind = {
          "C-c c" = "org-capture";
          "C-c a" = "org-agenda";
          "C-c l" = "org-store-link";
          "C-c b" = "org-switchb";
        };
        hook = [''
            (org-mode
             . (lambda ()
                 (add-hook 'completion-at-point-functions
                           'pcomplete-completions-at-point nil t)))
          ''];
        config = ''

            (setq org-agenda-files '("~/.sync/personal/agenda"))
            (setq org-archive-location '("~/.sync/personal/archive"))

            (setq org-agenda-custom-commands
                  '(("c" "Simple agenda view"
                    ((tags "PRIORITY=\"A\""
                    ((org-agenda-skip-function '(org-agenda-skip-entry-if 'todo 'done))
                    (org-agenda-overriding-header "High-priority unfinished tasks:")))
                    (agenda "")
                    (alltodo "")))))


            ;; Some general stuff.
            (setq org-reverse-note-order t
                  org-use-fast-todo-selection t)

            ;; Add some todo keywords.
            (setq org-todo-keywords
                  '((sequence "TODO(t)"
                              "STARTED(s!)"
                              "WAITING(w@/!)"
                              "DELEGATED(@!)"
                              "|"
                              "DONE(d!)"
                              "CANCELED(c@!)")))

            ;; Unfortunately org-mode tends to take over keybindings that
            ;; start with C-c.
            (unbind-key "C-c SPC" org-mode-map)
            (unbind-key "C-c w" org-mode-map)
          '';
      };

      org-roam = {
        enable = true;
        after = ["org"];
        bind = {
          "C-c n f" = "org-roam-node-find";
          "C-c n g" = "org-roam-graph";
          "C-c n r" = "org-roam-node-random";
        };
        config = ''
            (setq org-roam-v2-ack t)
            (org-roam-directory (file-truename "~/notes"))
            (org-roam-setup)
          '';
      };

      fill-column-indicator = {
        enable = true;
        command = [ "fci-mode" ];
        defer = true;
      };

      flycheck = {
        enable = true;
        diminish = [ "flycheck-mode" ];
        command = [ "global-flycheck-mode" ];
        defer = true;
        config = ''
            ;; Only check buffer when mode is enabled or buffer is saved.
            (setq flycheck-check-syntax-automatically '(mode-enabled save))
            (setq-default flycheck-disabled-checkers '(python-pylint))

            ;; Enable flycheck in all eligible buffers.
            (global-flycheck-mode)
          '';
      };

      projectile = {
        enable = true;
        diminish = [ "projectile-mode" ];
        command = [ "projectile-mode" ];
        bindKeyMap = {
          "s-p" = "projectile-command-map";
          "C-c p" = "projectile-command-map";
        };
        config = ''
            (setq projectile-project-search-path '("~/code/"))
            (setq projectile-enable-caching t
                  projectile-completion-system 'default)
            (projectile-mode 1)
          '';
      };

      plantuml-mode = {
        enable = true;
        mode = [ ''"\\.puml\\'"'' ];
      };

      company = {
        enable = true;
        diminish = [ "company-mode" ];
        hook = [ "(after-init . global-company-mode)" ];
        extraConfig = ''
            :bind (:map company-mode-map
                        ([remap completion-at-point] . company-complete-common)
                        ([remap complete-symbol] . company-complete-common))
          '';
        config = ''
            (setq company-idle-delay 0.5
                  company-show-numbers t)
          '';
      };

      company-dabbrev = {
        enable = true;
        after = [ "company" ];
        command = [ "company-dabbrev" ];
        config = ''
            (setq company-dabbrev-downcase nil
                  company-dabbrev-ignore-case t)
          '';
      };

      company-quickhelp = {
        enable = true;
        after = [ "company" ];
        command = [ "company-quickhelp-mode" ];
        config = ''
            (company-quickhelp-mode 1)
          '';
      };

      company-restclient = {
        enable = true;
        after = [ "company" "restclient" ];
        command = [ "company-restclient" ];
        config = ''
            (add-to-list 'company-backends 'company-restclient)
          '';
      };

      go-mode = {
        enable = true;
        hook = [
          ''('go-mode . 'lsp-deferred)''
        ];
      };

      protobuf-mode = {
        enable = true;
        mode = [ ''"'\\.proto\\'"'' ];
      };

      py-isort = {
        enable = true;
        after = [ "python" ];
        hook = [];
      };

      python = {
        enable = true;
        mode = [ ''("\\.py\\'" . python-mode)'' ];
        hook = [
          "hs-minor-mode"
          "(before-save . py-isort-before-save)"
        ];
        config = ''
          ;; Leave C-c C-s & C-c C-f for counsel-projectile
          (unbind-key "C-c C-s" python-mode-map)
          (unbind-key "C-c C-f" python-mode-map)
          '';
      };

      restclient = {
        enable = true;
        mode = [ ''("\\.http\\'" . restclient-mode)'' ];
      };

      sqlformat = {
        enable = true;
        config = ''
          (setq sqlformat-command 'pgformatter)
          (setq sqlformat-args '("-s2" "-g"))
          '';
      };

      transpose-frame = {
        enable = true;
        bind = { "C-c f t" = "transpose-frame"; };
      };

      octave = {
        enable = true;
        mode = [ ''("\\.m\\'" . octave-mode)'' ];
      };

      hcl-mode = {
        enable = true;
        mode = [ ''"\\.tfvars\\'"'' ''"\\.tf\\'"'' ];
      };

      yaml-mode = {
        enable = true;
        mode = [ ''"\\.yaml\\'"'' ];
      };

      wc-mode = {
        enable = true;
        command = [ "wc-mode" ];
      };

      web-mode = {
        enable = true;
        mode = [ ''"\\.html\\'"'' ''"\\.jsx?\\'"'' ];
        # bindLocal = {
        #   web-mode-map = { "C-c C-s" = "counsel-projectile-ag"; };
        #   web-mode-map = { "C-c C-f" = "counsel-projectile-find-file"; };
        # };
        config = ''
            (setq web-mode-attr-indent-offset 4
                  web-mode-code-indent-offset 2
                  web-mode-markup-indent-offset 2)
            (add-to-list 'web-mode-content-types '("jsx" . "\\.jsx?\\'"))
          '';
      };

      dired = {
        enable = true;
        defer = true;
        config = ''
            (put 'dired-find-alternate-file 'disabled nil)
            ;; Use the system trash can.
            (setq delete-by-moving-to-trash t)
          '';
      };

      wdired = {
        enable = true;
        bindLocal = {
          dired-mode-map = { "C-c C-w" = "wdired-change-to-wdired-mode"; };
        };
        config = ''
            ;; I use wdired quite often and this setting allows editing file
            ;; permissions as well.
            (setq wdired-allow-to-change-permissions t)
          '';
      };

      dired-x = {
        enable = true;
        after = [ "dired" ];
      };

      recentf = {
        enable = true;
        command = [ "recentf-mode" ];
        config = ''
            (setq recentf-save-file (locate-user-emacs-file "recentf")
                  recentf-max-menu-items 20
                  recentf-max-saved-items 500
                  recentf-exclude '("COMMIT_MSG" "COMMIT_EDITMSG"))
          '';
      };

      nxml-mode = {
        enable = true;
        mode = [ ''"\\.xml\\'"'' ];
        config = ''
            (setq nxml-child-indent 4
                  nxml-attribute-indent 4
                  nxml-slash-auto-complete-flag t)
            (add-to-list 'rng-schema-locating-files
                         "~/.emacs.d/nxml-schemas/schemas.xml")
          '';
      };

      rust-mode = {
        enable = true;
        mode = [ ''"\\.rs\\'"'' ];
      };
    };
  };
}
