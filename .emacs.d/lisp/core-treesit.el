;;; core-treesit.el --- tree-sitter setup -*- lexical-binding: t; -*-

(when (and (fboundp 'treesit-available-p)
           (treesit-available-p)
           (boundp 'treesit-language-source-alist))
  (dolist (entry '((python "https://github.com/tree-sitter/tree-sitter-python")
                   (go "https://github.com/tree-sitter/tree-sitter-go")
                   (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
                   (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
                   (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")))
    (add-to-list 'treesit-language-source-alist entry))

  (dolist (entry '((python-mode . python-ts-mode)
                   (go-mode . go-ts-mode)
                   (js-mode . js-ts-mode)
                   (js2-mode . js-ts-mode)
                   (typescript-mode . typescript-ts-mode)))
    (add-to-list 'major-mode-remap-alist entry))

  (defun spacexnu/treesit-install-language-grammars ()
    "Install tree-sitter grammars for configured languages."
    (interactive)
    (dolist (lang '(python go javascript typescript tsx))
      (unless (treesit-language-available-p lang)
        (treesit-install-language-grammar lang)))))

(provide 'core-treesit)
;;; core-treesit.el ends here
