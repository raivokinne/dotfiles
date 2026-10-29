;; -*- lexical-binding: t; -*-

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))
(package-initialize)

(let* ((idx (expand-file-name "archives/melpa/archive-contents" package-user-dir))
       (age (and (file-exists-p idx)
                 (float-time (time-since (file-attribute-modification-time
                                          (file-attributes idx)))))))
  (cond
   ((or (not package-archive-contents) (not age))
    (package-refresh-contents))
   ((> age (* 7 24 60 60))
    (package-refresh-contents t))))

(require 'use-package)
(setq use-package-always-ensure t)

(add-hook 'emacs-startup-hook
          (lambda () (setq gc-cons-threshold (* 64 1024 1024))))

(setq frame-resize-pixelwise t
      read-process-output-max (* 1024 1024)
      inhibit-compacting-font-caches t
      fast-but-imprecise-scrolling t
      redisplay-skip-fontification-on-input t
      jit-lock-defer-time 0)
(setq-default bidi-paragraph-direction 'left-to-right
              bidi-inhibit-bpa t)
(global-so-long-mode 1)
(blink-cursor-mode -1)

(setq-default line-spacing 1
              indent-tabs-mode nil
              tab-width 4)
(setq inhibit-startup-message t
      use-short-answers t
      ring-bell-function #'ignore
      make-backup-files nil
      select-enable-clipboard nil
      select-enable-primary nil
      display-line-numbers-type 'relative
      display-line-numbers-width-start t
      display-line-numbers-grow-only t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(column-number-mode 1)
(show-paren-mode 1)
(global-display-line-numbers-mode 1)
(dolist (hook '(term-mode-hook eshell-mode-hook shell-mode-hook
                help-mode-hook magit-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode -1))))
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-one t)
  (doom-themes-org-config))

