;;; org-clock-utils-lotus.el --- copy config

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

;;
;; (use-package startup-hooks
;;     :defer t
;;     :config
;;     (progn
;;       (progn
;;         (add-to-enable-startup-interrupting-feature-hook
;;          '(lambda ()
;;            (when nil
;;              (add-hook 'after-make-frame-functions
;;                        '(lambda (nframe)
;;                          (run-at-time-or-now 100
;;                           '(lambda ()
;;                             (if (any-frame-opened-p)
;;                                 (org-clock-in-if-not)))))
;;                        t))
;;            (add-hook 'delete-frame-functions
;;             '(lambda (nframe)
;;               (if (and
;;                    (org-clock-is-active)
;;                    (y-or-n-p-with-timeout (format "Do you want to clock out current task %s: " org-clock-heading) 7 nil))
;;                   (org-with-clock-writeable-buffer
;;                    (let (org-log-note-clock-out)
;;                      (if (org-clock-is-active)
;;                          (org-clock-out))))))))
;;          t))

;;       (progn
;;         (add-to-enable-desktop-restore-interrupting-feature-hook
;;          '(lambda ()
;;            (if (fboundp 'org-clock-persistence-insinuate)
;;                (org-clock-persistence-insinuate)
;;                (message "Error: Org Clock function org-clock-persistence-insinuate not available."))
;;            (if (fboundp 'org-clock-start-check-timer)
;;                (org-clock-start-check-timer)))
;;          t))))


;; (add-hook
;;  'kill-emacs-hook
;;  (lambda ()
;;    (if (and
;;         (org-clock-is-active)
;;         ;; (y-or-n-p-with-timeout (format "Do you want to clock out current task %s: " org-clock-heading) 7 nil)
;;         )
;;        (org-with-clock-writeable-buffer
;;         (let (org-log-note-clock-out)
;;           (if (org-clock-is-active)
;;               (org-clock-out)))))))

;;; Code:

