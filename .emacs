(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(setq package-selected-packages '(lsp-mode yasnippet lsp-treemacs helm-lsp
    projectile hydra flycheck company avy which-key helm-xref dap-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

(which-key-mode)
(add-hook 'c-mode-hook 'lsp)
(add-hook 'c++-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1)  ;; clangd is fast

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))

(global-company-mode t)
(global-flycheck-mode t)

;; org-mode
(require 'org-bullets)
(add-hook 'org-mode-hook (lambda () (org-bullets-mode 1)))
(add-hook 'org-mode-hook 'visual-line-mode)
(setq org-ellipsis " ≫")
(setq org-hide-emphasis-markers t)
(setq org-startup-indented t)
(setq org-support-shift-select 'always)
(setq org-todo-keywords '((sequence "☛ TODO(t)" "|" "✔ DONE(d)")
						  (sequence "⚑ WAITING(w)" "|")
						  (sequence "|" "✘ CANCELED(c)")))
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(when (display-graphic-p)
   (setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING)))
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; user keybindings
(global-set-key [f5] 'gdb)
(global-set-key [f8] 'treemacs)

(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "C-k") 'shell)

;; set tab to 4 spaces
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

;; monokai theme
(load-theme 'monokai t)

;; transparent
(set-frame-parameter (selected-frame) 'alpha ' 85)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(electric-pair-mode t)
 '(global-display-line-numbers-mode t)
 '(inhibit-startup-screen t)
 '(make-backup-files nil)
 '(markdown-enable-math t)
 '(markdown-fontify-code-blocks-natively t)
 '(menu-bar-mode nil)
 '(nyan-mode t)
 '(package-selected-packages
   '(lsp-ui lsp-mode yasnippet lsp-treemacs helm-lsp projectile hydra flycheck company avy which-key helm-xref dap-mode monokai-theme rainbow-mode org-bullets nyan-mode lua-mode lsp-java flymake-lua company-lua arduino-mode))
 '(quickrun-focus-p nil)
 '(quickrun-timeout-seconds 1)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tab-always-indent nil)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(treemacs-width 25)
 '(use-package-always-ensure t)
 '(word-wrap t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
