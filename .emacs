(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(setq package-selected-packages '(lsp-mode lsp-ui lsp-treemacs lsp-java helm-lsp helm-xref flycheck company org-bullets monokai-theme))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

(load-theme 'monokai t)
(set-frame-parameter (selected-frame) 'alpha ' 85)
(setq make-backup-files nil)
(cua-mode t)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; helm
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

;; lsp-mode
(add-hook 'c-mode-hook #'lsp)
(add-hook 'c++-mode-hook #'lsp)
(setq-default c-basic-offset 4)

(require 'lsp-java)
(add-hook 'java-mode-hook #'lsp)

;; Autocomplete and error checking
(global-company-mode t)
(global-flycheck-mode t)
(require 'company-c-headers)
(add-to-list 'company-backends 'company-c-headers)
(add-to-list 'company-c-headers-path-system "/usr/include/c++/11.1.0")

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
(global-set-key (kbd "C-M-n") 	'quickrun)
(global-set-key (kbd "C-x k") 	'kill-current-buffer)
(global-set-key (kbd "C-k") 	'shell)
(global-set-key (kbd "C-c f") 	'helm-recentf)

(set-fontset-font t 'symbol "Noto Color Emoji")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(electric-pair-mode t)
 '(global-visual-line-mode t)
 '(helm-ff-file-name-history-use-recentf t)
 '(inhibit-startup-screen t)
 '(markdown-enable-math t)
 '(markdown-fontify-code-blocks-natively t)
 '(menu-bar-mode nil)
 '(nyan-animate-nyancat t)
 '(nyan-animation-frame-interval 0.1)
 '(nyan-mode t)
 '(nyan-wavy-trail t)
 '(package-selected-packages
   '(lsp-java quickrun company-c-headers company-lua flymake-lua lua-mode rainbow-mode nyan-mode lsp-mode lsp-ui lsp-treemacs helm-lsp helm-xref flycheck company dap-mode hydra monokai-theme org-bullets))
 '(recentf-auto-cleanup 'never)
 '(recentf-mode t)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tab-always-indent nil)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(treemacs-width 25)
 '(word-wrap t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
