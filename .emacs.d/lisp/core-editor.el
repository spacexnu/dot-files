;;; core-editor.el --- editor behavior -*- lexical-binding: t; -*-

;; Indent/whitespace: clean default
(setq-default indent-tabs-mode nil
              tab-width 4)
(add-hook 'before-save-hook #'delete-trailing-whitespace)

;; Smoother scrolling
(setq scroll-conservatively 101
      scroll-margin 5)

;; Project support (built-in)
(use-package project
  :ensure nil)

;; Line numbers only in code buffers.
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

;; Eglot (built-in in Emacs 29+)
(use-package eglot
  :ensure nil
  :init
  ;; eglot logs: keep low
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
