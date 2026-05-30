;; -*- lexical-binding: t -*-

(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")
(load-theme 'alabaster-refined t)

(defvar elpaca-installer-version 0.12)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-sources-directory (expand-file-name "sources/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1 :inherit ignore
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca-activate)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-sources-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (<= emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let* ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                  ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                  ,@(when-let* ((depth (plist-get order :depth)))
                                                      (list (format "--depth=%d" depth) "--no-single-branch"))
                                                  ,(plist-get order :repo) ,repo))))
                  ((zerop (call-process "git" nil buffer t "checkout"
                                        (or (plist-get order :ref) "--"))))
                  (emacs (concat invocation-directory invocation-name))
                  ((zerop (call-process emacs nil buffer nil "-q" "-l" "." "--batch"
                                        "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                  ((require 'elpaca))
                  ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (let ((load-source-file-function nil)) (load "./elpaca-autoloads"))))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

(elpaca elpaca-use-package
  (elpaca-use-package-mode)
  (setq elpaca-use-package-by-default t))

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'elpaca-menu-melpa)
(require 'elpaca-menu-elpa)

(setq gc-cons-threshold (* 50 1000 1000))

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000))
            (message "Loaded in %.2fs with %d GCs."
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

(use-package no-littering
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(setq inhibit-startup-message t
      visible-bell nil
      ring-bell-function #'flash-mode-line
      use-short-answers t)

(scroll-bar-mode -1)
(tool-bar-mode   -1)
(tooltip-mode    -1)
(menu-bar-mode   -1)
(set-fringe-mode 8)
(setq-default truncate-lines t)
(column-number-mode t)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode t)
;; (set-terminal-coding-system 'utf-8)
;; (add-hook 'after-init-hook (lambda () (invert-face 'default)))

(dolist (hook '(term-mode-hook shell-mode-hook eshell-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode 0))))

(set-face-attribute 'default        nil :font "0xProto Nerd Font" :height 180)
(set-face-attribute 'fixed-pitch    nil :font "0xProto Nerd Font" :height 180)
(set-face-attribute 'variable-pitch nil :font "Cantarell"          :height 180)

(use-package evil
  :init
  (setq evil-want-integration t
        evil-want-keybinding  nil
        evil-want-C-u-scroll  t
        evil-want-C-i-jump    nil
        evil-undo-system      'undo-redo)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-commentary
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
    "ff" '(find-file                    :which-key "find file")
    "fd" '(dired                        :which-key "dired")
    "fD" '(dired-jump                   :which-key "dired jump")
    "fr" '(consult-recent-file          :which-key "recent files")
    "fe" '((lambda () (interactive) (find-file user-init-file))
            :which-key "open init.el")

    ;; Buffers
    "b"  '(:ignore t :which-key "buffers")
    "bb" '(consult-buffer               :which-key "switch buffer")
    "bB" '(ibuffer                      :which-key "ibuffer")
    "bd" '(my/kill-current-buffer       :which-key "kill buffer")
    "bn" '(next-buffer                  :which-key "next")
    "bp" '(previous-buffer              :which-key "prev")

    ;; Search
    "s"  '(:ignore t :which-key "search")
    "ss" '(consult-line                 :which-key "search buffer")
    "sp" '(consult-ripgrep              :which-key "search project")

    ;; Git
    "g"  '(:ignore t :which-key "git")
    "gg" '(magit-status                 :which-key "magit status")
    "gb" '(magit-blame                  :which-key "blame")

    ;; Projects
    "p"  '(:ignore t :which-key "project")
    "pp" '(projectile-find-file         :which-key "find file in project")
    "pf" '(projectile-switch-project    :which-key "switch project")
    "pk" '(projectile-kill-buffers      :which-key "kill project buffers")

    ;; LSP
    "l"  '(:ignore t :which-key "lsp")
    "la" '(lsp-execute-code-action      :which-key "code action")
    "lr" '(lsp-rename                   :which-key "rename")
    "lf" '(lsp-format-buffer            :which-key "format")
    "lh" '(lsp-describe-thing-at-point  :which-key "hover")
    "ld" '(lsp-find-definition          :which-key "definition")
    "lD" '(lsp-find-declaration         :which-key "declaration")
    "li" '(lsp-find-implementation      :which-key "implementation")
    "lR" '(lsp-find-references          :which-key "references")
    "l[" '(lsp-diagnostic-prev          :which-key "prev diagnostic")
    "l]" '(lsp-diagnostic-next          :which-key "next diagnostic")
    "lx" '(flymake-show-buffer-diagnostics :which-key "list diagnostics")
    "lX" '(flymake-show-project-diagnostics :which-key "project diagnostics")

    ;; Toggles
    "t"  '(:ignore t :which-key "toggle")
    "tt" '(consult-theme                :which-key "theme")
    "tl" '(display-line-numbers-mode    :which-key "line numbers")
    "tw" '(whitespace-mode              :which-key "whitespace")

    ;; Quit
    "q"  '(:ignore t :which-key "quit")
    "qq" '(save-buffers-kill-terminal   :which-key "save & quit")
    "qf" '(kill-emacs                   :which-key "force quit")
    "qr" '(restart-emacs                :which-key "restart")
    "qR" '((lambda () (interactive) (restart-emacs '("--debug-init")))
            :which-key "restart with debug")))

(use-package which-key
  :init (which-key-mode)
  :custom (which-key-idle-delay 0.4))

(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil))

