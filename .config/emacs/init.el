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

;; Performance
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
      select-enable-clipboard t
      select-enable-primary t
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
(setq frame-background-mode 'dark)
(set-face-attribute 'default nil :background "black" :foreground "white")
(set-face-attribute 'cursor nil :background "white")
(mapc #'frame-set-background-mode (frame-list))
(global-set-key (kbd "<escape>") #'keyboard-escape-quit)

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

(use-package magit :commands magit-status)
(use-package default-text-scale
  :config (default-text-scale-mode 1))
