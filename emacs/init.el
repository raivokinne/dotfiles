(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa"  . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(setq gc-cons-threshold (* 50 1000 1000))

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 2 1000 1000))
            (message "Loaded in %.2fs with %d GCs."
                     (float-time (time-subtract after-init-time before-init-time))
                     gcs-done)))

(add-to-list 'custom-theme-load-path "~/.config/emacs/themes/")
(load-theme 'alabaster-refined t)

(defun my/get-default-font ()
  (cond
   ((eq system-type 'gnu/linux)  "JetBrainsMono Nerd Font-13")))

(add-to-list 'default-frame-alist `(font . ,(my/get-default-font)))

(setq-default line-spacing 3)

;; Variable-pitch font for prose modes (org, etc.)
(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 180)

(setq inhibit-startup-message t
      visible-bell nil
      ring-bell-function #'flash-mode-line
      use-short-answers t)

(scroll-bar-mode  -1)
(tool-bar-mode    -1)
(tooltip-mode     -1)
(menu-bar-mode    -1)
(set-fringe-mode   8)
(column-number-mode 1)
(show-paren-mode    1)

;; (setq-default truncate-lines t)
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

(dolist (hook '(term-mode-hook shell-mode-hook eshell-mode-hook))
  (add-hook hook (lambda () (display-line-numbers-mode 0))))

(setq-default indent-tabs-mode nil
              tab-width 4)
(setq make-backup-files nil
      auto-save-default t)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq select-enable-clipboard t
      select-enable-primary t)

;; Treat hyphen and underscore as part of words in prog modes — makes
;; motions like 'w' and symbol-based search behave more naturally.
(add-hook 'prog-mode-hook
          (lambda ()
            (modify-syntax-entry ?- "w")
            (modify-syntax-entry ?_ "w")))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

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

(global-set-key (kbd "M-x") 'execute-extended-command)
(global-set-key (kbd "C-x b") 'consult-buffer)

(use-package multiple-cursors
  :config
  (global-set-key (kbd "C-S-c C-S-c") #'mc/edit-lines)        ; cursor on each line in region
  (global-set-key (kbd "C->")         #'mc/mark-next-like-this)     ; grow selection downward
  (global-set-key (kbd "C-<")         #'mc/mark-previous-like-this) ; grow selection upward
  (global-set-key (kbd "C-c C-<")     #'mc/mark-all-like-this))     ; mark every match at once

(use-package move-text
  :config
  (global-set-key (kbd "M-p") 'move-text-up)
  (global-set-key (kbd "M-n") 'move-text-down))

(use-package general
  :after evil
  :config
  (general-create-definer leader!
    :keymaps '(normal visual emacs)
    :prefix  "SPC"
    :global-prefix "M-SPC")

  (leader!
    "f"  '(:ignore t :which-key "files")
    "fe" '((lambda () (interactive) (find-file user-init-file))
            :which-key "open init.el")

    "bp" 'previous-buffer
    "bn" 'next-buffer
    "bd" 'kill-current-buffer
    "bm" 'ibuffer

    "s"  '(:ignore t :which-key "search")
    "ss" '(consult-line                 :which-key "search buffer")
    "sp" '(consult-ripgrep              :which-key "search project")

    "g"  '(:ignore t :which-key "git")
    "gg" '(magit-status                 :which-key "magit status")
    "gb" '(magit-blame                  :which-key "blame")

    "p"  '(:ignore t :which-key "project")
    "pf" '(projectile-find-file         :which-key "find file in project")
    "ps" '(projectile-switch-project    :which-key "switch project")

    "l"  '(:ignore t :which-key "lsp")
    "la" '(eglot-code-actions           :which-key "code action")
    "lr" '(eglot-rename                 :which-key "rename")
    "lf" '(eglot-format-buffer          :which-key "format")
    "lh" '(eldoc                        :which-key "hover/eldoc")
    "ld" '(xref-find-definitions        :which-key "definition")
    "lD" '(xref-find-declarations       :which-key "declaration")
    "li" '(eglot-find-implementation    :which-key "implementation")
    "lR" '(xref-find-references         :which-key "references")
    "l[" '(flymake-goto-prev-error      :which-key "prev diagnostic")
    "l]" '(flymake-goto-next-error      :which-key "next diagnostic")
    "lx" '(flymake-show-buffer-diagnostics   :which-key "list diagnostics")
    "lX" '(flymake-show-project-diagnostics  :which-key "project diagnostics")

    "t"  '(:ignore t :which-key "toggle")
    "tt" '(consult-theme                :which-key "theme")
    "tl" '(display-line-numbers-mode    :which-key "line numbers")
    "tw" '(whitespace-mode              :which-key "whitespace")

    "q"  '(:ignore t :which-key "quit")
    "qr" '(restart-emacs                :which-key "restart")

    "y"  '(:ignore t :which-key "clipboard")
    "yy" '((lambda ()
              (interactive)
              (let ((evil-this-register ?+))
                (call-interactively #'evil-yank-line)))
            :which-key "yank line to clipboard")
    "Y"  '((lambda ()
              (interactive)
              (let ((evil-this-register ?+))
                (evil-yank (point) (line-end-position))))
            :which-key "yank to EOL to clipboard")))

(general-define-key
  :states 'visual
  :keymaps 'override
  "SPC y" (lambda ()
            (interactive)
            (let ((evil-this-register ?+))
              (call-interactively #'evil-yank))))

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
  (corfu-preselect 'prompt)
  (corfu-sort-function #'corfu-sort-length-alpha)
  :init
  (global-corfu-mode)
  :config
  (define-key corfu-map (kbd "C-p") #'corfu-previous)
  (define-key corfu-map (kbd "C-n") #'corfu-next)
  (define-key corfu-map (kbd "C-y") #'corfu-insert)
  (define-key corfu-map (kbd "RET") #'corfu-insert))

(use-package cape
  :init
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list (cape-capf-buster #'eglot-completion-at-point)
                                #'cape-file
                                #'cape-dabbrev)))))

(use-package which-key
  :init (which-key-mode)
  :custom (which-key-idle-delay 0.4))

(use-package eglot
  :ensure nil
  :custom
  (eglot-autoshutdown t)
  (eglot-send-changes-idle-time 0.3)
  :config
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode)
                 . ("clangd"
                    "--clang-tidy"
                    "--background-index"
                    "--completion-style=detailed"
                    "--header-insertion=never"))))

(with-eval-after-load 'eglot
  (general-define-key
    :states 'normal
    :keymaps 'eglot-mode-map
    "gd" #'xref-find-definitions
    "gr" #'xref-find-references
    "gi" #'eglot-find-implementation
    "[d" #'flymake-goto-prev-error
    "]d" #'flymake-goto-next-error
    "K"  #'eldoc-print-current-symbol-info))

(setq evil-lookup-func #'eldoc-print-current-symbol-info)

(dolist (hook '(c-mode-hook c++-mode-hook python-mode-hook
                typescript-mode-hook js-mode-hook css-mode-hook
                sh-mode-hook rust-mode-hook go-mode-hook zig-mode-hook))
  (add-hook hook #'eglot-ensure))

(use-package php-mode
  :mode "\\.php\\'")

(with-eval-after-load 'php-mode
  (with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '(php-mode . ("phpactor" "language-server")))))

(add-hook 'php-mode-hook #'eglot-ensure)

(use-package sql
  :ensure nil
  :defer
  :custom
  (sql-sqlite-options '("-header" "-box"))
  :init
  (setq sql-postgres-login-params '((user :default "admin")
                                    (database :defaut "yump")
                                    (server :default "localhost")
                                    (port :default 5432))))

(require 'dired-x)
(require 'dired-aux)

(use-package dired
  :ensure nil
  :commands dired
  :bind ("C-x C-j" . dired-jump)
  :config
  (setq dired-kill-when-opening-new-dired-buffer t
        dired-listing-switches "-alh"
        dired-omit-files (concat dired-omit-files "\\|^\\..+$"))
  (setq-default dired-dwim-target t)
  (put 'dired-find-alternate-file 'disabled nil)
  (evil-collection-define-key 'normal 'dired-mode-map
    "f" nil
    "h" 'dired-up-directory
    "l" 'dired-find-file))

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

(use-package ibuffer-projectile
  :hook (ibuffer . (lambda ()
                     (ibuffer-projectile-set-filter-groups)
                     (unless (eq ibuffer-sorting-mode 'alphabetic)
                       (ibuffer-do-sort-by-alphabetic)))))

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

(use-package no-littering
  :config
  (setq auto-save-file-name-transforms
        `((".*" ,(no-littering-expand-var-file-name "auto-save/") t))))

(use-package restart-emacs)

(use-package exec-path-from-shell
  :config (exec-path-from-shell-initialize))

(use-package undo-tree)

(defun my/kill-current-buffer ()
  (interactive)
  (kill-buffer (current-buffer)))

(add-hook 'org-mode-hook 'visual-line-mode)

(setq display-buffer-alist
      '(("\\*xref\\*\\|\\*compilation\\*\\|\\*grep\\*"
         (display-buffer-reuse-window display-buffer-below-selected)
         (window-height . 0.35))))

(defun my/close-popup-window ()
  "Close the xref/compilation/grep/Help popup if one is visible."
  (interactive)
  (dolist (win (window-list))
    (when (string-match-p "\\*xref\\*\\|\\*compilation\\*\\|\\*grep\\*\\|\\*Help\\*"
                          (buffer-name (window-buffer win)))
      (delete-window win))))
