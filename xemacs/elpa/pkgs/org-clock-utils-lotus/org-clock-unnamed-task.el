;;; org-clock-unnamed-task.el --- org-context-clock-api               -*- lexical-binding: t; -*-

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


;;;{{{ Emacs tasks https://emacs.stackexchange.com/questions/29128/programmatically-setting-an-org-mode-heading
;; https://emacs.stackexchange.com/questions/21713/how-to-get-property-values-from-org-file-headers

;; BUG org-global-get-property and org-global-put-property are not defined.


(defvar *lotus-org-unnamed-task-file*        "~/Unnamed.org")
(defvar *lotus-org-unnamed-parent-task-name* "Unnamed tasks")
(defvar *lotus-org-unnamed-task-name-fmt*    "Unnamed task %d")
(defvar *lotus-org-unnamed-task-clock-marker* nil)

(defun lotus-org-get-incr-tasknum (&optional buffer)
  (with-current-buffer (or buffer (current-buffer))
    (let* ((tasknumstr (or (org-global-get-property "TASKNUM") "0"))
           (tasknum (string-to-number tasknumstr)))
      (org-global-put-property "TASKNUM" (number-to-string (1+ tasknum)))
      tasknum)))

(defun lotus-org-create-unnamed-task (&optional file task)
  (interactive
   (let ((file *lotus-org-unnamed-task-file*)
         (task *lotus-org-unnamed-parent-task-name*))
     (list file task)))

  (let ((file (or file *lotus-org-unnamed-task-file*))
        (task (or task *lotus-org-unnamed-parent-task-name*))
        (subtask (format *lotus-org-unnamed-task-name-fmt*
                         ;; (lotus-org-get-incr-tasknum (find-file-noselect file))
                         (1+ (org-with-file-headline file task (org-number-of-subheadings))))))
    (org-find-file-heading-marker file task t)
    (org-insert-subheadline-to-file-headline
     subtask
     file
     task
     t)
    subtask))

(defun lotus-org-create-unnamed-task-task-clock-in (&optional file parent-task)
  (interactive
   (let ((file *lotus-org-unnamed-task-file*)
         (parent-task *lotus-org-unnamed-parent-task-name*))
     (list file parent-task)))
  (let ((file (or file *lotus-org-unnamed-task-file*))
        (parent-task (or parent-task *lotus-org-unnamed-parent-task-name*)))
    (org-with-file-headline
        file
        (lotus-org-create-unnamed-task file parent-task)
      (org-entry-put nil "Effort" "10")
      (org-clock-in)
      (setq
       *lotus-org-unnamed-task-clock-marker*
       (mark-marker)))))

(when nil

  (lotus-org-create-unnamed-task
   *lotus-org-unnamed-task-file*
   *lotus-org-unnamed-parent-task-name*)

  (lotus-org-create-unnamed-task-task-clock-in
   *lotus-org-unnamed-task-file*
   *lotus-org-unnamed-parent-task-name*)

  )

(defun lotus-org-merge-unnamed-task-at-point ()
  (interactive)
  ;; Implement
  )

(defun org-clock-marker-is-unnamed-clock-p (&optional clock)
  (let ((clock (or clock org-clock-marker)))
    (and
     clock
     *lotus-org-unnamed-task-clock-marker*
     (equal
      (marker-buffer org-clock-marker)
      (marker-buffer *lotus-org-unnamed-task-clock-marker*)))))

(defun lotus-org-unnamed-task-at-point-p ()
  (save-restriction
    (save-excursion
      (org-back-to-heading t)
      (let ((element (org-element-at-point)))
        (if (and
             element
             (eq (car element) 'headline))
            (let (;; (begin (plist-get (cadr element) :begin))
                  ;; (level (plist-get (cadr element) :level))
                  (title (plist-get (cadr element) :title)))
              (string-match-p "Unnamed task [0-9]+" title)))))))

;; (lotus-org-create-unnamed-task "~/Unnamed.org" "Unnamed tasks")

(defun org-clock-make-child-task-and-clock-in ()
  ;; TODO
  "Implement"
  (interactive)
  (if org-clock-marker
      (org-with-narrow-to-marker org-clock-marker
       (org-insert-subheading-at-point
        (read-from-minibuffer "Subtask: "))
       (org-entry-put nil "Effort" "10")
       (org-clock-in))))

(defun lotus-org-clockin-last-time (min)
  )

(provide 'org-clock-unnamed-task)
;;; org-clock-unnamed-task.el ends here
