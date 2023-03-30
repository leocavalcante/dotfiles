(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(setq x-select-enable-clipboard t)

(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)
(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs flycheck company which-key dap-mode php-mode magit projectile multiple-cursors material-theme phpactor company-phpactor))
(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

(add-hook 'php-mode-hook 'lsp)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(delete-selection-mode 1)
(ido-mode 1)
(load-theme 'material t)
(menu-bar-mode -1)
(which-key-mode)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-php)
  (yas-global-mode))

