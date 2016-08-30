;;; XEmacs backwards compatibility file
(let* ((dist-dir (getenv "EMACS_DIST_DIR"))
       (dist-dir
        (if dist-dir
            (cond
             ((file-directory-p dist-dir)
              dist-dir)
             ((file-directory-p (expand-file-name dist-dir (getenv "HOME")))
                            (expand-file-name dist-dir (getenv "HOME")))
             (t (expand-file-name ".xemacs" "~")))
          (expand-file-name ".xemacs" "~"))))

  (setq user-init-file
        (expand-file-name "init.el"
                          dist-dir
                          ;; (expand-file-name ".xemacs" "~")
                          ;; (expand-file-name "~/.emacs.d")
                          ))
  (if (string-equal dist-dir (expand-file-name ".xemacs" "~"))
      (setq custom-file
        (expand-file-name "custom.el"
                          (expand-file-name ".xemacs" "~"))))
  (message "%s %s" dist-dir user-init-file)
  (load-file user-init-file))
;; (load-file custom-file)
