;;; lang-python.el --- python -*- lexical-binding: t; -*-

(defun spacexnu/python-setup ()
  ;; Emacs 29+: python-ts-mode existe; senão cai no python-mode
  (when (fboundp 'eglot-ensure)
    (eglot-ensure)))

(add-hook 'python-ts-mode-hook #'spacexnu/python-setup)
(add-hook 'python-mode-hook #'spacexnu/python-setup)

;; Formatter: ruff (preferência), cai pro black se quiser
(defun spacexnu/python-format-buffer ()
  (interactive)
  (when (and spacexnu/format-on-save (buffer-file-name))
    (cond
     ((executable-find "ruff")
      (call-process "ruff" nil "*spacexnu-format*" nil "format" (buffer-file-name))
      (revert-buffer t t t))
     ((executable-find "black")
      (call-process "black" nil "*spacexnu-format*" nil (buffer-file-name))
      (revert-buffer t t t))
     (t (message "No python formatter found (ruff/black).")))))

(add-hook 'python-ts-mode-hook
          (lambda () (add-hook 'before-save-hook #'spacexnu/python-format-buffer nil t)))
(add-hook 'python-mode-hook
          (lambda () (add-hook 'before-save-hook #'spacexnu/python-format-buffer nil t)))

;; LSP server: pyright (via eglot)
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("pyright-langserver" "--stdio"))))

(provide 'lang-python)
;;; lang-python.el ends here
