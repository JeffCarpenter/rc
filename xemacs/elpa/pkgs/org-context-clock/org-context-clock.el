;;; org-context-clock.el --- org-context-clock               -*- lexical-binding: t; -*-

;; Copyright (C) 2016  sharad

;; Author: sharad <spratap@merunetworks.com>
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

;;

;;; Code:

(defgroup org-context-clock nil
  "Emacs Org Context Clocking."
  :tag "Org Clock"
  :group 'org-progress)


(require 'org-clock)

(require 'timer-utils-lotus)
(eval-when-compile
  (require 'timer-utils-lotus))
(require 'org-misc-utils-lotus)
(eval-when-compile
  (require 'org-misc-utils-lotus))
(require 'lotus-misc-utils)
(eval-when-compile
  (require 'lotus-misc-utils))

(require 'org-context-clock-api)



(defvar *org-context-clock-task-current-context*  nil)
(defvar *org-context-clock-task-previous-context* nil)
(defvar *org-context-clock-task-current-context-time* 2)
(defvar *org-context-clock-last-buffer-select-time* (current-time))
(defvar *org-context-clock-buffer-select-timer* nil)
(defvar *org-context-clock-update-current-context-msg* "")
;; (defvar org-context-clock-api-name :predicate "API")
(defvar org-context-clock-access-api-name :recursive "Aceess API")
(defvar org-context-clock-assoc-api-name :keys "Assoc API")
(defvar org-context-clock-api-tasks-associated-to-context     (org-context-clock-access-api-get org-context-clock-access-api-name :tasks))
(defvar org-context-clock-api-task-associated-to-context-p    (org-context-clock-assoc-api-get org-context-clock-assoc-api-name :taskp))
(defvar org-context-clock-api-task-update-tasks               (org-context-clock-access-api-get org-context-clock-access-api-name :update))
(defvar org-context-clock-api-task-update-files               (org-context-clock-access-api-get org-context-clock-access-api-name :files))


(defun custom-plist-keys (in-plist)
  (if (null in-plist)
      in-plist
      (cons (car in-plist) (custom-plist-keys (cddr in-plist)))))

;;;###autoload
(defun org-context-clock-api ()
  "org task clocking select api to use."
  (interactive)
  (let* ((assoc-api-keys (custom-plist-keys org-context-clock-task-clocking-assoc-api))
         (assoc-api-name (ido-completing-read
                          "org task clocking api name: "
                          (mapcar 'symbol-name assoc-api-keys)
                          nil
                          t
                          (symbol-name org-context-clock-assoc-api-name)))
         (assoc-api-key (intern assoc-api-name))

         (access-api-keys (custom-plist-keys org-context-clock-task-clocking-access-api))
         (access-api-name (ido-completing-read
                          "org task clocking api name: "
                          (mapcar 'symbol-name access-api-keys)
                          nil
                          t
                          (symbol-name org-context-clock-access-api-name)))
         (access-api-key (intern access-api-name)))
    (setq
     org-context-clock-assoc-api-name assoc-api-key
     org-context-clock-access-api-name access-api-key)
    (if (and
         (org-context-clock-access-api-get org-context-clock-access-api-name :tasks)
         (org-context-clock-assoc-api-get org-context-clock-assoc-api-name :taskp)
         (org-context-clock-access-api-get org-context-clock-access-api-name :update))
        (setq
         org-context-clock-api-tasks-associated-to-context   (org-context-clock-access-api-get org-context-clock-access-api-name :tasks)
         org-context-clock-api-task-associated-to-context-p  (org-context-clock-assoc-api-get org-context-clock-assoc-api-name :taskp)
         org-context-clock-api-task-update-tasks             (org-context-clock-access-api-get org-context-clock-access-api-name :update)))))

;;;###autoload
(defun org-context-clock-task-update-tasks (&optional force)
  "Update task infos"
  (interactive "P")
  (funcall org-context-clock-api-task-update-tasks force))

;;;###autoload
(defun org-context-clock-task-update-files (&optional force)
  "Update task infos"
  (interactive "P")
  (funcall org-context-clock-api-task-update-files force))

(defun org-context-clock-build-context (&optional buff)
  (let* ((buff (if buff
                   (if (bufferp buff)
                       buff
                       (if (stringp buff)
                           (or
                            (get-buffer buff)
                            (if (file-exists-p buff)
                                (get-file-buffer buff)))))
                   (window-buffer)))
         (file (buffer-file-name buff))
         (context (list :file file :buffer buff)))
    context))

(defvar *org-context-clock-unassociate-context-start-time* (current-time))
(defvar *org-context-clock-swapen-unnamed-threashold-interval* (* 60 2)) ;2 mins
(defun org-context-clock-can-create-unnamed-task-p ()
  (let ((unassociate-context-start-time *org-context-clock-unassociate-context-start-time*))
    (prog1
        (>
         (float-time (time-since unassociate-context-start-time))
         *org-context-clock-swapen-unnamed-threashold-interval*)
      (setq *org-context-clock-unassociate-context-start-time* (current-time)))))

(defun org-context-clock-changable-p ()
  (if org-clock-start-time
      (let ((clock-duration
             (if (and
                  (stringp org-clock-start-time)
                  (string-equal "" org-clock-start-time))
                 0
                 (float-time (time-since org-clock-start-time)))))
        (or
         (< clock-duration 60)
         (> clock-duration 120)))
      t))

(defun org-context-clock-maybe-create-unnamed-task ()
    (when (org-context-clock-can-create-unnamed-task-p)
      (let ((org-log-note-clock-out nil))
        (lotus-org-create-unnamed-task-task-clock-in))))

;;;###autoload
(defun org-context-clock-update-current-context ()
  (if (> (float-time (time-since *org-context-clock-last-buffer-select-time*))
         *org-context-clock-task-current-context-time*)
      (let* ((context (org-context-clock-build-context))
             (buff          (plist-get context :buffer)))
        (setq *org-context-clock-task-current-context*  context)
        (if (and
             (org-context-clock-changable-p)
             buff (buffer-live-p buff)
             (not (minibufferp buff))
             (not              ;BUG: Reconsider whether it is catching case after some delay.
              (equal *org-context-clock-task-previous-context* *org-context-clock-task-current-context*)))

            (progn
              (setq
               *org-context-clock-task-previous-context* *org-context-clock-task-current-context*)

              (if (> (org-context-clock-current-task-associated-to-context-p context) 0)
                  (org-context-clock-debug :debug "org-context-clock-update-current-context: Current task already associate to %s" context)

                  (progn                ;current clock is not matching
                    (org-context-clock-debug :debug "org-context-clock-update-current-context: Now really going to clock.")
                    (unless (org-context-clock-task-run-associated-clock context)
                      ;; not able to find associated, or intentionally not selecting a clock
                      (org-context-clock-maybe-create-unnamed-task))
                    (org-context-clock-debug :debug "org-context-clock-update-current-context: Now really clock done."))))

            (org-context-clock-debug :debug "org-context-clock-update-current-context: context %s not suitable to associate" context)))
      (org-context-clock-debug :debug "org-context-clock-update-current-context: not enough time passed.")))


(defun org-context-clock-update-current-context-x ()
  (if t
      (let* ((context (org-context-clock-build-context)))
        (unless nil
          (setq
           *org-context-clock-task-previous-context* *org-context-clock-task-current-context*
           *org-context-clock-task-current-context*  context)

          (unless (org-context-clock-current-task-associated-to-context-p context)
            (unless (org-context-clock-task-run-associated-clock context)
              ;; not able to find associated, or intentionally not selecting a clock
              (org-context-clock-maybe-create-unnamed-task)))))))

;;;###autoload
(defun org-context-clock-task-current-task ()
  (and
   ;; file
   org-clock-marker
   (> (marker-position-nonil org-clock-marker) 0)
   (org-with-clock-position (list org-clock-marker)
     (org-previous-visible-heading 1)
     (let ((info (org-context-clock-collect-task)))
       info))))

;; not workiong
;; (defun org-context-clock-current-task-associated-to-context-p (context)
;;   (and
;;    ;; file
;;    org-clock-marker
;;    (> (marker-position-nonil org-clock-marker) 0)
;;    (org-with-clock-position (list org-clock-marker)
;;      (org-previous-visible-heading 1)
;;      (let ((info (org-context-clock-collect-task)))
;;        (if (funcall org-context-clock-api-task-associated-to-context-p info context)
;;            info)))))

(defun org-context-clock-task-associated-to-context-p (task context)
  (if task
      (funcall org-context-clock-api-task-associated-to-context-p task context)
      0))

;;;###autoload
(defun org-context-clock-current-task-associated-to-context-p (context)
  (let ((task (org-context-clock-task-current-task)))
    (org-context-clock-task-associated-to-context-p task context)))

(defun org-context-clock-clockin-marker (selected-marker)
  (message "org-context-clock-clockin-marker %s" selected-marker)
  (let ((org-log-note-clock-out nil)
        (prev-org-clock-buff (marker-buffer org-clock-marker)))
    (message "clocking in %s" selected-marker)
    (let ((prev-clock-buff-read-only
           (if prev-org-clock-buff
               (with-current-buffer (marker-buffer org-clock-marker)
                 buffer-read-only))))

      (if prev-org-clock-buff
          (with-current-buffer prev-org-clock-buff
            (setq buffer-read-only nil)))

      (setq *org-context-clock-update-current-context-msg* org-clock-marker)

      (with-current-buffer (marker-buffer selected-marker)
        (let ((buffer-read-only nil))
          (org-clock-clock-in (list selected-marker))))

      (if prev-org-clock-buff
          (with-current-buffer prev-org-clock-buff
            (setq buffer-read-only prev-clock-buff-read-only))))))

;;;###autoload
(defun org-context-clock-task-run-associated-clock (context)
  (interactive
   (list (org-context-clock-build-context)))
  (let ()
    (let* ((matched-clocks
            (remove-if-not
             #'(lambda (marker) (marker-buffer marker))
             (org-context-clock-markers-associated-to-context context)))
           (selected-clock ))
      (if matched-clocks
          (condition-case e
              (if (> (length matched-clocks) 1)
                  (sacha/helm-org-refile-read-location matched-clocks #'org-context-clock-clockin-marker)
                  ;; (if nil
                  ;;     (org-context-clock-clockin-marker (org-context-clock-select-task-from-clocks matched-clocks))
                  ;;     (sacha/helm-org-refile-read-location matched-clocks #'org-context-clock-clockin-marker))
                  (org-context-clock-clockin-marker (car matched-clocks))
                  t)
              (quit nil))
          (progn
            (setq *org-context-clock-update-current-context-msg* "null clock")
            (org-context-clock-message 6
             "No clock found please set a match for this context %s, add it using M-x org-context-clock-add-context-to-org-heading."
             context)
            (when t ; [renabled] ;disabling to check why current-idle-time no working properly.
              (org-context-clock-add-context-to-org-heading-when-idle context 17)
              nil))))))

;;;###autoload
(defun org-context-clock-run-task-current-context-timer ()
  (interactive)
  (let ()
    (setq *org-context-clock-last-buffer-select-time* (current-time))
    (when *org-context-clock-buffer-select-timer*
      (cancel-timer *org-context-clock-buffer-select-timer*)
      (setq *org-context-clock-buffer-select-timer* nil))
    (setq *org-context-clock-buffer-select-timer*
          ;; distrubing while editing.
          ;; (run-with-timer
          (run-with-idle-timer
           (1+ *org-context-clock-task-current-context-time*)
           nil
           'org-context-clock-update-current-context))))

(defun org-context-clock-insert-selection-line (i marker)
  "Insert a line for the clock selection menu.
And return a cons cell with the selection character integer and the marker
pointing to it."
  (when (marker-buffer marker)
    (let (cat task heading prefix)
      (with-current-buffer (org-base-buffer (marker-buffer marker))
        (org-with-wide-buffer
         (ignore-errors
           (goto-char marker)
           (setq cat (org-get-category)
                 heading (org-get-heading 'notags)
                 prefix (save-excursion
                          (org-back-to-heading t)
                          (looking-at org-outline-regexp)
                          (match-string 0))
                 task (substring
                       (org-fontify-like-in-org-mode
                        (concat prefix heading)
                        org-odd-levels-only)
                       (length prefix))))))
      (when (and cat task)
        (insert (format "[%c] %-12s  %s\n" i cat task))
        (cons i marker)))))

;;;###autoload
(defun org-context-clock-select-task-from-clocks (clocks &optional prompt)
  "Select a task that was recently associated with clocking."
  (interactive)
  (let (och chl sel-list rpl (i 0) s)
    ;; Remove successive dups from the clock history to consider
    (mapc (lambda (c) (if (not (equal c (car och))) (push c och)))
          clocks)
    (setq och (reverse och) chl (length och))
    (if (zerop chl)
        (user-error "No matched org heading")
        (save-window-excursion
          (org-switch-to-buffer-other-window
           (get-buffer-create "*Clock Task Select*"))
          (erase-buffer)
          (insert (org-add-props "Tasks matched to current context\n" nil 'face 'bold))
          (mapc
           (lambda (m)
             (when (marker-buffer m)
               (setq i (1+ i)
                     s (org-context-clock-insert-selection-line
                        (if (< i 10)
                            (+ i ?0)
                            (+ i (- ?A 10))) m))
               (if (fboundp 'int-to-char) (setf (car s) (int-to-char (car s))))
               (push s sel-list)))
           och)
          (run-hooks 'org-clock-before-select-task-hook)
          (goto-char (point-min))
          ;; Set min-height relatively to circumvent a possible but in
          ;; `fit-window-to-buffer'
          (fit-window-to-buffer nil nil (if (< chl 10) chl (+ 5 chl)))
          (message (or prompt "Select task for clocking:"))
          (setq cursor-type nil rpl (read-char-exclusive))
          (kill-buffer)
          (cond
            ((eq rpl ?q) nil)
            ((eq rpl ?x) nil)
            ((assoc rpl sel-list) (cdr (assoc rpl sel-list)))
            (t (user-error "Invalid task choice %c" rpl)))))))


(defun sacha-org-context-clock-selection-line (marker)
  "Insert a line for the clock selection menu.
And return a cons cell with the selection character integer and the marker
pointing to it."
  (when (marker-buffer marker)
    (let (cat task heading prefix)
      (with-current-buffer (org-base-buffer (marker-buffer marker))
        (org-with-wide-buffer
         (ignore-errors
           (goto-char marker)
           (setq cat (org-get-category)
                 heading (org-get-heading 'notags)
                 prefix (save-excursion
                          (org-back-to-heading t)
                          (looking-at org-outline-regexp)
                          (match-string 0))
                 task (substring
                       (org-fontify-like-in-org-mode
                        (concat prefix heading)
                        org-odd-levels-only)
                       (length prefix))))))
      (when (and cat task)
        ;; (insert (format "[%c] %-12s  %s\n" i cat task))
        ;; marker
        (cons task marker)))))

(defun sacha/helm-org-refile-read-location (clocks clockin-fn)
  (message "sacha marker %s" (car clocks))
  ;; (setq sacha/helm-org-refile-locations tbl)
  (progn
    (helm
     (list
      (helm-build-sync-source "Select matching clock"
        :candidates (mapcar 'sacha-org-context-clock-selection-line clocks)
        :action (list ;; (cons "Select" 'identity)
                      (cons "Clock in and track" #'(lambda (c) (funcall clockin-fn c))))
        :history 'org-refile-history)
      ;; (helm-build-dummy-source "Create task"
      ;;   :action (helm-make-actions
      ;;            "Create task"
      ;;            'sacha/helm-org-create-task))
      ))))
;; org-context-clock-task-run-associated-clock

;; (sacha/helm-org-refile-read-location (org-context-clock-markers-associated-to-context (org-context-clock-build-context)))
;; (sacha/helm-org-refile-read-location (org-context-clock-markers-associated-to-context (org-context-clock-build-context (find-file-noselect "~/.xemacs/elpa/pkgs/org-context-clock/org-context-clock.el"))))

;;;###autoload
(defun org-context-clock-insinuate ()
  (interactive)
  (progn
    (add-hook 'buffer-list-update-hook     'org-context-clock-run-task-current-context-timer)
    (add-hook 'elscreen-screen-update-hook 'org-context-clock-run-task-current-context-timer)
    (add-hook 'elscreen-goto-hook          'org-context-clock-run-task-current-context-timer))

  (dolist (prop (org-context-clock-keys-with-operation :getter))
    (let ((propstr
           (upcase (if (keywordp prop) (substring (symbol-name prop) 1) (symbol-name prop)))))
      (unless (member propstr org-use-property-inheritance)
        (push propstr org-use-property-inheritance)))))

;;;###autoload
(defun org-context-clock-uninsinuate ()
  (interactive)
  (progn
    (remove-hook 'buffer-list-update-hook 'org-context-clock-run-task-current-context-timer)
    ;; (setq buffer-list-update-hook nil)
    (remove-hook 'elscreen-screen-update-hook 'org-context-clock-run-task-current-context-timer)
    (remove-hook 'elscreen-goto-hook 'org-context-clock-run-task-current-context-timer))

  (dolist (prop (org-context-clock-keys-with-operation :getter))
    (let ((propstr
           (upcase (if (keywordp prop) (substring (symbol-name prop) 1) (symbol-name prop)))))
      (unless (member propstr org-use-property-inheritance)
        (delete propstr org-use-property-inheritance)))))


(progn ;; "Org task clock reporting"
  ;; #+BEGIN: task-clock-report-with-comment :parameter1 value1 :parameter2 value2 ...
  ;; #+END:
  (defun org-dblock-write:task-clock-report-with-comment (params)
    (let ((fmt (or (plist-get params :format) "%d. %m. %Y")))
      (insert "Last block update at: "
              (format-time-string fmt))))

  (progn ;; "time sheet"
    ))








(when nil                               ;testing

  (org-context-clock-task-run-associated-clock (org-context-clock-build-context))

  (org-context-clock-task-run-associated-clock
   (org-context-clock-build-context (find-file-noselect "~/Documents/CreatedContent/contents/org/tasks/meru/report.org")))

  (org-context-clock-markers-associated-to-context
   (org-context-clock-build-context (find-file-noselect "~/Documents/CreatedContent/contents/org/tasks/meru/report.org")))

  (org-context-clock-current-task-associated-to-context-p
   (org-context-clock-build-context (find-file-noselect "~/Documents/CreatedContent/contents/org/tasks/meru/report.org")))

  (org-context-clock-markers-associated-to-context (org-context-clock-build-context))

  (org-context-clock-current-task-associated-to-context-p (org-context-clock-build-context))

  ;; sharad
  (setq test-info-task
        (let ((xcontext
               (list
                :file (buffer-file-name)
                :buffer (current-buffer))))
          (org-with-clock-position (list org-clock-marker)
            (org-previous-visible-heading 1)
            (let ((info (org-context-clock-collect-task)))
              (if (funcall org-context-clock-api-task-associated-to-context-p info xcontext)
                  info)))))

  (funcall org-context-clock-api-task-associated-to-context-p
           (org-context-clock-task-current-task)
           (org-context-clock-build-context))




  ;; (test-info-task)

  (funcall org-context-clock-api-task-associated-to-context-p
           test-info-task
           (org-context-clock-build-context))

  ;; org-clock-marker
  (org-tasks-associated-key-fn-value
   :current-clock test-info-task
   (org-context-clock-build-context) )

  (org-context-clock-current-task-associated-to-context-p
   (org-context-clock-build-context (find-file-noselect "~/Documents/CreatedContent/contents/org/tasks/meru/report.org")))

  (org-context-clock-current-task-associated-to-context-p
   (org-context-clock-build-context (find-file-noselect "~/Documents/CreatedContent/contents/org/tasks/meru/features/patch-mgm/todo.org")))

  ;; (org-task-associated-context-org-context-p
  ;;  "~/Documents/CreatedContent/contents/org/tasks/meru/report.org"
  ;;  (cadr org-task-list-tasks)))


  (length
   (funcall org-context-clock-api-tasks-associated-to-context
            (org-context-clock-build-context)))

  (length
   (funcall org-context-clock-api-tasks-associated-to-context
            (org-context-clock-build-context (find-file-noselect "/home/s/paradise/releases/global/patch-upgrade/Makefile"))))

  (org-context-clock-markers-associated-to-context (org-context-clock-build-context))

  ;; test it
  (length
   (funcall org-context-clock-api-tasks-associated-to-context (org-context-clock-build-context)))

  (org-context-clock-task-get-property
   (car (funcall org-context-clock-api-tasks-associated-to-context (org-context-clock-build-context)))
   :task-clock-marker)

  (org-context-clock-clockin-marker
   (org-context-clock-task-get-property
    (car (funcall org-context-clock-api-tasks-associated-to-context (org-context-clock-build-context)))
    :task-clock-marker))

  (org-context-clock-task-associated-to-context-by-keys-p
   (car (funcall org-context-clock-api-tasks-associated-to-context (org-context-clock-build-context)))
   (org-context-clock-build-context))

  (length
   (funcall org-context-clock-api-tasks-associated-to-context
            (org-context-clock-build-context (find-file-noselect "~/Documents/CreatedContent/contents/org/tasks/meru/report.org"))))

  (length
   (org-context-clock-tasks-associated-to-context-by-keys
    (org-context-clock-build-context)))


  (length
   (org-context-clock-tasks-associated-to-context-by-keys
    (org-context-clock-build-context (find-file-noselect "/home/s/paradise/releases/global/patch-upgrade/Makefile"))))

  (org-context-clock-current-task-associated-to-context-p
   (org-context-clock-build-context (find-file-noselect "/home/s/paradise/releases/global/patch-upgrade/Makefile")))

  ;; (org-context-clock-task-associated-to-context-by-keys "/home/s/paradise/releases/global/patch-upgrade/Makefile")

  (if (org-context-clock-current-task-associated-to-context-p (org-context-clock-build-context))
      (message "current clock is with current context or file")))

(provide 'org-context-clock)
;;; org-context-clock.el ends here
