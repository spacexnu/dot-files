;;; lang-python.el --- python -*- lexical-binding: t; -*-

;; Auto-detect .venv (or venv/env) in project root and set python interpreter.
(defvar spacexnu/python-venv-cache (make-hash-table :test 'equal)
  "Cache project root -> venv path (or :none).")

(defun spacexnu/python-project-root ()
  (or (and (fboundp 'project-current)
           (let ((pr (project-current nil)))
             (when pr
               (car (project-roots pr)))))
      default-directory))

(defun spacexnu/python-venv-cache-clear ()
  (interactive)
  (let ((root (spacexnu/python-project-root)))
    (remhash root spacexnu/python-venv-cache)
    (message "Python venv cache cleared for: %s" root)))

(global-set-key (kbd "C-c p v") #'spacexnu/python-venv-cache-clear)

(defun spacexnu/python-venv-cache-invalidate-on-save ()
  (let ((file (buffer-file-name)))
    (when file
      (let ((name (file-name-nondirectory file)))
        (when (member name '("pyproject.toml" "Pipfile"))
          (remhash (spacexnu/python-project-root) spacexnu/python-venv-cache))))))

(add-hook 'after-save-hook #'spacexnu/python-venv-cache-invalidate-on-save)

(defun spacexnu/python-venv-auto ()
  (let* ((root (spacexnu/python-project-root))
         (cached (gethash root spacexnu/python-venv-cache 'unset)))
    (when (eq cached 'unset)
      (let ((candidates '(".venv" "venv" "env"))
            (venv nil)
            (venv-path nil))
        (dolist (d candidates)
          (when (and (not venv) (file-exists-p (expand-file-name d root)))
            (setq venv d)))
        (when venv
          (setq venv-path (expand-file-name venv root)))
        (when (and (not venv-path) (file-exists-p (expand-file-name "pyproject.toml" root))
                   (executable-find "poetry"))
          (setq venv-path (ignore-errors
                            (car (process-lines "poetry" "env" "info" "-p")))))
        (when (and (not venv-path) (file-exists-p (expand-file-name "Pipfile" root))
                   (executable-find "pipenv"))
          (setq venv-path (ignore-errors
                            (car (process-lines "pipenv" "--venv")))))
        (puthash root (or venv-path :none) spacexnu/python-venv-cache)
        (setq cached (gethash root spacexnu/python-venv-cache))))
    (when (and cached (not (eq cached :none)))
      (let ((py (expand-file-name "bin/python" cached)))
        (when (file-executable-p py)
          (setq-local python-shell-interpreter py)
          (setenv "VIRTUAL_ENV" cached)
          (setenv "PATH" (concat (file-name-directory py) ":" (getenv "PATH")))
          (message "Python venv: %s" cached))))))

(defun spacexnu/python-setup ()
  ;; Emacs 29+: python-ts-mode exists; otherwise fall back to python-mode
  (spacexnu/python-venv-auto)
  (when (fboundp 'eglot-ensure)
    (eglot-ensure)))

(add-hook 'python-ts-mode-hook #'spacexnu/python-setup)
(add-hook 'python-mode-hook #'spacexnu/python-setup)

;; Formatter: ruff (preferred), fall back to black if you want
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
