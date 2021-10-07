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
(setq c-tab-always-indent nil      
      inhibit-startup-screen t
      recentf-auto-cleanup 'never      
      tab-always-indent nil
      tab-width 4
      make-backup-files nil)
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
  :custom (helm-ff-file-name-history-use-recentf t)
  :config (helm-mode))
(use-package helm-xref)

;; LSP
(use-package lsp-mode
  :hook ((c-mode . lsp)
	 (c++-mode . lsp)
	 (java-mode . lsp))
  :config (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  :commands lsp)

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode))

(use-package lsp-java
  :custom
  ;(lsp-java-format-enabled nil)
  (lsp-java-format-on-type-enabled nil))

(use-package lsp-treemacs
  :custom (treemacs-width 25)
  :bind ([f8] . treemacs))

;; DAP
(use-package dap-mode
  :custom
  ;;(dap-auto-configure-features '(sessions locals expressions controls tooltip))
  (dap-auto-show-output nil)
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
  (add-to-list 'dap-debug-template-configurations
	       '("Noob - Build and debug C/C++"
		  :type "cppdbg"
		  :request "launch"
		  :name "cpptools::Run Configuration"
		  :MIMode "gdb"
		  :program "${fileDirname}/${fileBasenameNoExtension}"
		  :cwd "${fileDirname}"
		  :dap-compilation "g++ -g ${file} -o ${fileDirname}/${fileBaseNameNoExtension}"))
  (add-to-list 'dap-debug-template-configurations
	       '("Noob - Debug java"
		 :name "Debug current file"
                 :type "java"	
                 :request "launch"
                 :mainClass nil)))
;; Autocomplete
(use-package company
  :config (global-company-mode t))
(use-package company-c-headers
  :config
  (add-to-list 'company-backends 'company-c-headers)
  (add-to-list 'company-c-headers-path-system "/usr/include/c++/11.1.0/")
  (add-to-list 'company-c-headers-path-user "/home/dung/C++/"))
(use-package yasnippet  
  :config  (yas-global-mode t))

;; Realtime error checking
(use-package flycheck
  :config
  (global-flycheck-mode)
  :custom
  (flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

;; BEAUTIFYING ORG-MODE
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda-list)
(global-set-key (kbd "C-c c") #'org-capture)

(setq org-agenda-files '("~/Agenda")
      org-edit-src-content-indentation 4
      org-ellipsis " ⤵"
      org-fontify-done-headline t
      org-hide-emphasis-markers t
      org-hide-leading-stars t
      org-pretty-entities t
      org-startup-indented t
      org-support-shift-select t
      org-todo-keywords '((sequence "☛ TODO(t)" "|" "✔ DONE(d)")
			  (sequence "⚑ WAITING(w)" "|")
			  (sequence "|" "✘ CANCELED(c)")))
(require 'org-tempo)
(setq-default prettify-symbols-alist '(("#+begin_src" . "†")
				       ("#+end_src" . "†")
				       (">=" . "≥")
				       ("<=" . "≤")
				       ("=>" . "⇨")))
(setq prettify-symbols-unprettify-at-point 'right-edge)
(add-hook 'org-mode-hook (lambda()
			   (visual-line-mode)
			   (variable-pitch-mode) 
			   (prettify-symbols-mode)))
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) " (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))
(font-lock-add-keywords 'org-mode
                        '(("^ *\\([+]\\) " (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "◦"))))))

(use-package org-bullets
  :hook ((org-mode . org-bullets-mode)))

(use-package org-fancy-priorities
  :hook (org-mode . org-fancy-priorities-mode)
  :custom (org-fancy-priorities-list '("⚡" "⬆" "⬇" "☕")))

(use-package org-pretty-tags
  :config
  (add-to-list 'org-pretty-tags-surrogate-strings '("hw" . "✍"))
  (org-pretty-tags-global-mode))

(use-package org-super-agenda
  :hook (org-mode . org-super-agenda-mode))

;; Markdown
(use-package markdown-mode
  :custom
  (markdown-enable-math t)
  (markdown-fontify-code-blocks-natively t))

;; Open file in external program
(use-package openwith
  :custom
  (openwith-associations '(("\\.pdf\\'" "microsoft-edge-dev" (file))
			   ("\\.mp3\\'" "sox" (file))
			   ("\\.\\(?:mpe?g\\|avi\\|wmv\\)\\'" "mpv" (file))
			   ("\\.\\(?:jp?g\\|png\\)\\'" "feh" (file))))
  :config (openwith-mode t))

;; Control popup window
(use-package popwin
  :config
  (push '("*helm*" :regexp t :height 20) popwin:special-display-config)
  (push '("*shell*" :regexp t :height 10) popwin:special-display-config)
  (popwin-mode 1))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(org-super-agenda rainbow-mode yasnippet-snippets flymake-lua company-lua lua-mode keytar)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fixed-pitch ((t (:family "monospace"))))
 '(org-block ((t (:inherit fixed-pitch))))
 '(org-document-info-keyword ((t (:inherit (shadow fixed-pitch)))))
 '(org-property-value ((t (:inherit fixed-pitch))) t)
 '(org-special-keyword ((t (:inherit (font-lock-comment-face fixed-pitch)))))
 '(org-table ((t (:inherit fixed-pitch :foreground "#82d7ff"))))
 '(org-verbatim ((t (:inherit (shadow fixed-pitch))))))

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))
