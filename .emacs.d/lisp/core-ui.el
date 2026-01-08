;;; core-ui.el --- UI defaults -*- lexical-binding: t; -*-

(setq frame-title-format '("%b — Emacs")
      initial-scratch-message nil
      inhibit-startup-screen t
      initial-buffer-choice (lambda () (get-buffer-create "*empty*")))

(set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 130)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; macOS: Command = Meta (if you like it)
(setq mac-command-modifier 'meta
      mac-option-modifier 'none)

;; Tema escuro
(use-package doom-themes
  :init
  :config
  (load-theme 'doom-one t))

;; Linha de status limpa (built-in)
(setq display-time-24hr-format t
      display-time-day-and-date t)
(display-time-mode 1)
(column-number-mode 1)

(use-package all-the-icons)

(provide 'core-ui)
;;; core-ui.el ends here
