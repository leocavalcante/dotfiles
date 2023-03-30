(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs flycheck company php-mode magit projectile multiple-cursors material-theme phpactor company-phpactor go-mode))
(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

(add-hook 'go-mode-hook 'lsp)
(add-hook 'php-mode-hook 'lsp)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(delete-selection-mode 1)
(load-theme 'material t)
(menu-bar-mode 0)
(yas-global-mode 1)
