(setq make-backup-files nil)
(setq vc-follow-symlinks t)
(setq visible-bell t)

(menu-bar-mode -1)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package go-mode
  :ensure t
  :config
  (add-hook 'go-mode-hook 'eglot-ensure))

(use-package eglot
  :ensure t)

(use-package yasnippet
  :ensure t
  :config
  (yas-global-mode))

(use-package yasnippet-snippets
  :ensure t)

(use-package company
  :ensure t
  :config
  (global-company-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(yasnippet-snippets)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
