(set-face-attribute 'default nil :family "JetBrains Mono" :height 120 :weight 'light)
(add-to-list 'default-frame-alist '(alpha 95 90))

(setq auto-save-default t
      custom-file "~/.emacs.default/custom.el"
      ido-everywhere t
      inhibit-startup-message t
      make-backup-files nil
      ns-use-proxy-icon nil
      package-enable-at-startup nil
      vc-follow-symlinks t)

(delete-selection-mode t)
(ido-mode t)
(load custom-file)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode t)
(tool-bar-mode -1)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(global-set-key (kbd "S-C-<left>") 'shrink-window-horizontally)
(global-set-key (kbd "S-C-<right>") 'enlarge-window-horizontally)
(global-set-key (kbd "S-C-<down>") 'shrink-window)
(global-set-key (kbd "S-C-<up>") 'enlarge-window)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(use-package doom-themes
  :ensure t
  :config
  (setq doom-themes-enable-bold t
        doom-themes-enable-italic t)
  (load-theme 'doom-city-lights t)
  (doom-themes-visual-bell-config)
  (setq doom-themes-treemacs-theme "doom-atom")
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package yaml-mode
  :ensure t)

(use-package magit
  :ensure t
  :bind ("M-g" . magit))

(use-package company
  :ensure t
  :init (setq company-minimum-prefix-length 0)
  :config (global-company-mode t))

(use-package flycheck
  :ensure t
  :config (global-flycheck-mode)
  :hook
  (flycheck-mode-hook . flycheck-highlighting-mode)
  (flycheck-mode-hook . flycheck-indication-mode))

(use-package projectile
  :ensure t
  :init (projectile-mode +1)
  :bind
  (:map projectile-mode-map ("C-c p" . projectile-command-map))
  (:map projectile-mode-map ("C-c f" . projectile-find-file)))

(use-package yasnippet
  :ensure t
  :config (yas-global-mode t))

(use-package php-mode
  :ensure t)

(use-package lsp-mode
  :ensure t
  :init (setq lsp-file-watch-threshold 5000)
  :hook (php-mode . lsp))

(use-package auto-complete
  :ensure t)

(use-package treemacs
  :ensure t
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  :bind
  (:map global-map ("C-\\" . treemacs))
  (:map global-map ("C-c \\" . treemacs-add-and-display-current-project-exclusively)))

(use-package lsp-treemacs
  :after (treemacs lsp-mode)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-all-the-icons
  :ensure t)

(use-package multiple-cursors
  :ensure t
  :bind (("C-c d" . mc/mark-next-like-this)
	 ("C-c C-d" . mc/mark-all-like-this)))

(use-package psysh
  :ensure t)

(use-package wakatime-mode
  :ensure t
  :config (global-wakatime-mode t))

(use-package dockerfile-mode
  :ensure t)

(use-package copilot
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :ensure t
  :hook (prog-mode . copilot-mode)
  :bind ("C-q" . copilot-accept-completion))

(use-package gptel
  :ensure t)

(use-package org
  :ensure t
  :init (setq org-ellipsis " ⇂"
	      org-hide-emphasis-markers t))

(use-package org-modern
  :ensure t
  :hook (org-mode . org-modern-mode))

(use-package visual-fill-column
  :ensure t
  :init (setq visual-fill-column-center-text t)
  :hook (org-mode . visual-fill-column-mode))

(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))

(use-package composer
  :ensure t)

(use-package org-present
  :ensure t)