(defun my/force-black-background (&rest _)
  "Make every background pure black, including fringes, line numbers, etc.
Uses the `user' theme layer so the overrides survive face recalculation
(e.g. when zooming), and also fixes the frame background parameter."
  (custom-theme-set-faces
   'user
   '(default ((t (:background "black"))))
   '(fringe ((t (:background "black"))))
   '(line-number ((t (:background "black"))))
   '(line-number-current-line ((t (:background "black"))))
   '(mode-line ((t (:background "black"))))
   '(mode-line-inactive ((t (:background "black"))))
   '(header-line ((t (:background "black"))))
   '(vertical-border ((t (:background "black" :foreground "#3e4451"))))
   '(internal-border ((t (:background "black"))))
   '(tab-bar ((t (:background "black"))))
   '(tab-line ((t (:background "black"))))
   '(corfu-default ((t (:background "black"))))
   '(corfu-current ((t (:background "#3e4451"))))
   '(region ((t (:background "#3e4451"))))
   '(hl-line ((t (:background "#111111")))))
  (dolist (frame (frame-list))
    (set-frame-parameter frame 'background-color "black")))

(advice-add 'load-theme :after #'my/force-black-background)
(dolist (fn '(default-text-scale-increase default-text-scale-decrease
              default-text-scale-reset text-scale-adjust))
  (advice-add fn :after #'my/force-black-background))
(my/force-black-background)

(add-to-list 'default-frame-alist '(background-color . "black"))
(add-hook 'server-after-make-frame-hook #'my/force-black-background)

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding nil
        evil-want-C-u-scroll t
        evil-undo-system 'undo-redo)
  :config
  (evil-mode 1)
  (evil-global-set-key 'motion "j" #'evil-next-visual-line)
  (evil-global-set-key 'motion "k" #'evil-previous-visual-line))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-commentary
  :after evil
  :config (evil-commentary-mode))

(setq save-interprogram-paste-before-kill nil
      interprogram-cut-function nil
      interprogram-paste-function nil)

(with-eval-after-load 'evil
  (evil-set-leader '(normal visual motion) (kbd "SPC"))
  (evil-define-key '(normal visual) 'global (kbd "<leader>y") "\"+y")
  (evil-define-key 'normal 'global (kbd "<leader>Y") "\"+Y")
  (evil-define-key '(normal visual) 'global (kbd "<leader>p") "\"+p")
  (evil-define-key 'normal 'global (kbd "<leader>P") "\"+P"))

(use-package vertico :init (vertico-mode))

(use-package orderless
  :custom (completion-styles '(orderless basic)))

(use-package consult
  :bind (("C-s" . consult-line)
         ("C-x b" . consult-buffer)))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-preselect 'prompt)
  :init (global-corfu-mode)
  :config
  (define-key corfu-map (kbd "C-n") #'corfu-next)
  (define-key corfu-map (kbd "C-p") #'corfu-previous)
  (define-key corfu-map (kbd "C-y") #'corfu-insert)
  (define-key corfu-map (kbd "RET") #'corfu-insert))

(use-package cape
  :init
  (setq cape-dabbrev-check-other-buffers nil)
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file))

(use-package eglot
  :ensure nil
  :hook ((python-mode python-ts-mode
          c-mode c++-mode c-ts-mode c++-ts-mode
          rust-mode rust-ts-mode
          go-mode go-ts-mode
          js-mode js-ts-mode typescript-ts-mode tsx-ts-mode
          web-mode css-mode css-ts-mode
          json-ts-mode
          sh-mode bash-ts-mode
          lua-mode php-mode php-ts-mode) . eglot-ensure)
  :custom
  (eglot-autoshutdown t)
  (eglot-sync-connect nil)
  (eglot-extend-to-xref t)
  :config
  (setq eglot-events-buffer-size 0
        eglot-events-buffer-config '(:size 0 :format short))
  (define-key eglot-mode-map (kbd "C-c r") #'eglot-rename)
  (define-key eglot-mode-map (kbd "C-c a") #'eglot-code-actions)
  (define-key eglot-mode-map (kbd "C-c f") #'eglot-format)
  (with-eval-after-load 'evil
    (evil-define-key 'normal eglot-mode-map
      (kbd "gd") #'xref-find-definitions
      (kbd "gr") #'xref-find-references
      (kbd "K")  #'eldoc-box-help-at-point))
  (setq completion-category-overrides
        '((eglot (styles orderless basic))
          (eglot-capf (styles orderless basic)))))

(use-package eldoc-box
  :commands eldoc-box-help-at-point)

(with-eval-after-load 'flymake
  (define-key flymake-mode-map (kbd "M-n") #'flymake-goto-next-error)
  (define-key flymake-mode-map (kbd "M-p") #'flymake-goto-prev-error))

(use-package rust-mode :mode "\\.rs\\'") ;
(use-package go-mode :mode "\\.go\\'")
(use-package lua-mode :mode "\\.lua\\'")
(use-package web-mode :mode "\\.html?\\'")

(use-package treesit-auto
  :custom (treesit-auto-install 'prompt)
  :config
  (setq treesit-auto-langs (remove 'php treesit-auto-langs))
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode))

(use-package php-mode :mode "\\.php\\'")

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((php-mode php-ts-mode) . ("phpactor" "language-server")))
  (add-to-list 'eglot-server-programs
               '(((js-mode :language-id "javascript")
                  (js-ts-mode :language-id "javascript")
                  (typescript-mode :language-id "typescript")
                  (typescript-ts-mode :language-id "typescript")
                  (tsx-ts-mode :language-id "typescriptreact"))
                 . ("vtsls" "--stdio")))
  (add-to-list 'eglot-server-programs
               '(web-mode . ("vscode-html-language-server" "--stdio"))))

(use-package magit :commands magit-status)

(use-package default-text-scale
  :config (default-text-scale-mode 1))

(use-package exec-path-from-shell
  :config
  (dolist (var '("PATH" "MANPATH"))
    (add-to-list 'exec-path-from-shell-variables var))
  (exec-path-from-shell-initialize))
