;;; org-context-clock-assoc-api.el --- org-context-clock               -*- lexical-binding: t; -*-

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


(progn ;; REGISTRATION MACRO To add key property and functions list to ORG-CONTEXT-CLOCKING-TASK-ASSOCIATED-FILE-KEY-FNS
  (setq org-context-clock-task-associated-context-key-fns nil)
  (message "NOTE: org-context-clock-task-associated-context-key-fns made to nil")

  (progn ;; macros and accessor

    (defun org-context-clock-tasks-register-associated-to-context-key-function (key fn)
      (setq
       org-context-clock-task-associated-context-key-fns
       (plist-put
        org-context-clock-task-associated-context-key-fns key fn)))

    (eval-when-compile                  ;; TODO: auto generate name from KEY
      (defmacro defassoc-context-key (name key args &rest body)
        "Registration macro to add key property and functions list to ORG-TASK-ASSOCIATED-FILE-KEY-FNS"
        `(progn
           (defun ,name ,args
             ,@body)
           (org-context-clock-tasks-register-associated-to-context-key-function ,key ',name))))

    (put 'defassoc-context-key 'lisp-indent-function 3)
    (defun org-context-clock-tasks-associated-key-function (key)
      (plist-get org-context-clock-task-associated-context-key-fns key))
    (defun org-context-clock-tasks-associated-key-fn-value (key task context)
      (let ((keyfn (org-context-clock-tasks-associated-key-function key)))
        (if keyfn
            (let ((rank (funcall keyfn task context)))
              (unless (numberp rank)
                (error "org-context-clock-tasks-associated-key-fn-value: fun %s returning nonnumeric %s for context %s for task %s"
                       keyfn
                       rank
                       context
                       (org-context-clock-task-get-heading task)))
              (org-context-clock-debug "org-context-clock-tasks-associated-key-fn-value: task %s key %s MATCHED %d rank"
                       (org-context-clock-task-get-heading task)
                       key
                       rank)
              rank)
            (progn
              (org-context-clock-debug "org-context-clock-tasks-associated-key-fn-value: task %s key %s kyfn is %s so how can match %d rank"
                       (org-context-clock-task-get-heading task)
                       key
                       keyfn
                       0)
              0)))))

  (defassoc-context-key org-task-associated-context-org-file-key :org-file (task context)
    "Predicate funtion to check if context matches to task's file attribute."
    (let ((org-file (org-context-clock-task-get-property task :task-clock-file)))
      (let* ((file (plist-get context :file))
             (file (if file (file-truename file))))
        (if (and file org-file
                 (string-equal
                  (file-truename file)
                  (file-truename org-file)))
            10
            0))))

  (defassoc-context-key org-task-associated-context-root-dir-key :root (task context)
    "Predicate funtion to check if context matches to task's file attribute."
    (let* ((root
            (org-context-clock-task-get-property task :ROOT))
           (root (if root (file-truename root))))
      (let* ((file (plist-get context :file))
             (file (if file (file-truename file))))
       (if root
           (progn
             (org-context-clock-debug "task %s root %s" (org-context-clock-task-get-heading task) root)
             (org-context-clock-debug "task %s file %s" (org-context-clock-task-get-heading task) file))
           (org-context-clock-debug "task %s root %s not present."
                                    (org-context-clock-task-get-heading task) root))
       (if (and root file
                (string-match root file))
           (length root)
           0))))

  (defassoc-context-key org-task-associated-context-status-key :status (task context)
    ;; task closed criteria
    "Predicate funtion to check if context matches to task's status attribute."
    (let* ((todo-type
            (org-context-clock-task-get-property task :todo-type))
           (closed
            (org-context-clock-task-get-property task :closed))
           (status
            (org-context-clock-task-get-property task :todo-keyword)))
      (if (or
           closed
           (eql todo-type 'done)
           (string-equal status "HOLD"))
          -30 0)))

  (defassoc-context-key org-task-associated-context-task-key :task-key (task context)
    "Predicate funtion to check if context matches to task's file attribute."
    (let* ((key (org-context-clock-task-get-property task :KEY)))
      (if key (string-to-number key) 0)))

  (defassoc-context-key org-task-associated-context-level-key :heading-level (task context)
    "Predicate funtion to check if context matches to task's file attribute."
    (let* ((level
            (org-context-clock-task-get-property task :task-clock-level)))
      (if level level 0)))

  (defassoc-context-key org-task-associated-context-timebeing-key :timebeing (task context)
    (let ((timebeing (org-context-clock-task-get-property task :TIMEBEING)))
      (let ((timebeing-time (if timebeing (org-duration-string-to-minutes timebeing) 0))
            (clocked-time   (org-context-clock-task-get-property task :task-clock-clock-sum)))
        (if (and
             (numberp clocked-time)
             (numberp timebeing-time)
             (> timebeing-time clocked-time))
            (- timebeing-time clocked-time)
            0))))

  ;; (defassoc-context-key org-task-associated-context-current-clock-key :current-clock (task context)
  ;;   "Predicate funtion to check if context matches to task's file attribute."
  ;;   (let* ((task-marker
  ;;           (org-context-clock-task-get-property task :task-clock-marker)))
  ;;     (if (and
  ;;          org-clock-marker
  ;;          task-marker
  ;;          (equal
  ;;           (marker-buffer org-clock-marker)
  ;;           (marker-buffer task-marker))
  ;;          (equal
  ;;           (marker-position org-clock-marker)
  ;;           (marker-position task-marker)))
  ;;         100
  ;;         0)))
  )

(provide 'org-context-clock-assoc-api)
;;; org-context-clock-assoc-api.el ends here
