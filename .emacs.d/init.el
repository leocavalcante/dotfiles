;;; init.el --- Emacs Init file

;;; Commentary:
;; 

;;; Code:
(setq make-backup-files nil
      auto-save-default t)
(defalias 'yes-or-no 'y-or-n-p)

(delete-selection-mode t)
(global-display-line-numbers-mode t)
(global-hl-line-mode t)
(load-theme 'material t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(show-paren-mode t)
(yas-global-mode t)

(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(use-package multiple-cursors
  :ensure t
    :bind (("C-c d" . mc/mark-next-like-this)
          ("C-c C-d" . mc/mark-all-like-this)))
 
(use-package phpactor :ensure t)
(use-package company-phpactor :ensure t)
(use-package php-mode
   :after (phpactor company-phpactor)
  :ensure t
    :hook ((php-mode . (lambda () (set (make-local-variable 'company-backends)
           '(company-phpactor company-files))))))

(use-package lsp-mode
   :after (php-mode)
  :ensure t
    :hook (php-mode . lsp))
(use-package lsp-ui
   :after (lsp-mode)
  :ensure t)

(use-package flycheck
  :ensure t
    :init (global-flycheck-mode)
    :hook (flycheck-mode-hook . flycheck-highlighting-mode)
          (flycheck-mode-hook . flycheck-indication-mode))

(use-package magit :ensure t)

(use-package projectile
  :ensure t
    :init (projectile-mode +1)
    :bind (:map projectile-mode-map ("C-c p" . projectile-command-map))
          (:map projectile-mode-map ("C-c f" . projectile-find-file)))

(use-package treemacs
  :ensure t
  :config (treemacs-follow-mode t)
          (treemacs-filewatch-mode t)
    :bind (:map global-map ("C-c t" . treemacs))
	  (:map global-map ("C-c C-t" . treemacs-add-and-display-current-project-exclusively)))
(use-package treemacs-projectile
   :after (treemacs projectile)
  :ensure t)
(use-package treemacs-magit
   :after (treemac magit)
  :ensure t)


;; customize (do not edit)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yasnippet treemacs-projectile treemacs-magit php-mode multiple-cursors material-theme lsp-ui lsp-treemacs flycheck company-phpactor)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)

;;; init.el ends here
