(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

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
  (load bootstrap-file nil 'nomessage))

(use-package emacs
  :init
  (setq make-backup-files nil)
  (setq-default tab-width 4)
  (setq vc-follow-symlinks t)
  (setq visible-bell t)
  (setq read-file-name-completion-ignore-case t)
  (setq make-backup-files nil)
  :config
  (menu-bar-mode -1)
  (add-hook 'prog-mode-hook 'display-line-numbers-mode))

(use-package magit
  :ensure t)

(use-package vertico
  :ensure t
  :config
  (vertico-mode))

(use-package copilot
  :straight (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :ensure t)

(use-package gptel
  :straight t
  :ensure t)

(use-package lsp-mode
  :ensure t)

(use-package php-mode
  :ensure t
  :config
  (add-hook 'php-mode-hook 'lsp-mode))

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
