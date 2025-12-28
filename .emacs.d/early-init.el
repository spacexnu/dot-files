;;; early-init.el --- fast startup -*- lexical-binding: t; -*-

(setq package-enable-at-startup nil)
(setq gc-cons-threshold (* 128 1024 1024))
(setq read-process-output-max (* 1024 1024)) ;; LSP gosta disso

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; macOS: melhora fluidez em fontes/retina
(setq inhibit-compacting-font-caches t)
