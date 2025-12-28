;;; core-ui.el --- UI defaults -*- lexical-binding: t; -*-

(setq frame-title-format '("%b — Emacs")
      initial-scratch-message nil
      inhibit-startup-screen t
      initial-buffer-choice (lambda () (get-buffer-create "*empty*")))

(set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 130)
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; macOS: Command = Meta (se você curte)
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

;; File tree (estilo NerdTree)
(use-package treemacs
  :bind (("C-x t t" . treemacs)
         ("C-x t 1" . treemacs-delete-other-windows))
  :init
  (setq treemacs-width 30
        treemacs-show-cursor t
        treemacs-is-never-other-window t))

(use-package all-the-icons)

(use-package treemacs-all-the-icons
  :after (treemacs all-the-icons)
  :config
  (treemacs-load-theme "all-the-icons"))

(provide 'core-ui)
;;; core-ui.el ends here
