;; -*- lexical-binding: t -*-

(setq gc-cons-threshold (* 50 1000 1000))
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000))
            (message "Loaded in %.2fs with %d GCs."
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package no-littering
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(setq inhibit-startup-message t
      visible-bell nil
      use-short-answers t)          ; "y" instead of "yes"

(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(set-fringe-mode 8)
(setq-default truncate-lines t)
(column-number-mode t)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)

(dolist (hook '(term-mode-hook shell-mode-hook eshell-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default        nil :font "FiraCode Nerd Font" :height 220)
(set-face-attribute 'fixed-pitch    nil :font "FiraCode Nerd Font" :height 220)
(set-face-attribute 'variable-pitch nil :font "Cantarell"          :height 220)

(use-package doom-themes
  :config
  (load-theme 'doom-opera t)
  (let ((black "#000000"))
    (dolist (face '(default
                    fringe
                    line-number
                    line-number-current-line
                    mode-line
                    mode-line-inactive
                    header-line
                    vertical-border
                    minibuffer-prompt))
      (set-face-attribute face nil :background black)))
  (doom-themes-org-config))

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding  nil
        evil-want-C-u-scroll  t
        evil-want-C-i-jump    nil
        evil-undo-system      'undo-redo)   ; native undo tree (Emacs 28+)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)
  (setq evil-normal-state-cursor  '(box)
        evil-insert-state-cursor  '(box)
        evil-visual-state-cursor  '(box)
        evil-replace-state-cursor '(box)
        evil-emacs-state-cursor   '(box)))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-commentary          ; gc to comment, like Neovim's gcc
  :after evil
  :config (evil-commentary-mode))

(use-package restart-emacs)

(use-package ibuffer-projectile
  :hook (ibuffer . (lambda ()
                     (ibuffer-projectile-set-filter-groups)
                     (unless (eq ibuffer-sorting-mode 'alphabetic)
                       (ibuffer-do-sort-by-alphabetic)))))

(use-package ibuffer
  :ensure nil
  :custom
  (ibuffer-show-empty-filter-groups nil)
  (ibuffer-display-summary nil)
  :config
  (evil-collection-define-key 'normal 'ibuffer-mode-map
    "j" 'ibuffer-forward-line
    "k" 'ibuffer-backward-line
    "d" 'ibuffer-mark-for-delete
    "x" 'ibuffer-do-delete
    "r" 'ibuffer-update))

(use-package general
  :after evil
  :config
  (general-create-definer leader!
    :keymaps '(normal visual emacs)
    :prefix  "SPC"
    :global-prefix "M-SPC")

  (leader!
    ;; Files
    "f"  '(:ignore t :which-key "files")
    "ff" '(find-file              :which-key "find file")
    "fd" '(dired                  :which-key "dired")
    "fD" '(consult-dired          :which-key "dired recent")
    "fr" '(consult-recent-file    :which-key "recent files")
    "fe" '((lambda () (interactive) (find-file user-init-file))
            :which-key "open init.el")

    ;; Buffers
    "b"  '(:ignore t :which-key "buffers")
    "bb" '(consult-buffer              :which-key "switch buffer")
    "bB" '(ibuffer                     :which-key "ibuffer")
    "bd" '(my/kill-current-buffer      :which-key "kill buffer")
    "bn" '(next-buffer                 :which-key "next")
    "bp" '(previous-buffer             :which-key "prev")

    ;; Search
    "s"  '(:ignore t :which-key "search")
    "ss" '(consult-line           :which-key "search buffer")
    "sp" '(consult-ripgrep        :which-key "search project")

    ;; Git
    "g"  '(:ignore t :which-key "git")
    "gg" '(magit-status           :which-key "magit status")
    "gb" '(magit-blame            :which-key "blame")

    ;; Projects
    "p"  '(:ignore t :which-key "project")
    "pp" '(projectile-find-file        :which-key "find file in project")
    "pf" '(projectile-switch-project   :which-key "switch project")
    "pk" '(projectile-kill-buffers     :which-key "kill project buffers")

    ;; LSP
    "l"  '(:ignore t :which-key "lsp")
    "la" '(lsp-execute-code-action :which-key "code action")
    "lr" '(lsp-rename             :which-key "rename")
    "lf" '(lsp-format-buffer      :which-key "format")
    "lh" '(lsp-describe-thing-at-point :which-key "hover")
    "ld" '(lsp-find-definition     :which-key "definition")
    "lD" '(lsp-find-declaration    :which-key "declaration")
    "li" '(lsp-find-implementation :which-key "implementation")
    "lR" '(lsp-find-references     :which-key "references")
    "l[" '(lsp-diagnostic-prev     :which-key "prev diagnostic")
    "l]" '(lsp-diagnostic-next     :which-key "next diagnostic")

    ;; Toggles
    "t"  '(:ignore t :which-key "toggle")
    "tt" '(consult-theme          :which-key "theme")
    "tl" '(display-line-numbers-mode :which-key "line numbers")
    "tw" '(whitespace-mode        :which-key "whitespace")

    ;; Shell
    "e"  '(eshell                 :which-key "eshell")

    ;; Quit
    "q"  '(:ignore t :which-key "quit")
    "qq" '(save-buffers-kill-terminal :which-key "save & quit")
    "qf" '(kill-emacs                 :which-key "force quit")
    "qr" '(restart-emacs              :which-key "restart")))

    ;; Quit
    "q"  '(:ignore t :which-key "quit")
    "qq" '(save-buffers-kill-terminal :which-key "save & quit")
    "qf" '(kill-emacs                 :which-key "force quit")
    "qr" '(restart-emacs              :which-key "restart")
    "qR" '((lambda () (interactive) (restart-emacs '("--debug-init"))) :which-key "restart with debug")

(use-package which-key
  :init (which-key-mode)
  :custom (which-key-idle-delay 0.4))

(use-package vertico
  :init (vertico-mode))

(use-package orderless             ; space-separated fuzzy matching
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil))

(use-package marginalia             ; annotations in the minibuffer
  :init (marginalia-mode))

(use-package consult               ; enhanced search/navigation commands
  :bind (("C-s" . consult-line)))

(use-package embark                ; context actions on minibuffer candidates
  :bind ("C-." . embark-act))

(use-package embark-consult
  :after (embark consult))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-prefix 2)
  (corfu-quit-at-boundary 'separator)
  (corfu-quit-no-match t)
  (corfu-preselect 'prompt)
  (corfu-sort-function #'corfu-sort-length-alpha)
  :init
  (global-corfu-mode)
  :config
  (advice-add #'lsp-completion-at-point :around
	      (lambda (f &rest args)
		(let ((orderless-style-dispatchers nil))
		  (apply f args))))
  (define-key corfu-map (kbd "C-p") #'corfu-previous)
  (define-key corfu-map (kbd "C-n") #'corfu-next)
  (define-key corfu-map (kbd "C-y") #'corfu-insert)
  (define-key corfu-map (kbd "C-SPC") #'completion-at-point)
  (define-key corfu-map (kbd "RET") #'corfu-insert))

(use-package cape
  :init
  (add-hook 'prog-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list #'lsp-completion-at-point
                                #'cape-file
                                #'cape-dabbrev)))))

(use-package corfu-popupinfo
  :after corfu
  :hook (corfu-mode . corfu-popupinfo-mode)
  :custom (corfu-popupinfo-delay 0.5))

(with-eval-after-load 'lsp-mode
  (setq lsp-completion-filter-on-incomplete t)
  (add-to-list 'completion-category-overrides
               '(lsp-capf (styles orderless basic))))

(use-package typescript-mode
  :mode ("\\.ts\\'" "\\.tsx\\'"))
(use-package json-mode
  :mode "\\.json\\'")
(use-package rust-mode
  :mode "\\.rs\\'")
(use-package go-mode
  :mode "\\.go\\'")
(use-package php-mode
  :mode "\\.php\\'")
(use-package zig-mode
  :mode "\\.zig\\'")
(use-package cc-mode)
(use-package dart-mode)
(use-package haskell-mode)
(use-package kdl-mode)
(use-package lua-mode)

(defun my/lsp-setup ()
  (font-lock-mode 1)
  (lsp-deferred))

(dolist (hook '(c-mode-hook c++-mode-hook python-mode-hook typescript-mode-hook
                 js-mode-hook css-mode-hook json-mode-hook sh-mode-hook
                 rust-mode-hook go-mode-hook php-mode-hook zig-mode-hook))
  (add-hook hook #'my/lsp-setup))



(use-package lsp-mode
  :commands lsp-deferred
  :custom
  (lsp-keymap-prefix "C-c l")
  (lsp-semantic-tokens-enable nil)
  (lsp-completion-provider :capf)
  (lsp-auto-guess-root t)
  (lsp-enable-snippet nil)
  (lsp-headerline-breadcrumb-enable nil)
  :hook (lsp-mode . (lambda () (font-lock-mode 1)))
  :config
  (lsp-enable-which-key-integration t)
  (add-to-list 'lsp-disabled-clients 'rls)
  (general-define-key
    :states 'normal
    :keymaps 'lsp-mode-map
    "gd" #'lsp-find-definition
    "gD" #'lsp-find-declaration
    "gr" #'lsp-find-references
    "gi" #'lsp-find-implementation
    "[d" #'lsp-diagnostic-prev
    "]d" #'lsp-diagnostic-next))

(setq evil-lookup-func #'lsp-ui-doc-glance)

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-enable t)
  (lsp-ui-doc-show-with-cursor nil)
  (lsp-ui-doc-show-with-mouse nil)
  (lsp-ui-doc-position 'at-point)
  (lsp-ui-doc-max-width 80)
  (lsp-ui-doc-max-height 30)
  (lsp-ui-doc-use-childframe t)
  (lsp-ui-doc-include-signature t)
  (lsp-ui-sideline-show-enable t)
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-show-code-actions t)
  :config
  (general-define-key
    :states 'normal
    :keymaps 'lsp-ui-mode-map   
    "K" #'lsp-ui-doc-glance))

(use-package lsp-clangd
  :ensure nil
  :after lsp-mode
  :custom
  (lsp-clangd-version "latest")
  (lsp-clients-clangd-args '("--clang-tidy"
                             "--background-index"
                             "--completion-style=detailed"
                             "--header-insertion=never")))
(use-package magit
  :commands magit-status
  :custom (magit-display-buffer-function
           #'magit-display-buffer-same-window-except-diff-v1))

(use-package projectile
  :diminish
  :config (projectile-mode)
  :bind-keymap ("C-c p" . projectile-command-map)
  :custom
  (projectile-completion-system 'auto)
  (projectile-switch-project-action #'projectile-dired)
  (projectile-project-search-path '("~/Projects")))

(use-package dired
  :ensure nil
  :commands dired
  :bind ("C-x C-j" . dired-jump)
  :hook (dired-mode . dired-hide-details-mode)
  :config
  (setq dired-kill-when-opening-new-dired-buffer t)
  (put 'dired-find-alternate-file 'disabled nil)
  (evil-collection-define-key 'normal 'dired-mode-map
    "h" 'dired-up-directory
    "l" 'dired-find-file))

(use-package diredfl
  :hook (dired-mode . diredfl-mode))

(use-package vterm
    :ensure t)

(use-package eshell
  :ensure nil
  :hook (eshell-first-time-mode
         . (lambda ()
             (add-hook 'eshell-pre-command-hook 'eshell-save-some-history)
             (setq eshell-history-size 10000
                   eshell-hist-ignoredups t
                   eshell-scroll-to-bottom-on-input t))))
(use-package exec-path-from-shell
  :init (exec-path-from-shell-initialize))

(setq make-backup-files nil
      auto-save-default t)

(setq scroll-margin 4
      scroll-conservatively 101
      scroll-step 1
      ring-bell-function #'flash-mode-line)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
