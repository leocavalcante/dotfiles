(setq auto-save-default t
      custom-file "~/.emacs.default/custom.el"
      make-backup-files nil
      package-enable-at-startup nil
      ido-everywhere t
      inhibit-startup-message t
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

(use-package autothemer :ensure t)

(straight-use-package
 '(rose-pine-emacs
   :host github
   :repo "thongpv87/rose-pine-emacs"
   :branch "master"))
(load-theme 'rose-pine-color t)

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

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
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
