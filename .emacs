;; Load package manager
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

;; Load use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
;;(require 'diminish)
;;(require 'bind-key)

(setq use-package-always-ensure t)

;; Startup
(cua-mode t)
(setq make-backup-files nil
      inhibit-startup-screen t
      tab-always-indent nil
      tab-width 4)
(setq-default c-basic-offset tab-width)

;; User interface
(electric-pair-mode 1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode 1)
(tool-bar-mode -1)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(global-visual-line-mode t)
(set-fontset-font t 'symbol "Noto Color Emoji")
(set-frame-parameter (selected-frame) 'alpha ' 85)

;; User keybindings
(global-set-key [mouse-8] 'previous-buffer)
(global-set-key [mouse-9] 'next-buffer)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "C-k") 'shell)

;; Monokai theme
(use-package monokai-theme
  :config (load-theme 'monokai t))

;; Nyancat the cutest
(use-package nyan-mode
  :custom
  (nyan-animation-frame-interval 0.07)
  (nyan-wavy-trail t)
  (nyan-animate-nyancat t)
  :config
  (nyan-mode))

;; Helm
(use-package helm
  :bind (([remap find-file] . helm-find-files)
	 ([remap execute-extended-command] . helm-M-x)
	 ([remap switch-to-buffer] . helm-mini)
	 ("C-c C-f" . helm-recentf))
  :config (helm-mode))
(use-package helm-xref)

;; LSP
(use-package lsp-mode
  :hook ((c-mode . lsp)
	 (c++-mode . lsp)
	 (java-mode . lsp)
	 (text-mode . lsp))
  :config (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  :commands lsp)

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-java
  :custom
  (lsp-java-format-enabled nil)
  (lsp-java-format-on-type-enabled nil))

(use-package lsp-treemacs
  :custom (treemacs-width 25)
  :bind ([f8] . treemacs))

(use-package lsp-grammarly
  :ensure t
  :hook (text-mode . (lambda ()
                       (require 'lsp-grammarly)
                       (lsp))))
;; DAP
(use-package dap-mode
  :custom (dap-auto-show-output nil)
  :bind (([f5] . dap-debug)
	 ([S-f5] . dap-disconnect)
	 ([f9] . dap-breakpoint-toggle)
	 ([f10] . dap-next)
	 ([f11] . dap-step-in)
	 ([S-f11] . dap-step-out))
  :commands dap-debug
  :config
  (require 'dap-cpptools)
  (dap-cpptools-setup)
  (require 'dap-java)
)

;; Autocomplete
(use-package company
  :config (global-company-mode t))
(use-package company-c-headers
  :config
  (add-to-list 'company-backends 'company-c-headers)
  (add-to-list 'company-c-headers-path-system "/usr/include/c++/11.1.0/")
  (add-to-list 'company-c-headers-path-user "/home/dung/C++/"))

;; Realtime error checking
(use-package flycheck
  :config
  (global-flycheck-mode)
  :custom
  (flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;; Beautifying org-mode
(use-package org-bullets
  :hook ((org-mode . org-bullets-mode)
	 (org-mode . visual-line-mode))
  :custom
  (org-ellipsis " ≫")
  (org-hide-emphasis-markers t)
  (org-startup-indented t)
  (org-support-shift-select 'always)
  (org-todo-keywords '((sequence "☛ TODO(t)" "|" "✔ DONE(d)")
		      (sequence "⚑ WAITING(w)" "|")
		      (sequence "|" "✘ CANCELED(c)")))
  :config
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) " (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))))

;; Markdown
(use-package markdown-mode
  :custom
  (markdown-enable-math t)
  (markdown-fontify-code-blocks-natively t))

;; Run command instantly
(use-package quickrun
  :bind ("C-M-n" . quickrun-shell))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(flymake-lua company-lua lua-mode keytar)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))
