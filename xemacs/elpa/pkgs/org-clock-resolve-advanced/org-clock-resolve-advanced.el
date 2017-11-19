;;; org-clock-resolve-advanced.el ---

;; Copyright (C) 2012  Sharad Pratap

;; Author: Sharad Pratap <spratap@merunetworks.com>
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

(require 'org)
(require 'org-timer)
(require 'org-clock)
(require 'timer-utils-lotus)
(eval-when-compile
  (require 'org-misc-utils-lotus))


(defun org-clock-steel-time ()
  )


(defvar org-clock-clocking-in nil)
(defvar org-clock-resolving-clocks nil)
(defvar org-clock-resolving-clocks-due-to-idleness nil)

(defun org-clock-resolve-clock (clock   ;considered clock
                                clock-out-time ;nil will cancel clock, now is now
                                clock-in-time
                                &optional
                                  close-p
                                  restart-p
                                  fail-quietly)
  "Resolve `CLOCK' given the time `CLOCK-OUT-TIME', and the present.
`CLOCK' is a cons cell of the form (MARKER START-TIME)."
  (let ((org-clock-resolving-clocks t))
    (cond

      ((null clock-out-time)
       (org-clock-clock-cancel clock)
       (if (and restart-p (not org-clock-clocking-in))
           (org-clock-clock-in clock)))

      ((eq clock-out-time 'now)
       (if restart-p
           (error "RESTART-P is not valid here"))
       (if (or close-p org-clock-clocking-in)
           (org-clock-clock-out clock fail-quietly)
           (unless (org-is-active-clock clock)
             (org-clock-clock-in clock t))))

      ((not (time-less-p clock-out-time (current-time)))
       (error "CLOCK-OUT-TIME must refer to a time in the past"))

      (t
       (if restart-p
           (error "RESTART-P is not valid here"))

       (org-clock-clock-out clock fail-quietly clock-out-time)
       (unless org-clock-clocking-in
         (if close-p
             (setq org-clock-leftover-time (and (null clock-out-time)
                                                clock-out-time))
             (org-clock-clock-in clock nil clock-in-time)))))))

(defun org-clock-jump-to-current-clock (&optional effective-clock)
  (interactive)
  (let ((drawer (org-clock-into-drawer))
        (clock (or effective-clock (cons org-clock-marker
                                         org-clock-start-time))))
    (unless (marker-buffer (car clock))
      (error "No clock is currently running"))
    (org-with-clock clock (org-clock-goto))
    (with-current-buffer (marker-buffer (car clock))
      (goto-char (car clock))
      (when drawer
        (org-with-wide-buffer
         (let ((drawer-re (format "^[ \t]*:%s:[ \t]*$"
                                  (regexp-quote (if (stringp drawer) drawer "LOGBOOK"))))
               (beg (save-excursion (org-back-to-heading t) (point))))
           (catch 'exit
             (while (re-search-backward drawer-re beg t)
               (let ((element (org-element-at-point)))
                 (when (eq (org-element-type element) 'drawer)
                   (when (> (org-element-property :end element) (car clock))
                     (org-flag-drawer nil element))
                   (throw 'exit nil)))))))))))

(defun org-clock-resolve (clock
                          &optional
                            prompt-fn
                            last-valid  ;last active (not idle) time
                            fail-quietly)
  "Resolve an open Org clock.
An open clock was found, with `dangling' possibly being non-nil.
If this function was invoked with a prefix argument, non-dangling
open clocks are ignored.  The given clock requires some sort of
user intervention to resolve it, either because a clock was left
dangling or due to an idle timeout.  The clock resolution can
either be:

  (a) deleted, the user doesn't care about the clock
  (b) restarted from the current time (if no other clock is open)
  (c) closed, giving the clock X minutes
  (d) closed and then restarted
  (e) resumed, as if the user had never left

The format of clock is (CONS MARKER START-TIME), where MARKER
identifies the buffer and position the clock is open at (and
thus, the heading it's under), and START-TIME is when the clock
was started."
  (cl-assert clock)
  (let* ((ch
          (save-window-excursion
            (save-excursion
              (unless org-clock-resolving-clocks-due-to-idleness
                (org-clock-jump-to-current-clock clock))
              (unless org-clock-resolve-expert
                (with-output-to-temp-buffer "*Org Clock*"
                  (princ (format-message "Select a Clock Resolution Command:

Remember that using shift will always leave you clocked out, no matter which option you choose.

i/q      Ignore this question; the same as keeping all the idle time.

k/K      Keep X minutes of the idle time (default is all).  If this
         amount is less than the default, you will be clocked out
         that many minutes after the time that idling began, and then
         clocked back in at the present time.

g/G      Indicate that you \"got back\" X minutes ago.  This is quite
         different from `k': it clocks you out from the beginning of
         the idle period and clock you back in X minutes ago.

s/S      Subtract the idle time from the current clock.  This is the
         same as keeping 0 minutes.

C        Cancel the open timer altogether.  It will be as though you
         never clocked in.

j/J      Jump to the current clock, to make manual adjustments.

For all these options, using uppercase makes your final state
to be CLOCKED OUT."))))
              (org-fit-window-to-buffer (get-buffer-window "*Org Clock*"))
              (let (char-pressed)
                (while (or (null char-pressed)
                           (and
                            (not (memq char-pressed
                                       '(?k ?K ?g ?G ?s ?S ?C
                                         ?j ?J ?i ?q)))
                            (or (ding) t)))
                  (setq char-pressed
                        (read-char (concat (funcall prompt-fn clock)
                                           " [jkKgGSscCiq]? ")
                                   nil 45)))
                (and (not (memq char-pressed '(?i ?q))) char-pressed)))))
         (default
          (floor (/ (float-time
                     (time-subtract (current-time) last-valid)) 60)))
         (keep
          (and (memq ch '(?k ?K))
               (read-number "Keep how many minutes? " default)))
         (gotback
          (and (memq ch '(?g ?G))
               (read-number "Got back how many minutes ago? " default)))
         (subtractp (memq ch '(?s ?S)))
         (barely-started-p (< (- (float-time last-valid)
                                 (float-time (cdr clock))) 45))
         (start-over-p (and subtractp barely-started-p))) ;bool
    (cond
      ((memq ch '(?j ?J))
       (if (eq ch ?J)
           (org-clock-resolve-clock
            clock                       ;clock
            'now                        ;resolve-to
            nil                         ;clock-out-time
            t                           ;close-p
            nil                         ;restart-p
            fail-quietly))
       (org-clock-jump-to-current-clock clock))

      ((or (null ch)
           (not (memq ch '(?k ?K ?g ?o ?G ?s ?S ?C ?O))))
       (message ""))

      (t
       (org-clock-resolve-clock
        clock                           ;clock
        (cond                           ;check-out (nil t last-valid now time)
                ((or (eq ch ?C)         ;cancel
                     ;; If the time on the clock was less than a minute before
                     ;; the user went away, and they've ask to subtract all the
                     ;; time...
                     start-over-p)        ;bool
                 nil)                     ;return bool

                ((or subtractp
                     (and gotback (= gotback 0)))
                 last-valid)            ;return time

                ((or (and keep (= keep default))
                     (and gotback (= gotback default)))
                 'now)                  ;return symbol

                (keep
                 (time-add last-valid (seconds-to-time (* 60 keep)))) ;return time

                (gotback last-valid) ;return time
                (t
                 (error "Unexpected, please report this as a bug")))
        (cond               ;check-in
          (keep last-valid)
          (gotback
           (time-subtract (current-time)
                          (seconds-to-time (* 60 gotback)))))
        (memq ch '(?K ?G ?O ?S))        ;close-p
        (and start-over-p               ;restart-p
             (not (memq ch '(?C ?K ?G ?O ?S))))
        fail-quietly)))))







;;;###autoload
(defun org-resolve-clocks (&optional only-dangling-p prompt-fn last-valid)
  "Resolve all currently open Org clocks.
If `only-dangling-p' is non-nil, only ask to resolve dangling
\(i.e., not currently open and valid) clocks."
  (interactive "P")
  (unless org-clock-resolving-clocks
    (let ((org-clock-resolving-clocks t))
      (dolist (file (org-files-list))
        (let ((clocks (org-find-open-clocks file)))
          (dolist (clock clocks)
            (let ((dangling (or (not (org-clock-is-active))
                                (/= (car clock) org-clock-marker))))
              (if (or (not only-dangling-p) dangling)
                  (org-clock-resolve
                   clock
                   (or prompt-fn
                       (function
                        (lambda (clock)
                         (format
                          "Dangling clock started %d mins ago"
                          (floor (- (float-time)
                                    (float-time (cdr clock)))
                                 60)))))
                   (or last-valid
                       (cdr clock)))))))))))

(defun org-emacs-idle-seconds ()
  "Return the current Emacs idle time in seconds, or nil if not idle."
  (let ((idle-time (current-idle-time)))
    (if idle-time
        (float-time idle-time)
        0)))

(defun org-mac-idle-seconds ()
  "Return the current Mac idle time in seconds."
  (string-to-number (shell-command-to-string "ioreg -c IOHIDSystem | perl -ane 'if (/Idle/) {$idle=(pop @F)/1000000000; print $idle; last}'")))

(defvar org-x11idle-exists-p
  ;; Check that x11idle exists
  (and (eq window-system 'x)
       (eq 0 (call-process-shell-command
              (format "command -v %s" org-clock-x11idle-program-name)))
       ;; Check that x11idle can retrieve the idle time
       ;; FIXME: Why "..-shell-command" rather than just `call-process'?
       (eq 0 (call-process-shell-command org-clock-x11idle-program-name))))

(defun org-x11-idle-seconds ()
  "Return the current X11 idle time in seconds."
  (/ (string-to-number (shell-command-to-string org-clock-x11idle-program-name)) 1000))

(defun org-user-idle-seconds ()
  "Return the number of seconds the user has been idle for.
This routine returns a floating point number."
  (cond
    ((eq system-type 'darwin)
     (org-mac-idle-seconds))
    ((and (eq window-system 'x) org-x11idle-exists-p)
     (org-x11-idle-seconds))
    (t
     (org-emacs-idle-seconds))))

(defvar org-clock-user-idle-seconds)

(defun org-resolve-clocks-if-idle ()
  "Resolve all currently open Org clocks.
This is performed after `org-clock-idle-time' minutes, to check
if the user really wants to stay clocked in after being idle for
so long."
  (when (and org-clock-idle-time (not org-clock-resolving-clocks)
             org-clock-marker (marker-buffer org-clock-marker))
    (let* ((org-clock-user-idle-seconds (org-user-idle-seconds))
           (org-clock-user-idle-start
            (time-subtract (current-time)
                           (seconds-to-time org-clock-user-idle-seconds)))
           (org-clock-resolving-clocks-due-to-idleness t))
      (if (> org-clock-user-idle-seconds (* 60 org-clock-idle-time))
          (org-clock-resolve
           (cons org-clock-marker
                 org-clock-start-time)
           (lambda (_)
             (format "Clocked in & idle for %.1f mins"
                     (/ (float-time
                         (time-subtract (current-time)
                                        org-clock-user-idle-start))
                        60.0)))
           org-clock-user-idle-start)))))

(defvar org-clock-current-task nil "Task currently clocked in.")
(defvar org-clock-out-time nil) ; store the time of the last clock-out
(defvar org--msg-extra)


(defvar org-resolve-opts
  (
   ))

(assoc "a"
                 '(("a" . 1)
                   ("b" . 2)))
(setq org-resolve-opts-common
      '(("include-in-other" . include-in-next)
        ("sustract" . sustract)))

(setq org-resolve-opts-pre
      '(("cancel-pre-p" . cancel-pre-p)
        ("include-in-pre" . include-in-pre)))

(setq org-resolve-opts-next
      '(("cancel-next-p" . cancel-next-p)
        ("include-in-next" . include-in-next)))


(defun org-rl-clock-start-time (clock)
  (cadr clock))

(defun org-rl-clock-stop-time (clock)
  (caddr clock))

(defun org-rl-clock-marker (clock)
  (car clock))

(defun org-rl-clock-start-time-set (clock time)
  (setf (cadr clock) time))

(defun org-rl-clock-stop-time-set (clock time)
  (setf (caddr clock) time))

(defun org-rl-clock-marker-set (clock marker)
  (setf (car clock) marker))

(defun org-resolve-time (pre
                         next
                         &optional
                           immediate-p)
  (interactive)
  ""
  (unless (zerop timelength)
    (let* ((default
            (/
             (float-time
              (time-subtract
               (if next (org-rl-clock-start-time  next) (current-time))
               (if pre (org-rl-clock-stop-time prev) (time-subtract (current-time) (seconds-to-time (* 60 60))))))
             60))
           (timelen
            (read-number "how many minutes? " default))
           (options
            (append
             (when pre  org-resolve-opts-pre)
             (when next org-resolve-opts-next)
             org-resolve-opts-common))
           (opt
            (cdr
             (assoc
              (completing-read "Select option: " options)
              options)))

           (barely-started-p (< (- (float-time last-valid)
                                   (float-time (cdr clock))) 45))
           (start-over-p (and subtractp barely-started-p)))
      ;; cancel pre and add to time

      (when (> (abs timelen) default)
        (message "Erro")
        (org-resolve-time pre default next))

      (cond
        ((eq opt cancel-pre-p)
         (progn
           (org-clock-clock-cancel pre)
           (let ((pre-start (cdr pre)))
             (setq pre
                   (list nil nil (org-rl-clock-start-time pre))))))

        ((eq opt cancel-next-p)
         ;; cancel next clock
         ;; add next clock time
         (progn
           (org-clock-clock-cancel next)
           (let ((next-start (cdr next)))
             (setq next
                   (list nil (org-rl-clock-stop-time pre) nil)))))

        ((eq opt include-in-pre)
         (if (> timelen 0)
             (let ((update-stop-time (time-add (org-rl-clock-stop-time pre) timelen)))
               (clockout pre update-stop-time)
               (org-rl-clock-stop-time-set pre update-stop-time))
             (progn
               (org-rl-clock-stop-time pre (org-rl-clock-stop-time pre))
               ))
         ;; include timelen in pre
         ;; update timelength
             )
        ((eq opt include-in-next)
         ;; include timelen in next
         ;; update timelength
         )
        ((eq opt include-in-other)
         ;; select other clock
         ;; include timelen in other
         ;; update timelength
         )
        ((eq opt substract)
         )
        ;; subtract timelen from timelength
        )

      (org-resolve-time pre timeleght next immediate-p))))





(provide 'org-clock-resolve-advanced)
;;; org-clock-utils-lotus.el ends here
