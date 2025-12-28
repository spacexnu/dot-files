;;; lang-go.el --- go -*- lexical-binding: t; -*-

(defun spacexnu/go-setup ()
  (when (fboundp 'eglot-ensure)
    (eglot-ensure)))

(add-hook 'go-ts-mode-hook #'spacexnu/go-setup)
(add-hook 'go-mode-hook #'spacexnu/go-setup)

(defun spacexnu/go-format-buffer ()
  (interactive)
  (when (and spacexnu/format-on-save (buffer-file-name))
    (cond
     ((executable-find "goimports")
      (call-process "goimports" nil "*spacexnu-format*" nil "-w" (buffer-file-name))
      (revert-buffer t t t))
     ((executable-find "gofmt")
      (call-process "gofmt" nil "*spacexnu-format*" nil "-w" (buffer-file-name))
      (revert-buffer t t t))
     (t (message "No go formatter found (goimports/gofmt).")))))

(add-hook 'go-ts-mode-hook
          (lambda () (add-hook 'before-save-hook #'spacexnu/go-format-buffer nil t)))
(add-hook 'go-mode-hook
          (lambda () (add-hook 'before-save-hook #'spacexnu/go-format-buffer nil t)))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((go-mode go-ts-mode) . ("gopls"))))

(provide 'lang-go)
;;; lang-go.el ends here
