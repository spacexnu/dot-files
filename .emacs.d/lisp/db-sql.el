;;; db-sql.el --- databases/sql -*- lexical-binding: t; -*-

;; sql-mode is built-in
(use-package sql
  :ensure nil
  :init
  (setq sql-input-ring-file-name (expand-file-name "sql-history" user-emacs-directory)
        sql-product 'postgres))

;; Shortcut: open SQL prompt quickly
(global-set-key (kbd "C-c d s") #'sql-postgres)

(provide 'db-sql)
;;; db-sql.el ends here
