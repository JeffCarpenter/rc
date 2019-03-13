;;; occ-main.el --- occ-api               -*- lexical-binding: t; -*-
;; Copyright (C) 2016  sharad

;; Author: sharad <sh4r4d _at_ _G-mail_>
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

(provide 'occ-main)


(require 'timer-utils-lotus)
(eval-when-compile
  (require 'timer-utils-lotus))
(require 'org-misc-utils-lotus)
(eval-when-compile
  (require 'org-misc-utils-lotus))
(require 'lotus-misc-utils)
(eval-when-compile
  (require 'lotus-misc-utils))

(require 'occ-obj-method)
(require 'occ-util-common)
(require 'occ-unnamed)
(require 'occ-interactive)
(require 'occ-version)


(defcustom *occ-last-buff-sel-time*            (current-time) "*occ-last-buff-sel-time*")
(defvar    *occ-buff-sel-timer*                nil)
(defvar    *occ-tsk-current-ctx-time-interval* 7)
(defvar    *occ-tsk-previous-ctx*              nil)
(defvar    *occ-tsk-current-ctx*               nil)

(cl-defmethod occ-clock-in-if-not ((ctx occ-ctx))
  (if (or
       (occ-clock-marker-is-unnamed-clock-p)
       (>= 0 (occ-associated-p (occ-current-tsk) ctx)))

      (progn                ;current clock is not matching
        (occ-debug (if this-command :debug :warning) "occ-clock-in-if-not: Now really going to clock with this-command=%s" this-command)
        (unless (occ-clock-in ctx)

          ;; BUG Urgent TODO: SOLVE ASAP ???? at (occ-clock-in-if-not ctx) and (occ-clock-in ctx)

          ;; begin occ-clock-in-curr-ctx-if-not
          ;; 2019-03-06 22:55:31 s: occ-clock-in-curr-ctx-if-not: lotus-with-other-frame-event-debug
          ;; occ-clock-in-if-not: Now really going to clock.
          ;; in occ-clock-in occ-ctx 1
          ;; user input 111 retval t
          ;; trying to create unnamed tsk.
          ;; occ-maybe-create-unnamed-tsk: Already clockin unnamed tsk
          ;; occ-clock-in-if-not: Now really clock done.


          ;; not able to find associated, or intentionally not selecting a clock
          (occ-debug :debug "trying to create unnamed tsk.")
          (occ-maybe-create-clockedin-unnamed-ctxual-tsk ctx))
        (occ-debug :debug "occ-clock-in-if-not: Now really clock done.")
        t)

      (progn
        (occ-debug :debug "occ-clock-in-if-not: Current tsk already associate to %s" ctx)
        nil)))

(cl-defmethod occ-clock-in-if-chg ((ctx occ-ctx))
  (if (>
       (float-time (time-since *occ-last-buff-sel-time*))
       *occ-tsk-current-ctx-time-interval*)
      (let* ((buff    (occ-ctx-buffer ctx)))
        (setq *occ-tsk-current-ctx* ctx)
        (if (and
             (occ-chgable-p)
             buff (buffer-live-p buff)
             (not (minibufferp buff))
             (not (ignore-p buff))
             (not              ;BUG: Reconsider whether it is catching case after some delay.
              (equal *occ-tsk-previous-ctx* *occ-tsk-current-ctx*)))
            (progn
              (when (occ-clock-in-if-not ctx)
                (setq *occ-tsk-previous-ctx* *occ-tsk-current-ctx*)))
          (occ-debug :nodisplay "occ-clock-in-if-chg: ctx %s not suitable to associate" ctx)))
    (occ-debug :nodisplay "occ-clock-in-if-chg: not enough time passed.")))

;;;###autoload
(defun occ-clock-in-curr-ctx (&optional force)
  (interactive "P")
  (occ-clock-in-if-not (occ-make-ctx)))

;;;###autoload
(defun occ-clock-in-curr-ctx-if-not (&optional force)
  (interactive "P")
  ;; TODO: Add code to which check if only focus present than only trigger
  ;; else postpone it by calling run-with-idle-plus-timer
  (occ-debug :debug "begin occ-clock-in-curr-ctx-if-not")
  (lotus-with-other-frame-event-debug "occ-clock-in-curr-ctx-if-not" :cancel
    (occ-debug :debug "%s: occ-clock-in-curr-ctx-if-not: lotus-with-other-frame-event-debug" (time-stamp-string))
    (if force
        (occ-clock-in-curr-ctx (occ-make-ctx))
      (occ-clock-in-if-chg (occ-make-ctx))))
  (occ-debug :nodisplay "%s: end occ-clock-in-curr-ctx-if-not" (time-stamp-string)))

;;;###autoload
(defun occ-run-curr-ctx-timer ()
  (interactive)
  (progn
    (setq *occ-last-buff-sel-time* (current-time))
    (when *occ-buff-sel-timer*
      (cancel-timer *occ-buff-sel-timer*)
      (setq *occ-buff-sel-timer* nil))
    (setq *occ-buff-sel-timer*
          ;; distrubing while editing.
          ;; run-with-timer
          (run-with-idle-timer
           (1+ *occ-tsk-current-ctx-time-interval*)
           nil
           'occ-clock-in-curr-ctx-if-not))))

;;;###autoload
(defun occ-after-save-hook-fun ()
  (let ((file (buffer-file-name)))
    (when (and
           file
           (eq major-mode 'org-mode))
      (if (member*
             file
             (occ-files)
             :test #'(lambda (f1 f2)
                       (string-equal
                        (file-truename f1)
                        (file-truename f2))))
          ;; TODO workaround do complete nil, later change it to optimized.
          ;; TODO update existing occ-collection.tree or occ-collection.list
          (occ-reset-global-tsk-collection)
        (occ-debug :debug "file %s not resetting global-tsk-collection" file)))))

;;; occ-main.el ends here
