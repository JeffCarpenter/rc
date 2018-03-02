(defun org-babel-untangle ()
  (interactive)
  (let ((file-name (buffer-file-name))
        (file-major-mode (replace-regexp-in-string
                          "-mode\$"
                          ""
                          (symbol-name major-mode))))
    (if file-name
        (let* ((file-name-san-ext (file-name-sans-extension (file-name-nondirectory file-name)))
               (org-file-name  (concat file-name-san-ext ".org"))
               (file-extention (file-name-extension file-name))
               (tangle-file (if file-extention "yes" file-name-san-ext)))
          (if (not
               (or
                (eq file-extention "org")
                (eq 'org-mode major-mode)))
              (with-current-buffer (find-file-noselect org-file-name)
                (insert (format "#+TITLE: %s\n" file-name-san-ext))
                (insert (format
                         "#+PROPERTY: header-args :tangle %s :padline ys :comments both :noweb yes\n"
                         tangle-file))
                (insert "\n\n")
                (insert (format "* %s\n\n" file-name-san-ext))
                (insert (format "#+begin-src %s\n" file-major-mode))
                (goto-char (+
                            (point)
                            (nth 1 (insert-file-contents file-name))))
                (insert "#+end-src\n")
                (save-buffer))
              (error "%s is already is org file." file-name)))
        (error "buffer not associated with any file."))))
