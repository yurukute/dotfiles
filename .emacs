(setq vc-follow-symlinks t)

(org-babel-load-file "~/init.org")

(custom-set-variables
 '(package-selected-packages '(sql-indent keytar)))
(custom-set-faces)

(when (cl-find-if-not #'package-installed-p package-selected-packages)
  (package-refresh-contents)
  (mapc #'package-install package-selected-packages))
