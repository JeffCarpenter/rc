;; Overiding org-capture-place-template function


;; [[file:~/.setup/xemacs/elpa/pkgs/org-onchnage/org-capture+.org::*Overiding%20org-capture-place-template%20function][Overiding org-capture-place-template function:1]]
(defun org-capture-place-template (&optional inhibit-wconf-store)
  "Insert the template at the target location, and display the buffer.
When `inhibit-wconf-store', don't store the window configuration, as it
may have been stored before."
  (unless inhibit-wconf-store
    (org-capture-put :return-to-wconf (current-window-configuration)))
  (delete-other-windows)
  (org-switch-to-buffer-other-window
   (org-capture-get-indirect-buffer (org-capture-get :buffer) "CAPTURE"))
  (widen)
  (outline-show-all)
  (goto-char (org-capture-get :pos))
  (setq-local outline-level 'org-outline-level)
  (pcase (org-capture-get :type)
    ((or `nil `entry) (org-capture-place-entry))
    (`table-line (org-capture-place-table-line))
    (`plain (org-capture-place-plain-text))
    (`item (org-capture-place-item))
    (`checkitem (org-capture-place-item))
    (`note (org-capture-place-note)))
  (org-capture-mode 1)
  (setq-local org-capture-current-plist org-capture-plist))
;; Overiding org-capture-place-template function:1 ends here

;; Providing log note function for capture


;; [[file:~/.setup/xemacs/elpa/pkgs/org-onchnage/org-capture+.org::*Providing%20log%20note%20function%20for%20capture][Providing log note function for capture:1]]
(defun org-capture-place-note ()
  "Place the template plainly.
If the target locator points at an Org node, place the template into
the text of the entry, before the first child.  If not, place the
template at the beginning or end of the file.
Of course, if exact position has been required, just put it there."
  (let* ((txt (org-capture-get :template))
         beg end)
    (cond
      ((org-capture-get :exact-position)
       (goto-char (org-capture-get :exact-position)))
      ((and (org-capture-get :target-entry-p)
            (bolp)
            (looking-at org-outline-regexp))
       ;; we should place the text into this entry
       (if (org-capture-get :prepend)
           ;; Skip meta data and drawers
           (org-end-of-meta-data t)
           ;; go to ent of the entry text, before the next headline
           (outline-next-heading)))
      (t
       ;; beginning or end of file
       (goto-char (if (org-capture-get :prepend) (point-min) (point-max)))))
    (or (bolp) (newline))
    (org-capture-empty-lines-before)
    (setq beg (point))
    (insert txt)
    (org-capture-empty-lines-after)
    (org-capture-position-for-last-stored beg)
    (setq end (point))
    (org-capture-mark-kill-region beg (1- end))
    (org-capture-narrow beg (1- end))
    (if (or (re-search-backward "%\\?" beg t)
            (re-search-forward "%\\?" end t))
        (replace-match ""))))
;; Providing log note function for capture:1 ends here
