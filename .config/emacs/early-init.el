;; -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil)
(advice-add #'package--ensure-init-file :override #'ignore)

(setq frame-inhibit-implied-resize t)

(setq gc-cons-threshold most-positive-fixnum   ; no GC during startup
      package-enable-at-startup nil            ; init.el calls package-initialize
      frame-inhibit-implied-resize t)

(setq default-frame-alist
      '((menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (vertical-scroll-bars)
        (font . "Pragmasevka Nerd Font-12")
        (background-color . "black")
        (foreground-color . "white")))