(require 'org)
(require 'org-timer)
(require 'org-clock)
(require 'timer-utils-lotus)
(eval-when-compile
  (require 'org-misc-utils-lotus))

(defmacro org-with-clock-position (clock &rest forms)
  "Evaluate FORMS with CLOCK as the current active clock."
  `(with-current-buffer (marker-buffer (car ,clock))
     (save-excursion
       (save-restriction
         (widen)
         (goto-char (car ,clock))
         (beginning-of-line)
         (let (buffer-read-only)
           ,@forms)))))

(defvar org-clock-check-long-timer-period 7
  "Period of Long Timer to remind to clock-in after some time of clockout or if no clock found at start of emacs.")

(defvar org-clock-check-long-timer nil
  "Long Timer to remind to clock-in after some time of clockout or if no clock found at start of emacs.")

(defvar org-clock-check-short-timer-period 2
  "Period Short Timer to remind to clock-in after some time of clockout or if no clock found at start of emacs.")

;; (defvar org-clock-check-short-timer nil
;;   "Short Timer to remind to clock-in after some time of clockout or if no clock found at start of emacs.")

;;;###autoload
(defun org-clock-start-check-timer ()
  "Attempt to clock-in when already not clock found."
  (interactive)
  (org-clock-stop-check-timer)
  (setq
   org-clock-check-long-timer
   (run-with-nonobtrusive-aware-idle-timers
    org-clock-check-long-timer-period
    org-clock-check-long-timer-period
    org-clock-check-short-timer-period
    nil
    #'(lambda (arg)
        (unless (org-clock-is-active)
          (org-clock-in-if-not)))
    nil
    nil)))

;;;###autoload
(defun org-clock-stop-check-timer ()
  "Stop attemptting to clock-in when already not clock found."
  (interactive)
  (progn
    ;; (when org-clock-check-short-timer
    ;;   (cancel-timer org-clock-check-short-timer)
    ;;   (setq org-clock-check-short-timer nil))
    (when org-clock-check-long-timer
      (cancel-timer org-clock-check-long-timer)
      (setq org-clock-check-long-timer nil))))

;;;###autoload
(defun org-clock-start-check-timer-insiuate ()
  (org-clock-start-check-timer))

;;;###autoload
(defun org-clock-start-check-timer-uninsiuate ()
  (org-clock-stop-check-timer))

;; "correction org-timer.el"
(defun replace-org-timer-set-timer (&optional opt)
    "Prompt for a duration in minutes or hh:mm:ss and set a timer.

If `org-timer-default-timer' is not \"0\", suggest this value as
the default duration for the timer.  If a timer is already set,
prompt the user if she wants to replace it.

Called with a numeric prefix argument, use this numeric value as
the duration of the timer in minutes.

Called with a `C-u' prefix arguments, use `org-timer-default-timer'
without prompting the user for a duration.

With two `C-u' prefix arguments, use `org-timer-default-timer'
without prompting the user for a duration and automatically
replace any running timer.

By default, the timer duration will be set to the number of
minutes in the Effort property, if any.  You can ignore this by
using three `C-u' prefix arguments."
    (interactive "P")
    (when (and org-timer-start-time
               (not org-timer-countdown-timer))
      (user-error "Relative timer is running.  Stop first"))
    (let* ((default-timer
            ;; `org-timer-default-timer' used to be a number, don't choke:
            (if (numberp org-timer-default-timer)
                (number-to-string org-timer-default-timer)
                org-timer-default-timer))
           (clocked-time   (org-clock-get-clocked-time))
           (effort-minutes
            (or
             (ignore-errors (org-get-at-eol 'effort-minutes 1))
             (if (org-entry-get nil "Effort")
                 (org-duration-string-to-minutes (org-entry-get nil "Effort")))))
           (remianing-effort-minutes (if (and
                                          effort-minutes
                                          clocked-time
                                          (>= effort-minutes clocked-time))
                                         (- effort-minutes clocked-time)
                                         effort-minutes))
           (minutes (or (and (not (equal opt '(64)))
                             effort-minutes
                             (number-to-string remianing-effort-minutes))
                        (and (numberp opt) (number-to-string opt))
                        (and (consp opt) default-timer)
                        (and (stringp opt) opt)
                        (read-from-minibuffer
                         "How much time left? (minutes or h:mm:ss) "
                         (and (not (string-equal default-timer "0")) default-timer)))))
      (message "effort-minutes %s clocked-time %s remianing-effort-minutes %s" effort-minutes clocked-time remianing-effort-minutes)
      (when (string-match "\\`[0-9]+\\'" minutes)
        (let* ((mins (string-to-number minutes))
               (h (/ mins 60))
               (m (% mins 60)))
          (setq minutes (format "%02d:%02d" h m)))
        (setq minutes (concat minutes ":00")))
      (if (not (string-match "[0-9]+" minutes))
          (org-timer-show-remaining-time)
          (let ((secs (org-timer-hms-to-secs (org-timer-fix-incomplete minutes)))
                (hl (org-timer--get-timer-title)))
            (if (or (not org-timer-countdown-timer)
                    (equal opt '(16))
                    (y-or-n-p "Replace current timer? "))
                (progn
                  (when (timerp org-timer-countdown-timer)
                    (cancel-timer org-timer-countdown-timer))
                  (setq org-timer-countdown-timer-title
                        (org-timer--get-timer-title))
                  (setq org-timer-countdown-timer
                        (org-timer--run-countdown-timer
                         secs org-timer-countdown-timer-title))
                  (run-hooks 'org-timer-set-hook)
                  (setq org-timer-start-time
                        (time-add (current-time) (seconds-to-time secs)))
                  (setq org-timer-pause-time nil)
                  (org-timer-set-mode-line 'on))
                (message "No timer set"))))))

;; (advice-add 'org-timer-set-timer :around #'replace-org-timer-set-timer)

(add-function :override (symbol-function 'org-timer-set-timer) #'replace-org-timer-set-timer)

(eval-when-compile
  (require 'org-misc-utils-lotus))
(require 'org-misc-utils-lotus)


;; (find
;;   org-clock-leftover-time
;;   org-clock-default-task ;; M-x org-clock-mark-default-task
;;   M-x org-clock-select-task
;; (org-clocking-buffer)
;; (org-clock-sum-today)
;; (org-clock-sum-custom nil 'today)
;; (org-clock-is-active)
;; )

(defvar org-clock-default-effort "1:00")

(defun lotus-org-mode-add-default-effort ()
  "Add a default effort estimation."
  (unless (org-entry-get (point) "Effort")
    (org-set-property "Effort" org-clock-default-effort)))
(add-hook 'org-clock-in-prepare-hook
          'lotus-org-mode-ask-effort)

(defun lotus-org-mode-ask-effort ()
  "Ask for an effort estimate when clocking in."
  (unless (org-entry-get (point) "Effort")
    (let ((effort
           (completing-read
            "Effort: "
            (org-entry-get-multivalued-property (point) "Effort"))))
      (unless (equal effort "")
        (org-set-property "Effort" effort)))))

;; org-refile-targets is set in org-misc-utils-lotus package
;;;###autoload
(defun org-clock-in-refile (refile-targets)
  (org-with-refile file loc (or refile-targets org-refile-targets)
    (let ((buffer-read-only nil))
      (org-clock-in))))

(defvar org-donot-try-to-clock-in nil
  "Not try to clock-in, require for properly creating frame especially for frame-launcher function.")
;;;###autoload
(defun org-clock-in-if-not ()
  (interactive)
  (unless (or
           org-donot-try-to-clock-in
           (org-clock-is-active))
    ;; (org-clock-goto t)
    (if org-clock-history
        (let (buffer-read-only)
          (org-clock-in '(4)))
        ;; with-current-buffer should be some real file
        (org-clock-in-refile nil))))

;;;###autoload
(defun lotus-org-clock-in/out-insinuate-hooks ()
  (add-hook 'org-clock-in-hook
            '(lambda ()
              ;; ;; if effort is not present than add it.
              ;; (unless (org-entry-get nil "Effort")
              ;;   (save-excursion
              ;;    (org-set-effort)))
              ;; set timer
              (when (not
                     (and
                      (boundp' org-timer-countdown-timer)
                      org-timer-countdown-timer))
                (if (org-entry-get nil "Effort")
                    (save-excursion
                      (forward-line -2)
                      (org-timer-set-timer))
                    (call-interactively 'org-timer-set-timer)))
              (save-buffer)
              (org-save-all-org-buffers)))
  (add-hook 'org-clock-out-hook
            '(lambda ()
              (if (and
                   (boundp' org-timer-countdown-timer)
                   org-timer-countdown-timer)
                  (org-timer-stop))
              (org-clock-get-work-day-clock-string t)
              (save-buffer)
              (org-save-all-org-buffers))))








;;; note on change

;;;###autoload
(defun org-clock-out-with-note (note &optional switch-to-state fail-quietly at-time) ;BUG TODO will it work or save-excursion save-restriction also required
  (interactive
   (let ((note (read-from-minibuffer "Closing notes: "))
         (switch-to-state current-prefix-arg))
     (list note switch-to-state)))

  (let ((org-log-note-clock-out t))
    (move-marker org-log-note-return-to nil)
    (move-marker org-log-note-marker nil)
    (org-clock-out switch-to-state fail-quietly at-time)
    (remove-hook 'post-command-hook 'org-add-log-note)
    (org-insert-log-note note)))


(progn                                  ;old
  (defun org-add-log-note-background (&optional _purpose)
    "Pop up a window for taking a note, and add this note later."
    (remove-hook 'post-command-hook 'org-add-log-note-background)
    (setq org-log-note-window-configuration (current-window-configuration))
    (delete-other-windows)


    (move-marker org-log-note-return-to (point))
    ;; (pop-to-buffer-same-window (marker-buffer org-log-note-marker))
    ;; (goto-char org-log-note-marker)



    (org-switch-to-buffer-other-window "*Org Note*")
    (erase-buffer)
    (if (memq org-log-note-how '(time state))
        (let (current-prefix-arg) (org-store-log-note))
        (let ((org-inhibit-startup t)) (org-mode))
        (insert (format "# Insert note for %s.
# Finish with C-c C-c, or cancel with C-c C-k.\n\n"
                        (cond
                          ((eq org-log-note-purpose 'clock-out) "stopped clock")
                          ((eq org-log-note-purpose 'done)  "closed todo item")
                          ((eq org-log-note-purpose 'state)
                           (format "state change from \"%s\" to \"%s\""
                                   (or org-log-note-previous-state "")
                                   (or org-log-note-state "")))
                          ((eq org-log-note-purpose 'reschedule)
                           "rescheduling")
                          ((eq org-log-note-purpose 'delschedule)
                           "no longer scheduled")
                          ((eq org-log-note-purpose 'redeadline)
                           "changing deadline")
                          ((eq org-log-note-purpose 'deldeadline)
                           "removing deadline")
                          ((eq org-log-note-purpose 'refile)
                           "refiling")
                          ((eq org-log-note-purpose 'note)
                           "this entry")
                          (t (error "This should not happen")))))
        (when org-log-note-extra (insert org-log-note-extra))
        (setq-local org-finish-function 'org-store-log-note)
        (run-hooks 'org-log-buffer-setup-hook)))

  (defun org-add-log-setup-background (&optional purpose state prev-state how extra)
    "Set up the post command hook to take a note.
If this is about to TODO state change, the new state is expected in STATE.
HOW is an indicator what kind of note should be created.
EXTRA is additional text that will be inserted into the notes buffer."
    (move-marker org-log-note-marker (point))
    (setq org-log-note-purpose purpose
          org-log-note-state state
          org-log-note-previous-state prev-state
          org-log-note-how how
          org-log-note-extra extra
          org-log-note-effective-time (org-current-effective-time))
    (add-hook 'post-command-hook 'org-add-log-note-background 'append)))


(progn                                  ;new

  (defun org-add-log-note-background (&optional _purpose)
    "Pop up a window for taking a note, and add this note later."
    ;; (remove-hook 'post-command-hook 'org-add-log-note-background)
    ;; (setq org-log-note-window-configuration (current-window-configuration))
    ;; (delete-other-windows)

    (move-marker org-log-note-return-to (point))

    (org-with-timed-new-win
     win 3
     (let ((target-buffer (get-buffer-create "*Org Note*")))

       ;; (pop-to-buffer-same-window (marker-buffer org-log-note-marker))
       ;; (goto-char org-log-note-marker)

       ;; (org-switch-to-buffer-other-window "*Org Note*")

       (switch-to-buffer target-buffer 'norecord)
       (set-buffer target-buffer)
       (erase-buffer)

       (if (memq org-log-note-how '(time state))
           (let (current-prefix-arg) (org-store-log-note))
           (let ((org-inhibit-startup t)) (org-mode))
           (insert (format "# Insert note for %s.
# Finish with C-c C-c, or cancel with C-c C-k.\n\n"
                           (cond
                             ((eq org-log-note-purpose 'clock-out) "stopped clock")
                             ((eq org-log-note-purpose 'done)  "closed todo item")
                             ((eq org-log-note-purpose 'state)
                              (format "state change from \"%s\" to \"%s\""
                                      (or org-log-note-previous-state "")
                                      (or org-log-note-state "")))
                             ((eq org-log-note-purpose 'reschedule)
                              "rescheduling")
                             ((eq org-log-note-purpose 'delschedule)
                              "no longer scheduled")
                             ((eq org-log-note-purpose 'redeadline)
                              "changing deadline")
                             ((eq org-log-note-purpose 'deldeadline)
                              "removing deadline")
                             ((eq org-log-note-purpose 'refile)
                              "refiling")
                             ((eq org-log-note-purpose 'note)
                              "this entry")
                             (t (error "This should not happen")))))
           (when org-log-note-extra (insert org-log-note-extra))
           (setq-local org-finish-function 'org-store-log-note)
           (run-hooks 'org-log-buffer-setup-hook)))))

  (defun org-add-log-setup-background (&optional purpose state prev-state how extra)
    "Set up the post command hook to take a note.
If this is about to TODO state change, the new state is expected in STATE.
HOW is an indicator what kind of note should be created.
EXTRA is additional text that will be inserted into the notes buffer."
    (move-marker org-log-note-marker (point))
    (setq org-log-note-purpose purpose
          org-log-note-state state
          org-log-note-previous-state prev-state
          org-log-note-how how
          org-log-note-extra extra
          org-log-note-effective-time (org-current-effective-time))
    (org-add-log-note-background)
    ;; (add-hook 'post-command-hook 'org-add-log-note-background 'append)
    ))

;;;##autoload
(defun org-clock-lotus-log-note-current-clock-background (&optional fail-quietly)
  (interactive)
  (if (org-clocking-p)
      (org-clock-lotus-with-current-clock
       (org-add-log-setup-background
        'note nil nil nil
        (concat "# Task: " (org-get-heading t) "\n\n")))
      (if fail-quietly (throw 'exit t) (user-error "No active clock"))))


(defun lotus-buffer-changes-count ()
  (let ((changes 0))
    (when buffer-undo-tree
      (undo-tree-mapc
       (lambda (node)
         (setq changes (+ changes 1;; (length (undo-tree-node-next node))
                          )))
       (undo-tree-root buffer-undo-tree)))
    changes))

(require 'desktop)
(require 'session)

(defvar lotus-minimum-char-changes 70)
(defvar lotus-minimum-changes 70)

(defvar lotus-last-buffer-undo-tree-count 0) ;internal add in session and desktop
(when (featurep 'desktop)
  (add-to-list 'desktop-locals-to-save 'lotus-last-buffer-undo-tree-count))
(when (featurep 'session)
  (add-to-list 'session-locals-include 'lotus-last-buffer-undo-tree-count))
(make-variable-buffer-local 'lotus-last-buffer-undo-tree-count)

(defun lotus-action-on-buffer-undo-tree-change (action &optional minimal-changes)
  (let ((chgcount (- (lotus-buffer-changes-count) lotus-last-buffer-undo-tree-count)))
    (if (>= chgcount minimal-changes)
        (if (funcall action)
            (setq lotus-last-buffer-undo-tree-count chgcount))
        (message "buffer-undo-tree-change: only %d changes not more than %d" chgcount minimal-changes))))

(defvar lotus-last-buffer-undo-list-pos nil) ;internal add in session and desktop
(make-variable-buffer-local 'lotus-last-buffer-undo-list-pos)
(when (featurep 'desktop)
  (add-to-list 'desktop-locals-to-save 'lotus-last-buffer-undo-list-pos))
(when (featurep 'session)
  (add-to-list 'session-locals-include 'lotus-last-buffer-undo-list-pos))
;;;###autoload
(defun lotus-action-on-buffer-undo-list-change (action &optional minimal-char-changes)
  "Set point to the position of the last change.
Consecutive calls set point to the position of the previous change.
With a prefix arg (optional arg MARK-POINT non-nil), set mark so \
\\[exchange-point-and-mark]
will return point to the current position."
  ;; (interactive "P")
  ;; (unless (buffer-modified-p)
  ;;   (error "Buffer not modified"))
  (when (eq buffer-undo-list t)
    (error "No undo information in this buffer"))
  ;; (when mark-point (push-mark))
  (unless minimal-char-changes
    (setq minimal-char-changes 10))
  (let ((char-changes 0)
        (undo-list (if lotus-last-buffer-undo-list-pos
                       (cdr (memq lotus-last-buffer-undo-list-pos buffer-undo-list))
                       buffer-undo-list))
        undo)
    (while (and undo-list
                (car undo-list)
                (< char-changes minimal-char-changes))
      (setq undo (car undo-list))
      (cond
        ((and (consp undo) (integerp (car undo)) (integerp (cdr undo)))
         ;; (BEG . END)
         (setq char-changes (+ char-changes (abs (- (car undo) (cdr undo))))))
        ((and (consp undo) (stringp (car undo))) ; (TEXT . POSITION)
         (setq char-changes (+ char-changes (length (car undo)))))
        ((and (consp undo) (eq (car undo) t))) ; (t HIGH . LOW)
        ((and (consp undo) (null (car undo)))
         ;; (nil PROPERTY VALUE BEG . END)
         ;; (setq position (cdr (last undo)))
         )
        ((and (consp undo) (markerp (car undo)))) ; (MARKER . DISTANCE)
        ((integerp undo))		; POSITION
        ((null undo))		; nil
        (t (error "Invalid undo entry: %s" undo)))
      (setq undo-list (cdr undo-list)))

    (cond
      ((>= char-changes minimal-char-changes)
       (if (funcall action)
           (setq lotus-last-buffer-undo-list-pos undo)))
      (t ))))
(defun org-clock-lotus-log-note-on-change ()
  ;; (when (or t (eq buffer (current-buffer)))
  (if (and
       (consp buffer-undo-list)
       (car buffer-undo-list))
      (lotus-action-on-buffer-undo-list-change #'org-clock-lotus-log-note-current-clock-background  lotus-minimum-char-changes)
      (lotus-action-on-buffer-undo-tree-change  #'org-clock-lotus-log-note-current-clock-background lotus-minimum-changes)))

(defvar org-clock-lotus-log-note-on-change-timer nil)


;; (unintern 'org-clock-lotus-log-note-on-change-timer)

;;;###autoload
(defun org-clock-lotus-log-note-on-change-start-timer ()
  (interactive)
  (if org-clock-lotus-log-note-on-change-timer
      (progn
        (cancel-timer org-clock-lotus-log-note-on-change-timer)
        (setq org-clock-lotus-log-note-on-change-timer nil)))
  (setq
   org-clock-lotus-log-note-on-change-timer (run-with-idle-timer 10 10 'org-clock-lotus-log-note-on-change)))

;;;###autoload
(defun org-clock-lotus-log-note-on-change-stop-timer ()
  (interactive)
  (if org-clock-lotus-log-note-on-change-timer
      (progn
        (cancel-timer org-clock-lotus-log-note-on-change-timer)
        (setq org-clock-lotus-log-note-on-change-timer nil))))

;;;###autoload
(defun org-clock-lotus-log-note-on-change-insinuate ()
  (interactive)
  ;; message-send-mail-hook
  (org-clock-lotus-log-note-on-change-start-timer))

;;;###autoload
(defun org-clock-lotus-log-note-on-change-uninsinuate ()
  (interactive)
  ;; message-send-mail-hook
  (org-clock-lotus-log-note-on-change-stop-timer))




(progn
  (eval-when-compile
    (require 'org-misc-utils-lotus))

  (progn
    (setq
     ;; org-timer-default-timer 25
     org-clock-persist-file  (auto-config-file "org/clock/org-clock-save.el")
     org-log-note-clock-out t           ;excellent, great
     org-clock-clocked-in-display 'both ;; ('mode-line 'frame-title 'both)
     org-clock-idle-time 5 ;; minutes
     org-clock-resolve-expert nil ;; good
     org-clock-sound t ;; could be file name
     ;; org-clock-current-task
     ;; org-clock-heading
     org-clock-history-length 100
     ;; org-clock-marker
     ;; org-clock-history
     org-clock-persist t
     ;; org-clock-out-switch-to-state ;; good
     ;; org-clock-in-switch-to-state
     org-clock-out-remove-zero-time-clocks t))

  (progn

    (defun org-idle-tracing-function (orig-fun &rest args)
      (message "org-resolve-clocks-if-idle called with args %S" args)
      (let ((res (apply orig-fun args)))
        (message "org-resolve-clocks-if-idle returned %S" res)
        res))

    (advice-add 'org-resolve-clocks-if-idle :around #'org-idle-tracing-function)

    ;; (advice-remove 'display-buffer #'org-idle-tracing-function)
    )

  (progn
    (when nil
      (defvar org-clock-display-timer-delay 2 "Org clock display timer delay")

      (defun org-clock-display-with-timer (start end old-len)
        (when (buffer-modified-p)
          ;; (when org-clock-display-timer
          ;;   (cancel-timer org-clock-display-timer)
          ;;   (setq org-clock-display-timer nil))
          ;; (setq
          ;;  org-clock-display-timer
          ;;  (run-with-timer org-clock-display-timer-delay nil 'org-clock-display))
          (org-clock-display)))

      (defun org-mode-setup-clock-display ()
        (make-variable-buffer-local 'org-clock-display-timer)
        (add-hook 'after-change-functions
                  'org-clock-display-with-timer))

      (add-hook 'org-mode-hook 'org-mode-setup-clock-display)))

  (progn

    ))


(provide 'org-clock-utils-lotus)
;;; org-clock-utils-lotus.el ends here
