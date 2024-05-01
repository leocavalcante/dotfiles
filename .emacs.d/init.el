(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

(use-package emacs
  :init
  (setq make-backup-files nil)
  (setq tab-width 4)
  (setq vc-follow-symlinks t)
  (setq visible-bell t)
  :config
  (menu-bar-mode -1)
  (add-hook 'prog-mode-hook 'display-line-numbers-mode))

(use-package lsp-mode
  :ensure t)

(use-package go-mode
  :ensure t
  :config
  (add-hook 'go-mode-hook 'lsp-mode))

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
(put 'upcase-region 'disabled nil)
