;;; core-editor.el --- editor behavior -*- lexical-binding: t; -*-

;; Indent/whitespace: padrão “sem sujeira”
(setq-default indent-tabs-mode nil
              tab-width 4)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; Melhor scroll
(setq scroll-conservatively 101
      scroll-margin 5)

;; Project support (built-in)
(use-package project
  :ensure nil)

;; Eglot (built-in no Emacs 29+)
(use-package eglot
  :ensure nil
  :init
  ;; logs do eglot: deixe baixo
  (setq eglot-events-buffer-size 0))

;; Toggle global: format-on-save
(defvar spacexnu/format-on-save t "If non-nil, run formatter on save.")

(defun spacexnu/toggle-format-on-save ()
  (interactive)
  (setq spacexnu/format-on-save (not spacexnu/format-on-save))
  (message "format-on-save: %s" (if spacexnu/format-on-save "ON" "OFF")))

(global-set-key (kbd "C-c t f") #'spacexnu/toggle-format-on-save)

(provide 'core-editor)
;;; core-editor.el ends here
