;;; init-packages.el --- package.el + use-package setup -*- lexical-binding: t; -*-

(require 'package)

(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                         ("melpa" . "https://melpa.org/packages/")))
(setq package-archive-priorities '(("gnu" . 2)
                                   ("melpa" . 1)))

(unless package--initialized
  (package-initialize))

(unless (package-installed-p 'use-package)
  (unless package-archive-contents
    (package-refresh-contents))
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(provide 'init-packages)
;;; init-packages.el ends here
