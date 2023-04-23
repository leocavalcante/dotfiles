;;; init.el --- Emacs Init file

;;; Commentary:
;;
;;; Code:

(setq auto-save-default t
      ido-everywhere t
      make-backup-files nil
      vc-follow-symlinks t)

(delete-selection-mode t)
(global-display-line-numbers-mode t)
(ido-mode t)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode t)
(tool-bar-mode -1)
(yas-global-mode t)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

(load-theme 'wombat t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(use-package company
  :ensure t
  :init (setq company-minimum-prefix-length 0)
  :config (global-company-mode t))

(use-package dockerfile-mode
  :ensure t)

(use-package multiple-cursors
  :ensure t
  :bind (("C-c d" . mc/mark-next-like-this)
	 ("C-c C-d" . mc/mark-all-like-this)))

(use-package lsp-mode
  :ensure t
  :hook (php-mode . lsp))

(use-package lsp-ui
  :ensure t)

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode)
  :hook
  (flycheck-mode-hook . flycheck-highlighting-mode)
  (flycheck-mode-hook . flycheck-indication-mode))

(use-package magit
  :ensure t)

(use-package projectile
  :ensure t
  :init (projectile-mode +1)
  :bind
  (:map projectile-mode-map ("C-c p" . projectile-command-map))
  (:map projectile-mode-map ("C-c f" . projectile-find-file)))

(use-package treemacs
  :ensure t
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  :bind
  (:map global-map ("C-\\" . treemacs))
  (:map global-map ("C-c \\" . treemacs-add-and-display-current-project-exclusively)))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)


;; customize (do not edit)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yasnipet ido company-mode yasnippet treemacs-projectile treemacs-magit php-mode multiple-cursors lsp-ui lsp-treemacs flycheck company-phpactor)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)

;;; init.el ends here
