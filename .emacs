 (require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(setq package-selected-packages '(org-bullets auto-complete java-snippets quickrun markdown-mode use-package treemacs arduino-mode yasnippet lua-mode company-lua flymake-lua all-the-icons neotree helm-xref helm flycheck company nyan-mode monokai-theme rainbow-mode))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))

;; sample `helm' configuration use https://github.com/emacs-helm/helm/ for details
(helm-mode)
(require 'helm-xref)
(define-key global-map [remap find-file] #'helm-find-files)
(define-key global-map [remap execute-extended-command] #'helm-M-x)
(define-key global-map [remap switch-to-buffer] #'helm-mini)

;;autocomplete and Snippet
(global-company-mode t)
(require 'yasnippet)
(yas-global-mode 1)
(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

;; FLYCHECK  - REALTIME ERROR CHECKING
(global-flycheck-mode)

;; irony-mode
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

;; user keybindings
(global-set-key [f5] 'gdb)
(global-set-key [f8] 'treemacs)

(global-set-key (kbd "C-M-n") 'quickrun)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "C-k") 'shell)

;;set tab to 4 spaces
(defvaralias 'c-basic-offset 'tab-width)
(defvaralias 'cperl-indent-level 'tab-width)

;;org-mode
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
;;(font-lock-add-keywords 'org-mode
;;                        '(("^ *\\([-]\\) "
;;                           (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
;;monokai theme
(load-theme 'monokai t)

;;transparent
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
   '(org-bullets auto-complete java-snippets quickrun markdown-mode use-package treemacs arduino-mode yasnippet lua-mode company-lua flymake-lua all-the-icons neotree helm-xref helm flycheck company nyan-mode monokai-theme rainbow-mode))
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
