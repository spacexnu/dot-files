;;; lang-web.el --- js/ts -*- lexical-binding: t; -*-

(defun spacexnu/web-setup ()
  (when (fboundp 'eglot-ensure)
    (eglot-ensure)))

(dolist (hook '(js-ts-mode-hook typescript-ts-mode-hook))
  (add-hook hook #'spacexnu/web-setup))

(defun spacexnu/prettier-format-buffer ()
  (interactive)
  (when (and spacexnu/format-on-save (buffer-file-name) (executable-find "prettier"))
    ;; prettier modifies the file; run it then reload
    (call-process "prettier" nil "*spacexnu-format*" nil "--write" (buffer-file-name))
    (revert-buffer t t t)))

(dolist (hook '(js-ts-mode-hook typescript-ts-mode-hook))
  (add-hook hook (lambda ()
                   (add-hook 'before-save-hook #'spacexnu/prettier-format-buffer nil t))))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((js-ts-mode typescript-ts-mode)
                 . ("typescript-language-server" "--stdio"))))

(provide 'lang-web)
;;; lang-web.el ends here
