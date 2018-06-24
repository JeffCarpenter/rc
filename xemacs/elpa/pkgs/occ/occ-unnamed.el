
;;; occ-unnamed.el --- occ-api               -*- lexical-binding: t; -*-
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

(require 'occ-object-methods)

(defvar *occ-unassociate-ctx-start-time* nil)
(defvar *occ-swapen-unnamed-threashold-interval* (* 60 2)) ;2 mins

(defun occ-unassociate-ctx-start-time-reset ()
  (setq *occ-unassociate-ctx-start-time* nil))

(defun occ-can-create-unnamed-tsk-p ()
  (unless *occ-unassociate-ctx-start-time*
    (setq *occ-unassociate-ctx-start-time* (current-time)))
  (let ((unassociate-ctx-start-time *occ-unassociate-ctx-start-time*))
    (prog1
        (>
         (float-time (time-since unassociate-ctx-start-time))
         *occ-swapen-unnamed-threashold-interval*))))

(defun occ-clock-marker-is-unnamed-clock-p (&optional clock)
  (let ((clock (or clock org-clock-marker)))
    (when (and
           clock
           (lotus-org-unnamed-task-clock-marker))
      (equal
       (marker-buffer org-clock-marker)
       ;; id:x11 make org-ctx-clock version
       (marker-buffer (lotus-org-unnamed-task-clock-marker))))))

(defun occ-maybe-create-clockedin-unnamed-heading ()
  (when (occ-can-create-unnamed-tsk-p)
    (let ((org-log-note-clock-out nil))
      (if (occ-clock-marker-is-unnamed-clock-p)
          (occ-debug :debug "occ-maybe-create-unnamed-tsk: Already clockin unnamed tsk")
        (prog1
            (lotus-org-create-unnamed-task-task-clock-in)
          (occ-unassociate-ctx-start-time-reset))))))

(defun occ-maybe-create-unnamed-heading ()
  (when (occ-can-create-unnamed-tsk-p)
    (let ((org-log-note-clock-out nil))
      (if (occ-clock-marker-is-unnamed-clock-p)
          (occ-debug :debug "occ-maybe-create-unnamed-tsk: Already clockin unnamed tsk")
        (cdr (lotus-org-create-unnamed-task))))))


(defun occ-maybe-create-unnamed-tsk ()
  ;; back
  (let* ((unnamed-heading-marker
          (cdr (lotus-org-create-unnamed-task)))
         (unnamed-tsk
          (when unnamed-heading-marker
            (occ-make-tsk unnamed-heading-marker (occ-tsk-builder)))))
    unnamed-tsk))

(cl-defmethod occ-maybe-create-unnamed-ctxual-tsk ((ctx occ-ctx))
  ;; back
  (let* ((unnamed-tsk
          (occ-maybe-create-unnamed-tsk))
         (unnamed-ctxual-tsk
          (when unnamed-tsk
            (occ-build-ctxual-tsk unnamed-tsk ctx))))
    unnamed-ctxual-tsk))

(cl-defmethod occ-maybe-create-clockedin-unnamed-ctxual-tsk ((ctx occ-ctx))
  ;; back
  (when (occ-can-create-unnamed-tsk-p)
    (let ((org-log-note-clock-out nil))
      (if (occ-clock-marker-is-unnamed-clock-p)
          (occ-debug :debug "occ-maybe-create-unnamed-tsk: Already clockin unnamed tsk")
        (let* ((unnamed-ctxual-tsk (occ-maybe-create-unnamed-ctxual-tsk ctx))
               (unnamed-tsk        (occ-ctxual-tsk-tsk unnamed-ctxual-tsk))
               (unnamed-marker     (occ-tsk-marker unnamed-tsk)))
          (prog1
              (occ-clockin unnamed-ctxual-tsk)
            ;; id:x11 make org-ctx-clock version
            (lotus-org-unnamed-task-clock-marker unnamed-marker)
            (message "clockin to unnnamed tsk.")
            (occ-unassociate-ctx-start-time-reset)))))))

(provide 'occ-unnamed)
;;; occ-unnamed.el ends here