(use-package marginalia
  :init (marginalia-mode))

(use-package consult
  :bind (("C-s" . consult-line)))

(use-package embark
  :bind ("C-." . embark-act))

(use-package embark-consult
  :after (embark consult))

(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2)
  (corfu-auto-prefix 2)
  (corfu-quit-at-boundary nil)
  (corfu-quit-no-match nil)
  (corfu-on-exact-match nil)
  (corfu-preselect 'prompt)
  (corfu-sort-function #'corfu-sort-length-alpha)
  :init
  (global-corfu-mode)
  :config
  (define-key corfu-map (kbd "C-p") #'corfu-previous)
  (define-key corfu-map (kbd "C-n") #'corfu-next)
  (define-key corfu-map (kbd "C-y") #'corfu-insert)
  (define-key corfu-map (kbd "C-SPC") #'completion-at-point)
  (define-key corfu-map (kbd "RET") #'corfu-insert))

(use-package cape
  :init
  (add-hook 'lsp-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list (cape-capf-buster #'lsp-completion-at-point)
                                #'cape-file
                                #'cape-dabbrev)))))

(use-package typescript-mode :mode ("\\.ts\\'" "\\.tsx\\'"))
(use-package json-mode       :mode "\\.json\\'")
(use-package rust-mode       :mode "\\.rs\\'")
(use-package go-mode         :mode "\\.go\\'")
(use-package zig-mode        :mode "\\.zig\\'")
(use-package cc-mode         :ensure nil)
(use-package haskell-mode)
(use-package lua-mode)

(use-package php-mode
  :mode "\\.php\\'"
  :config
  (add-hook 'php-mode-hook
            (lambda ()
              (require 'lsp-mode)
              (lsp-register-client
               (make-lsp-client
                :new-connection (lsp-stdio-connection '("phpactor" "language-server"))
                :major-modes '(php-mode)
                :server-id 'phpactor)))))

(defun my/kill-current-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))

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
  (lsp-completion-enable t)
  (lsp-auto-guess-root t)
  (lsp-enable-snippet nil)
  (lsp-headerline-breadcrumb-enable nil)
  (lsp-completion-trigger-characters '("." ":" "\"" "'"))
  (lsp-clients-clangd-args '("--clang-tidy"
                              "--background-index"
                              "--completion-style=detailed"
                              "--header-insertion=never"))
  :hook (lsp-mode . (lambda ()
                      (font-lock-mode 1)
                      (flymake-mode 1)))
  :config
  (lsp-enable-which-key-integration t)
  (add-to-list 'lsp-disabled-clients 'rls)
  (add-to-list 'lsp-disabled-clients 'intelephense)
  (with-eval-after-load 'orderless
    (add-to-list 'completion-category-overrides
                 '(lsp-capf (styles orderless basic))))
  (general-define-key
    :states 'normal
    :keymaps 'lsp-mode-map
    "gd" #'lsp-find-definition
    "gD" #'lsp-find-declaration
    "gr" #'lsp-find-references
    "gi" #'lsp-find-implementation
    "[d" #'lsp-diagnostic-prev
    "]d" #'lsp-diagnostic-next
    "gl" #'lsp-diagnostic-open-logs
    "gL" #'flymake-show-buffer-diagnostics))

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
  (lsp-ui-sideline-show-diagnostics t)
  (lsp-ui-sideline-show-hover nil)
  (lsp-ui-sideline-show-code-actions t)
  (lsp-ui-sideline-ignore-duplicate t)
  (lsp-ui-sideline-update-mode 'line)
  :config
  (general-define-key
    :states 'normal
    :keymaps 'lsp-ui-mode-map
    "K" #'lsp-ui-doc-glance))

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
  :after evil-collection          
  :commands dired
  :bind ("C-x C-j" . dired-jump)
  :config
  (setq dired-kill-when-opening-new-dired-buffer t)
  (put 'dired-find-alternate-file 'disabled nil)
  (evil-collection-define-key 'normal 'dired-mode-map
    "f" nil          
    "h" 'dired-up-directory
    "l" 'dired-find-file))

(use-package exec-path-from-shell
  :config  
  (exec-path-from-shell-initialize))

(setq make-backup-files nil
      auto-save-default t)

(elpaca-wait)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
