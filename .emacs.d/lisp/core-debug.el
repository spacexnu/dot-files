;;; core-debug.el --- dap-mode setup -*- lexical-binding: t; -*-

(use-package dap-mode
  :commands (dap-debug dap-debug-edit-template)
  :init
  (setq dap-auto-configure-features '(sessions locals controls tooltip))
  (setq dap-python-debugger 'debugpy)
  (setq dap-variables-project-root-function
        (lambda ()
          (if-let ((proj (project-current nil)))
              (directory-file-name (car (project-roots proj)))
            (directory-file-name (expand-file-name default-directory)))))
  :config
  (dap-auto-configure-mode)
  (require 'dap-go)
  (require 'dap-python)
  (require 'dap-node))

(use-package treemacs
  :defer t)

(provide 'core-debug)
;;; core-debug.el ends here
