(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)
(package-initialize)

(setq package-selected-packages '(helm helm-xref yasnippet flycheck company nyan-mode monokai-theme rainbow-mode lua-mode company-lua flymake-lua))

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

;; FLYCHECK  - REALTIME ERROR CHECKING
(global-flycheck-mode)

;;some useful global key
(global-set-key (kbd "C-M-n") 'compile)
(global-set-key [f5] 'debug)
(global-set-key (kbd "C-x k") 'kill-current-buffer)
(global-set-key (kbd "C-k") 'shell)
(global-set-key (kbd "C-x d") 'neotree-dir)

;;neotree
(defun my-neotree-project-dir-toggle ()
  "Toggle neotree at current dir."
  (interactive)
  (require 'neotree)
  (let* ((filepath (buffer-file-name))
         (project-dir
          (with-demoted-errors
              (cond
               ((featurep 'projectile)
                (projectile-project-root))
               ((featurep 'find-file-in-project)
                (ffip-project-root))))))
    (neotree-toggle)
    (when project-dir
      (neotree-dir project-dir))))

(global-set-key [f8] 'my-neotree-project-dir-toggle)

;;monokai theme
(load-theme 'monokai t)

;;transparent
(set-frame-parameter (selected-frame) 'alpha ' 90)

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
 '(menu-bar-mode nil)
 '(neo-show-hidden-files t)
 '(neo-show-slash-for-folder nil)
 '(neo-smart-open t)
 '(neo-theme 'icons)
 '(neo-toggle-window-keep-p t)
 '(nyan-mode t)
 '(package-selected-packages
   '(lua-mode company-lua flymake-lua magit git all-the-icons neotree markdown-preview-mode flymd helm-xref helm yasnippet flycheck company nyan-mode monokai-theme))
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(tab-always-indent nil)
 '(tab-width 4)
 '(tool-bar-mode nil)
 '(use-package-always-ensure t)
 '(word-wrap t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
