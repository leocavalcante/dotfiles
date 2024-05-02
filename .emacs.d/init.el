(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (setq straight-check-for-modifications '(watch-files))
  (load bootstrap-file nil 'nomessage))

(use-package emacs
  :init  
  (setq make-backup-files nil)
  (setq read-file-name-completion-ignore-case t)
  (setq vc-follow-symlinks t)
  (setq visible-bell t)
  (setq-default tab-width 4)
  (setq make-backup-files nil)
  :config
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  :hook
  (prog-mode . display-line-numbers-mode))

(use-package company :config (global-company-mode))
(use-package copilot :straight t :defer t)
(use-package go-mode :hook (go-mode . lsp-mode))
(use-package lsp-mode)
(use-package magit :defer t)
(use-package php-mode :hook (php-mode . lsp-mode))
(use-package vertico :config (vertico-mode))
(use-package yasnippet :config (yas-global-mode))
(use-package yasnippet-snippets :defer t)

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
