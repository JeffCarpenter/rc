;; Required libraries

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-capture+/org-capture+.org::*Required%20libraries][Required libraries:1]]
(require 'org-capture)
;; Required libraries:1 ends here

;; set target improved

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-capture+/org-capture+.org::*set%20target%20improved][set target improved:1]]
(defun org-capture-set-target-location-improved (&optional target)
  "Find TARGET buffer and position.
Store them in the capture property list."
  (let ((target-entry-p t))
    (save-excursion
      (pcase (or target (org-capture-get :target))
        (`(file ,path)
          (set-buffer (org-capture-target-buffer path))
          (org-capture-put-target-region-and-position)
          (widen)
          (setq target-entry-p nil))
        (`(id ,id)
          (pcase (org-id-find id)
            (`(,path . ,position)
              (set-buffer (org-capture-target-buffer path))
              (widen)
              (org-capture-put-target-region-and-position)
              (goto-char position))
            (_ (error "Cannot find target ID \"%s\"" id))))
        (`(file+headline ,path ,headline)
          (set-buffer (org-capture-target-buffer path))
          ;; Org expects the target file to be in Org mode, otherwise
          ;; it throws an error.  However, the default notes files
          ;; should work out of the box.  In this case, we switch it to
          ;; Org mode.
          (unless (derived-mode-p 'org-mode)
            (org-display-warning
             (format "Capture requirement: switching buffer %S to Org mode"
                     (current-buffer)))
            (org-mode))
          (org-capture-put-target-region-and-position)
          (widen)
          (goto-char (point-min))
          (if (re-search-forward (format org-complex-heading-regexp-format
                                         (regexp-quote headline))
                                 nil t)
              (beginning-of-line)
              (goto-char (point-max))
              (unless (bolp) (insert "\n"))
              (insert "* " headline "\n")
              (beginning-of-line 0)))
        (`(file+olp ,path . ,outline-path)
          (let ((m (org-find-olp (cons (org-capture-expand-file path)
                                       outline-path))))
            (set-buffer (marker-buffer m))
            (org-capture-put-target-region-and-position)
            (widen)
            (goto-char m)
            (set-marker m nil)))
        (`(file+regexp ,path ,regexp)
          (set-buffer (org-capture-target-buffer path))
          (org-capture-put-target-region-and-position)
          (widen)
          (goto-char (point-min))
          (if (not (re-search-forward regexp nil t))
              (error "No match for target regexp in file %s" path)
              (goto-char (if (org-capture-get :prepend)
                             (match-beginning 0)
                             (match-end 0)))
              (org-capture-put :exact-position (point))
              (setq target-entry-p
                    (and (derived-mode-p 'org-mode) (org-at-heading-p)))))
        (`(file+olp+datetree ,path . ,outline-path)
          (let ((m (if outline-path
                       (org-find-olp (cons (org-capture-expand-file path)
                                           outline-path))
                       (set-buffer (org-capture-target-buffer path))
                       (point-marker))))
            (set-buffer (marker-buffer m))
            (org-capture-put-target-region-and-position)
            (widen)
            (goto-char m)
            (set-marker m nil)
            (require 'org-datetree)
            (org-capture-put-target-region-and-position)
            (widen)
            ;; Make a date/week tree entry, with the current date (or
            ;; yesterday, if we are extending dates for a couple of hours)
            (funcall
             (if (eq (org-capture-get :tree-type) 'week)
                 #'org-datetree-find-iso-week-create
                 #'org-datetree-find-date-create)
             (calendar-gregorian-from-absolute
              (cond
                (org-overriding-default-time
                 ;; Use the overriding default time.
                 (time-to-days org-overriding-default-time))
                ((or (org-capture-get :time-prompt)
                     (equal current-prefix-arg 1))
                 ;; Prompt for date.
                 (let ((prompt-time (org-read-date
                                     nil t nil "Date for tree entry:"
                                     (current-time))))
                   (org-capture-put
                    :default-time
                    (cond ((and (or (not (boundp 'org-time-was-given))
                                    (not org-time-was-given))
                                (not (= (time-to-days prompt-time) (org-today))))
                           ;; Use 00:00 when no time is given for another
                           ;; date than today?
                           (apply #'encode-time
                                  (append '(0 0 0)
                                          (cl-cdddr (decode-time prompt-time)))))
                          ((string-match "\\([^ ]+\\)--?[^ ]+[ ]+\\(.*\\)"
                                         org-read-date-final-answer)
                           ;; Replace any time range by its start.
                           (apply #'encode-time
                                  (org-read-date-analyze
                                   (replace-match "\\1 \\2" nil nil
                                                  org-read-date-final-answer)
                                   prompt-time (decode-time prompt-time))))
                          (t prompt-time)))
                   (time-to-days prompt-time)))
                (t
                 ;; Current date, possibly corrected for late night
                 ;; workers.
                 (org-today))))
             ;; the following is the keep-restriction argument for
             ;; org-datetree-find-date-create
             (if outline-path 'subtree-at-point))))
        (`(file+function ,path ,function)
          (set-buffer (org-capture-target-buffer path))
          (org-capture-put-target-region-and-position)
          (widen)
          (funcall function)
          (org-capture-put :exact-position (point))
          (setq target-entry-p
                (and (derived-mode-p 'org-mode) (org-at-heading-p))))
        (`(function ,fun)
          (funcall fun)
          (org-capture-put :exact-position (point))
          (setq target-entry-p
                (and (derived-mode-p 'org-mode) (org-at-heading-p))))
        (`(clock)
          (if (and (markerp org-clock-hd-marker)
                   (marker-buffer org-clock-hd-marker))
              (progn (set-buffer (marker-buffer org-clock-hd-marker))
                     (org-capture-put-target-region-and-position)
                     (widen)
                     (goto-char org-clock-hd-marker))
              (error "No running clock that could be used as capture target")))
        (`(marker ,hd-mark)
          (if (and (markerp hd-marker)
                   (marker-buffer hd-marker))
              (progn (set-buffer (marker-buffer hd-marker))
                     (org-capture-put-target-region-and-position)
                     (widen)
                     (goto-char hd-marker))
              (error "No running clock that could be used as capture target")))
        (target (error "Invalid capture target specification: %S" target)))

      (org-capture-put :buffer (current-buffer)
                       :pos (point)
                       :target-entry-p target-entry-p
                       :decrypted
                       (and (featurep 'org-crypt)
                            (org-at-encrypted-entry-p)
                            (save-excursion
                              (org-decrypt-entry)
                              (and (org-back-to-heading t) (point))))))))
;; set target improved:1 ends here

;; new capture

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-capture+/org-capture+.org::*new%20capture][new capture:1]]
(defun org-capture-alt (type target template &rest plist)
    "Capture something.
  \\<org-capture-mode-map>
  This will let you select a template from `org-capture-templates', and
  then file the newly captured information.  The text is immediately
  inserted at the target location, and an indirect buffer is shown where
  you can edit it.  Pressing `\\[org-capture-finalize]' brings you back to the \
  previous
  state of Emacs, so that you can continue your work.

  When called interactively with a `\\[universal-argument]' prefix argument \
  GOTO, don't
  capture anything, just go to the file/headline where the selected
  template stores its notes.

  With a `\\[universal-argument] \\[universal-argument]' prefix argument, go to \
  the last note stored.

  When called with a `C-0' (zero) prefix, insert a template at point.

  When called with a `C-1' (one) prefix, force prompting for a date when
  a datetree entry is made.

  ELisp programs can set KEYS to a string associated with a template
  in `org-capture-templates'.  In this case, interactive selection
  will be bypassed.

  If `org-capture-use-agenda-date' is non-nil, capturing from the
  agenda will use the date at point as the default date.  Then, a
  `C-1' prefix will tell the capture process to use the HH:MM time
  of the day at point (if any) or the current HH:MM time."
    ;; (interactive "P")

    (when (and org-capture-use-agenda-date
               (eq major-mode 'org-agenda-mode))
      (setq org-overriding-default-time
            (org-get-cursor-date t ;; (equal goto 1)
                                 )))

    (let* ((orig-buf (current-buffer))
           (annotation (if (and (boundp 'org-capture-link-is-already-stored)
                                org-capture-link-is-already-stored)
                           (plist-get org-store-link-plist :annotation)
                           (ignore-errors (org-store-link nil))))
           ;; (template (or org-capture-entry (org-capture-select-template keys)))
           (template (or org-capture-entry template))
           initial)
      (setq initial (or org-capture-initial
                        (and (org-region-active-p)
                             (buffer-substring (point) (mark)))))
      (when (stringp initial)
        (remove-text-properties 0 (length initial) '(read-only t) initial))
      (when (stringp annotation)
        (remove-text-properties 0 (length annotation)
                                '(read-only t) annotation))



      ;; (org-capture-set-plist template)

      (setq org-capture-plist plist)
      (org-capture-put
       ;; :key (car entry)
       ;; :description (nth 1 entry)
       :target target)

      (let ((txt template)
            (type (or type 'entry)))
        (when (or (not txt) (and (stringp txt) (not (string-match "\\S-" txt))))
          ;; The template may be empty or omitted for special types.
          ;; Here we insert the default templates for such cases.
          (cond
            ((eq type 'item) (setq txt "- %?"))
            ((eq type 'checkitem) (setq txt "- [ ] %?"))
            ((eq type 'table-line) (setq txt "| %? |"))
            ((member type '(nil entry)) (setq txt "* %?\n  %a"))))
        (org-capture-put :template txt :type type))

      (org-capture-get-template)

      (org-capture-put :original-buffer orig-buf
                       :original-file (or (buffer-file-name orig-buf)
                                          (and (featurep 'dired)
                                               (car (rassq orig-buf
                                                           dired-buffers))))
                       :original-file-nondirectory
                       (and (buffer-file-name orig-buf)
                            (file-name-nondirectory
                             (buffer-file-name orig-buf)))
                       :annotation annotation
                       :initial initial
                       :return-to-wconf (current-window-configuration)
                       :default-time
                       (or org-overriding-default-time
                           (org-current-time)))

      (org-capture-set-target-location-improved)

      (condition-case error
          (org-capture-put :template (org-capture-fill-template))
        ((error quit)
         (if (get-buffer "*Capture*") (kill-buffer "*Capture*"))
         (error "Capture abort: %s" error)))

      (setq org-capture-clock-keep (org-capture-get :clock-keep))
      (if (and
           (not (org-capture-get :target))
           (eq 'immdediate (car (org-capture-get :target)))) ;; (equal goto 0)
          ;;insert at point
          (org-capture-insert-template-here)
          (condition-case error
              (org-capture-place-template
               (eq (car (org-capture-get :target)) 'function))
            ((error quit)
             (if (and (buffer-base-buffer (current-buffer))
                      (string-prefix-p "CAPTURE-" (buffer-name)))
                 (kill-buffer (current-buffer)))
             (set-window-configuration (org-capture-get :return-to-wconf))
             (error "Capture template `%s': %s"
                    (org-capture-get :key)
                    (nth 1 error))))
          (if (and (derived-mode-p 'org-mode)
                   (org-capture-get :clock-in))
              (condition-case nil
                  (progn
                    (if (org-clock-is-active)
                        (org-capture-put :interrupted-clock
                                         (copy-marker org-clock-marker)))
                    (org-clock-in)
                    (setq-local org-capture-clock-was-started t))
                (error
                 "Could not start the clock in this capture buffer")))
          (if (org-capture-get :immediate-finish)
              (org-capture-finalize)))))

(defalias 'org-capture+ 'org-capture-alt)
;; new capture:1 ends here

;; Application

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-capture+/org-capture+.org::*Application][Application:1]]
(defun org-goto-refile (&optional refile-targets)
  "Refile goto."
  ;; mark paragraph if no region is set
  (let* ((org-refile-targets (or refile-targets org-refile-targets))
         (target (save-excursion (safe-org-refile-get-location)))
         (file (nth 1 target))
         (pos (nth 3 target)))
    (when (set-buffer (find-file-noselect file)) ;; (switch-to-buffer (find-file-noselect file) 'norecord)
      (goto-char pos))))

  (defun org-create-new-task ()
    (interactive)
    (org-capture-alt
     'entry
     '(function org-goto-refile)
     "* TODO %? %^g\n %i\n [%a]\n"
     :empty-lines 1))

(when nil
(let (helm-sources)
    ;; (when (marker-buffer org-clock-default-task)
    ;;   (push
    ;;    (helm-build-sync-source "Default Task"
    ;;     :candidates (list (lotus-org-marker-selection-line org-clock-default-task))
    ;;     :action (list ;; (cons "Select" 'identity)
    ;;              (cons "Clock in and track" #'identity)))
    ;;    helm-sources))

    ;; (when (marker-buffer org-clock-interrupted-task)
    ;;   (push
    ;;    (helm-build-sync-source "The task interrupted by starting the last one"
    ;;      :candidates (list (lotus-org-marker-selection-line org-clock-interrupted-task))
    ;;      :action (list ;; (cons "Select" 'identity)
    ;;               (cons "Clock in and track" #'identity)))
    ;;    helm-sources))

    (when (and
           (org-clocking-p)
           (marker-buffer org-clock-marker))
      (push
       (helm-build-sync-source "Current Clocking Task"
         :candidates (list (lotus-org-marker-selection-line org-clock-marker))
         :action (list ;; (cons "Select" 'identity)
                  (cons "Clock in and track" #'identity)))
       helm-sources))

    ;; (when org-clock-history
    ;;   (push
    ;;    (helm-build-sync-source "Recent Tasks"
    ;;      :candidates (mapcar 'sacha-org-context-clock-dyntaskpl-selection-line dyntaskpls)
    ;;      :action (list ;; (cons "Select" 'identity)
    ;;               (cons "Clock in and track" #'(lambda (dyntaskpl) (plist-get dyntaskpl ))))
    ;;    helm-sources)))

    (helm
     helm-sources)))
;; Application:1 ends here

;; Preamble

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-capture+/org-capture+.org::*Preamble][Preamble:1]]
;;; org-capture+.el --- org capture plus

;; Copyright (C) 2012  Sharad Pratap

;; Author: Sharad Pratap <>
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;; Code:
;; Preamble:1 ends here

;; Overriding org-capture-place-template function


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-capture+/org-capture+.org::*Overriding%20org-capture-place-template%20function][Overriding org-capture-place-template function:1]]
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
    (`table-line      (org-capture-place-table-line))
    (`plain           (org-capture-place-plain-text))
    (`item            (org-capture-place-item))
    (`checkitem       (org-capture-place-item))
    (`log-note        (org-capture-place-log-note)))
  (org-capture-mode 1)
  (setq-local org-capture-current-plist org-capture-plist))
;; Overriding org-capture-place-template function:1 ends here

;; Providing log note function for capture


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-capture+/org-capture+.org::*Providing%20log%20note%20function%20for%20capture][Providing log note function for capture:1]]
(defun org-capture-place-log-note ()
  "Place the template plainly.
If the target locator points at an Org node, place the template into
the text of the entry, before the first child.  If not, place the
template at the beginning or end of the file.
Of course, if exact position has been required, just put it there."
  (let* ((txt (org-capture-get :template))
         beg end
         (note-purpose (or note-purpose 'note))
    ;; (cond
    ;;   ((org-capture-get :exact-position)
    ;;    (goto-char (org-capture-get :exact-position)))
    ;;   ((and (org-capture-get :target-entry-p)
    ;;         (bolp)
    ;;         (looking-at org-outline-regexp))
    ;;    ;; we should place the text into this entry
    ;;    (if (org-capture-get :prepend)
    ;;        ;; Skip meta data and drawers
    ;;        (org-end-of-meta-data t)
    ;;        ;; go to ent of the entry text, before the next headline
    ;;        (outline-next-heading)))
    ;;   (t
    ;;    ;; beginning or end of file
    ;;    (goto-char (if (org-capture-get :prepend) (point-min) (point-max)))))

    (if (and (org-capture-get :target-entry-p)
             (bolp)
             (looking-at org-outline-regexp))
        (let ((note (cdr (assq note-purpose org-log-note-headings)))
              lines)
          (progn
            (while (string-match "\\`# .*\n[ \t\n]*" txt)
              (setq txt (replace-match "" t t txt)))
            (when (string-match "\\s-+\\'" txt)
              (setq txt (replace-match "" t t txt)))
            (setq lines (org-split-string txt "\n"))
            (when (org-string-nw-p note)
              (setq note
                    (org-replace-escapes
                     note
                     (list (cons "%u" (user-login-name))
                           (cons "%U" user-full-name)
                           (cons "%t" (format-time-string
                                       (org-time-stamp-format 'long 'inactive)
                                       effective-time))
                           (cons "%T" (format-time-string
                                       (org-time-stamp-format 'long nil)
                                       effective-time))
                           (cons "%d" (format-time-string
                                       (org-time-stamp-format nil 'inactive)
                                       effective-time))
                           (cons "%D" (format-time-string
                                       (org-time-stamp-format nil nil)
                                       effective-time))
                           (cons "%s" (cond
                                        ((not note-state) "")
                                        ((string-match-p org-ts-regexp note-state)
                                         (format "\"[%s]\""
                                                 (substring note-state 1 -1)))
                                        (t (format "\"%s\"" note-state))))
                           (cons "%S"
                                 (cond
                                   ((not note-previous-state) "")
                                   ((string-match-p org-ts-regexp
                                                    note-previous-state)
                                    (format "\"[%s]\""
                                            (substring
                                             note-previous-state 1 -1)))
                                   (t (format "\"%s\""
                                              note-previous-state)))))))
              (when lines (setq note (concat note " \\\\")))
              (push note lines)))

          ;; Note associated to a clock is to be located right after
          ;; the clock.  Do not move point.
          (unless (eq note-purpose 'clock-out)
            (goto-char (org-log-beginning t)))
          ;; Make sure point is at the beginning of an empty line.
          (cond ((not (bolp)) (let ((inhibit-read-only t)) (insert "\n")))
                ((looking-at "[ \t]*\\S-") (save-excursion (insert "\n"))))
          ;; In an existing list, add a new item at the top level.
          ;; Otherwise, indent line like a regular one.
          (let ((itemp (org-in-item-p)))
            (if itemp
                (indent-line-to
                 (let ((struct (save-excursion
                                 (goto-char itemp) (org-list-struct))))
                   (org-list-get-ind (org-list-get-top-point struct) struct)))
                (org-indent-line)))

          ;; (or (bolp) (newline))
          ;; (org-capture-empty-lines-before)
          (setq beg (point))
          (insert (org-list-bullet-string "-") (pop lines))
          (let ((ind (org-list-item-body-column (line-beginning-position))))
            (dolist (line lines)
              (insert "\n")
              (indent-line-to ind)
              (insert line)))
          ;; (message "Note stored")
          ;; (org-capture-empty-lines-after)
          (org-capture-position-for-last-stored beg)
          (setq end (point))
          (org-capture-mark-kill-region beg (1- end))
          (org-capture-narrow beg (1- end))
          (if (or (re-search-backward "%\\?" beg t)
                  (re-search-forward "%\\?" end t))
              (replace-match ""))
          (org-back-to-heading t)
          (org-cycle-hide-drawers 'children))))))
;; Providing log note function for capture:1 ends here

;; Provide this file

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-capture+/org-capture+.org::*Provide%20this%20file][Provide this file:1]]
(provide 'org-capture+)
;;; org-capture+.el ends here
;; Provide this file:1 ends here
