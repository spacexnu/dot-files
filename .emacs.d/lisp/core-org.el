;;; core-org.el --- org-mode -*- lexical-binding: t; -*-

(use-package org
  :ensure nil
  :init
  (setq org-directory (expand-file-name "~/org/")
        org-default-notes-file (expand-file-name "inbox.org" org-directory)
        org-log-done 'time
        org-hide-emphasis-markers t)

  ;; Captura rápida
  (setq org-capture-templates
        '(("t" "Todo" entry
           (file+headline org-default-notes-file "Inbox")
           "* TODO %?\n  %U\n")
          ("n" "Note" entry
           (file+headline org-default-notes-file "Notes")
           "* %?\n  %U\n"))))

(global-set-key (kbd "C-c o c") #'org-capture)
(global-set-key (kbd "C-c o a") #'org-agenda)

;; Export básico pra HTML
(setq org-html-validation-link nil
      org-export-with-toc t
      org-export-with-section-numbers nil)

;; Trilho simples de publish (quando você decidir “converter o site”)
;; Ajuste paths quando usar.
(setq org-publish-project-alist
      '(("spacexnu-site"
         :base-directory "~/site-org/"
         :publishing-directory "~/site-public/"
         :recursive t
         :publishing-function org-html-publish-to-html
         :with-author nil
         :with-creator nil
         :section-numbers nil
         :time-stamp-file nil)))

(provide 'core-org)
;;; core-org.el ends here
