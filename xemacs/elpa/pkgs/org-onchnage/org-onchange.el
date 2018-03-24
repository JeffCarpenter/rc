;; Org insert log note un-interactively


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-onchnage/org-onchange.org::*Org%20insert%20log%20note%20un-interactively][Org insert log note un-interactively:1]]
;; copy of org-store-log-note
(defun org-insert-log-note (marker txt &optional purpose effective-time state previous-state)
  "Finish taking a log note, and insert it to where it belongs."
  (let* ((note-marker marker)
         (txt txt)
         (note-purpose purpose)
         (effective-time (or effective-time (org-current-effective-time)))
         (state (or state 'note))
         (previous-state previous-state))
    (if (marker-buffer marker)
        (let ((note (cdr (assq note-purpose org-log-note-headings)))
              lines)
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
                                      ((not state) "")
                                      ((string-match-p org-ts-regexp state)
                                       (format "\"[%s]\""
                                               (substring state 1 -1)))
                                      (t (format "\"%s\"" state))))
                         (cons "%S"
                               (cond
                                 ((not org-log-note-previous-state) "")
                                 ((string-match-p org-ts-regexp
                                                  previous-state)
                                  (format "\"[%s]\""
                                          (substring
                                           previous-state 1 -1)))
                                 (t (format "\"%s\""
                                            previous-state)))))))
            (when lines (setq note (concat note " \\\\")))
            (push note lines))

          (when lines ;; (and lines (not (or current-prefix-arg org-note-abort)))
            (with-current-buffer (marker-buffer note-marker)
              (org-with-wide-buffer
               ;; Find location for the new note.
               (goto-char note-marker)
               (set-marker note-marker nil)
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
               (insert (org-list-bullet-string "-") (pop lines))
               (let ((ind (org-list-item-body-column (line-beginning-position))))
                 (dolist (line lines)
                   (insert "\n")
                   (indent-line-to ind)
                   (insert line)))
               (message "Note stored")
               (org-back-to-heading t)
               (org-cycle-hide-drawers 'children))
              ;; Fix `buffer-undo-list' when `org-store-log-note' is called
              ;; from within `org-add-log-note' because `buffer-undo-list'
              ;; is then modified outside of `org-with-remote-undo'.
              (when (eq this-command 'org-agenda-todo)
                (setcdr buffer-undo-list (cddr buffer-undo-list)))))
          )
        (error "merker %s buffer is nil" marker))))
;; Org insert log note un-interactively:1 ends here

;; Preamble

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-onchnage/org-onchange.org::*Preamble][Preamble:1]]
;;; org-onchnage.el --- copy config

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
;; Preamble:1 ends here

;; Libraries required


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-onchnage/org-onchange.org::*Libraries%20required][Libraries required:1]]
(require 'desktop)
(require 'session)

(require 'timer-utils-lotus)
(eval-when-compile
  (require 'timer-utils-lotus))
(require 'org-misc-utils-lotus)
(eval-when-compile
  (require 'org-misc-utils-lotus))
(require 'lotus-misc-utils)
(eval-when-compile
  (require 'lotus-misc-utils))
;; Libraries required:1 ends here

;; org-add-log-setup (&optional purpose state prev-state how extra)
;;  Set up the post command hook to take a note.
;;  If this is about to TODO state change, the new state is expected in STATE.
;;  HOW is an indicator what kind of note should be created.
;;  EXTRA is additional text that will be inserted into the notes buffer.

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-onchnage/org-onchange.org::*org-add-log-setup%20(&optional%20purpose%20state%20prev-state%20how%20extra)][org-add-log-setup (&optional purpose state prev-state how extra):1]]
(defun org-add-log-setup (&optional purpose state prev-state how extra)
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
  (add-hook 'post-command-hook 'org-add-log-note 'append))

(add-hook 'post-command-hook 'org-add-log-note 'append)
;; org-add-log-setup (&optional purpose state prev-state how extra):1 ends here

;; Clock out with NOTE


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-onchnage/org-onchange.org::*Clock%20out%20with%20NOTE][Clock out with NOTE:1]]
;;;###autoload
(defun org-clock-out-with-note (note &optional switch-to-state fail-quietly at-time) ;BUG TODO will it work or save-excursion save-restriction also required
  "org-clock-out-with-note"
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
;; Clock out with NOTE:1 ends here

;; Org add log note with-timed-new-win
;; background in name is misleading it at present log-note show org file buffer to
;; add note but in this case it is not shown so background word is used.

;; *Note:* these function prepare buffer or window (timed) to take log note
;;         main work is only done by _org-store-log-note_


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-onchnage/org-onchange.org::*Org%20add%20log%20note%20with-timed-new-win][Org add log note with-timed-new-win:1]]
;; copy of org-add-log-note
 (defun org-add-log-note-buffer (target-buffer)
   "Prepare buffer for taking a note, to add this note later."
   ;; (pop-to-buffer-same-window (marker-buffer org-log-note-marker))
   ;; (goto-char org-log-note-marker)
   ;; (org-switch-to-buffer-other-window "*Org Note*")

   (switch-to-buffer target-buffer 'norecord)
   ;; (set-buffer target-buffer)
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


  (defun org-add-log-note-with-timed-new-win (win-timeout &optional _purpose)
    "Pop up a window for taking a note, and add this note later."
    ;; (remove-hook 'post-command-hook 'org-add-log-note-background)
    ;; (setq org-log-note-window-configuration (current-window-configuration))
    ;; (delete-other-windows)

    ;; (move-marker org-log-note-return-to (point))
    (lotus-with-no-active-minibuffer
        (progn                            ;could schedule in little further.
          (message "add-log-note-background: minibuffer already active quitting")
          (message nil))
      (let ((win-timeout (or win-timeout 17))
            (cleanupfn-local nil))
        (setq org-log-note-window-configuration (current-window-configuration))
        (lotus-with-timed-new-win
            win-timeout timer cleanupfn-newwin cleanupfn-local win
            (condition-case err
                (let ((target-buffer (get-buffer-create "*Org Note*")))
                  (org-add-log-note-buffer target-buffer))
              ((quit)
               (progn
                 (funcall cleanupfn-newwin win cleanupfn-local)
                 (if timer (cancel-timer timer))
                 (signal (car err) (cdr err)))))))))

  (defun org-add-log-setup-with-timed-new-win (win-timeout &optional purpose state prev-state how extra)
    "Set up the post command hook to take a note.
  If this is about to TODO state change, the new state is expected in STATE.
  HOW is an indicator what kind of note should be created.
  EXTRA is additional text that will be inserted into the notes buffer."
    (let ((win-timeout (or win-timeout 17)))
      (move-marker org-log-note-marker (point))
      (setq org-log-note-purpose purpose
            org-log-note-state state
            org-log-note-previous-state prev-state
            org-log-note-how how
            org-log-note-extra extra
            org-log-note-effective-time (org-current-effective-time)))
    (org-add-log-note-with-timed-new-win  win-timeout)
    ;; (add-hook 'post-command-hook 'org-add-log-note-background 'append)
    )

  ;;;##autoload
  (defun org-clock-lotus-log-note-current-clock-with-timed-new-win (win-timeout &optional fail-quietly)
    (interactive)
    (let ((win-timeout  (or win-timeout  17)))
      (when (org-clocking-p)
        (move-marker org-log-note-return-to (point))
        (org-clock-lotus-with-current-clock
            (org-add-log-setup-with-timed-new-win win-timeout
            'note nil nil nil
            (concat "# Task: " (org-get-heading t) "\n\n"))))))

  ;; (defun org-clock-lotus-log-note-current-clock-with-timed-new-win (&optional fail-quietly)
  ;;   (interactive)
  ;;   (if (org-clocking-p)
  ;;       (org-clock-lotus-with-current-clock
  ;;        (org-add-log-setup-background
  ;;         'note nil nil nil
  ;;         (concat "# Task: " (org-get-heading t) "\n\n")))
  ;;       (if fail-quietly (throw 'exit t) (user-error "No active clock"))))
;; Org add log note with-timed-new-win:1 ends here

;; Org detect change to log note


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-onchnage/org-onchange.org::*Org%20detect%20change%20to%20log%20note][Org detect change to log note:1]]
(defun lotus-buffer-changes-count ()
  (let ((changes 0))
    (when buffer-undo-tree
      (undo-tree-mapc
       (lambda (node)
         (setq changes (+ changes 1;; (length (undo-tree-node-next node))
                          )))
       (undo-tree-root buffer-undo-tree)))
    changes))

(defvar lotus-minimum-char-changes 70)
(defvar lotus-minimum-changes 70)

(defvar lotus-last-buffer-undo-tree-count 0) ;internal add in session and desktop
(when (featurep 'desktop)
  (add-to-list 'desktop-locals-to-save 'lotus-last-buffer-undo-tree-count))
(when (featurep 'session)
  (add-to-list 'session-locals-include 'lotus-last-buffer-undo-tree-count))
(make-variable-buffer-local 'lotus-last-buffer-undo-tree-count)

(defun lotus-action-on-buffer-undo-tree-change (action &optional minimal-changes win-timeout)
  (let ((win-timeout (or win-timeout 17))
        (chgcount (- (lotus-buffer-changes-count) lotus-last-buffer-undo-tree-count)))
    (if (>= chgcount minimal-changes)
        (if (funcall action win-timeout)
            (setq lotus-last-buffer-undo-tree-count chgcount))
        (when nil
         (message "buffer-undo-tree-change: only %d changes not more than %d" chgcount minimal-changes)))))

(defvar lotus-last-buffer-undo-list-pos nil) ;internal add in session and desktop
(make-variable-buffer-local 'lotus-last-buffer-undo-list-pos)
(when (featurep 'desktop)
  (add-to-list 'desktop-locals-to-save 'lotus-last-buffer-undo-list-pos))
(when (featurep 'session)
  (add-to-list 'session-locals-include 'lotus-last-buffer-undo-list-pos))
;;;###autoload
(defun lotus-action-on-buffer-undo-list-change (action &optional minimal-char-changes win-timeout)
  "Set point to the position of the last change.
Consecutive calls set point to the position of the previous change.
With a prefix arg (optional arg MARK-POINT non-nil), set mark so \
\\[exchange-point-and-mark]
will return point to the current position."
  ;; (interactive "P")
  ;; (unless (buffer-modified-p)
  ;;   (error "Buffer not modified"))
  (let ((win-timeout (or win-timeout 17)))
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
         (if (funcall action win-timeout)
             (setq lotus-last-buffer-undo-list-pos undo)))
        (t )))))
(defun org-clock-lotus-log-note-on-change (&optional win-timeout)
  ;; (when (or t (eq buffer (current-buffer)))
  (let ((win-timeout (or win-timeout 17)))
    (if (and
         (consp buffer-undo-list)
         (car buffer-undo-list))
        (lotus-action-on-buffer-undo-list-change #'org-clock-lotus-log-note-current-clock-with-timed-new-win  lotus-minimum-char-changes win-timeout)
        (lotus-action-on-buffer-undo-tree-change #'org-clock-lotus-log-note-current-clock-with-timed-new-win lotus-minimum-changes win-timeout))))
;; Org detect change to log note:1 ends here

;; Org log note on change timer

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-onchnage/org-onchange.org::*Org%20log%20note%20on%20change%20timer][Org log note on change timer:1]]
(defvar org-clock-lotus-log-note-on-change-timer nil
  "Time for on change log note.")


;; (unintern 'org-clock-lotus-log-note-on-change-timer)

;;;###autoload
(defun org-clock-lotus-log-note-on-change-start-timer (&optional idle-timeout win-timeout)
  (interactive)
  (let ((idle-timeout (or idle-timeout 10))
        (win-timeout (or win-timeout 7)))
    (if org-clock-lotus-log-note-on-change-timer
        (progn
          (cancel-timer org-clock-lotus-log-note-on-change-timer)
          (setq org-clock-lotus-log-note-on-change-timer nil)))
    (setq
     org-clock-lotus-log-note-on-change-timer (run-with-idle-timer
                                               idle-timeout
                                               idle-timeout
                                               #'org-clock-lotus-log-note-on-change (+ idle-timeout win-timeout)))))

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
  (org-clock-lotus-log-note-on-change-start-timer 10 7))

;;;###autoload
(defun org-clock-lotus-log-note-on-change-uninsinuate ()
  (interactive)
  ;; message-send-mail-hook
  (org-clock-lotus-log-note-on-change-stop-timer))
;; Org log note on change timer:1 ends here

;; Org log note change from different sources

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-onchnage/org-onchange.org::*Org%20log%20note%20change%20from%20different%20sources][Org log note change from different sources:1]]
;;{{
 ;; https://emacs.stackexchange.com/questions/101/how-can-i-create-an-org-link-for-each-email-sent-by-mu4e
 ;; My first suggestion would be to try the following.

 (add-hook 'message-send-hook (lambda () (org-store-link nil)))

 ;; Since you said you tried the hook, another way is to just combine
 ;; org-store-link and message sending into a single function.

 (defun store-link-then-send-message ()
   "Call `org-store-link', then send current email message."
   (interactive)
   (call-interactively #'org-store-link)
   (call-interactively #'message-send-and-exit))

(when (and
       (boundp 'mu4e-compose-mode-map)
       (keymapp mu4e-compose-mode-map))
  (define-key mu4e-compose-mode-map "\C-c\C-c" #'store-link-then-send-message)

  ;; This assumes you're using message-send-and-exit to send the message. You
  ;; could do something identical with the message-send command.

  (define-key mu4e-compose-mode-map "\C-c\C-c" #'store-link-then-send-message))
 ;;}}

 ;;{{ http://kitchingroup.cheme.cmu.edu/blog/2014/06/08/Better-integration-of-org-mode-and-email/
 ;; I like to email org-mode headings and content to people. It would be nice to
 ;; have some records of when a heading was sent, and to whom. We store this
 ;; information in a heading. It is pretty easy to write a simple function that
 ;; emails a selected region.

 (defun email-region (start end)
   "Send region as the body of an email."
   (interactive "r")
   (let ((content (buffer-substring start end)))
     (compose-mail)
     (message-goto-body)
     (insert content)
     (message-goto-to)))

 ;; that function is not glamorous, and you still have to fill in the email
 ;; fields, and unless you use gnus and org-contacts, the only record keeping is
 ;; through the email provider.

 ;; What I would like is to send a whole heading in an email. The headline should
 ;; be the subject, and if there are TO, CC or BCC properties, those should be
 ;; used. If there is no TO, then I want to grab the TO from the email after you
 ;; enter it and store it as a property. You should be able to set OTHER-HEADERS
 ;; as a property (this is just for fun. There is no practical reason for this
 ;; yet). After you send the email, it should record in the heading when it was
 ;; sent.

 ;; It turned out that is a relatively tall order. While it is easy to setup the
 ;; email if you have everything in place, it is tricky to get the information on
 ;; TO and the time sent after the email is sent. Past lispers had a lot of ideas
 ;; to make this possible, and a day of digging got me to the answer. You can
 ;; specify some "action" functions that get called at various times, e.g. after
 ;; sending, and a return action when the compose window is done. Unfortunately,
 ;; I could not figure out any way to do things except to communicate through
 ;; some global variables.

 ;; So here is the code that lets me send org-headings, with the TO, CC, BCC
 ;; properties, and that records when I sent the email after it is sent.

 (defvar *email-heading-point* nil
   "global variable to store point in for returning")

 (defvar *email-to-addresses* nil
   "global variable to store to address in email")

 (defun email-heading-return ()
   "after returning from compose do this"
   (switch-to-buffer (marker-buffer  *email-heading-point*))
   (goto-char (marker-position  *email-heading-point*))
   (setq *email-heading-point* nil)
   (org-set-property "SENT-ON" (current-time-string))
   ;; reset this incase you added new ones
   (org-set-property "TO" *email-to-addresses*)
   )

 (defun email-send-action ()
   "send action for compose-mail"
   (setq *email-to-addresses* (mail-fetch-field "To")))

 (defun email-heading ()
   "Send the current org-mode heading as the body of an email, with headline as the subject.

 use these properties
 TO
 OTHER-HEADERS is an alist specifying additional
 header fields.  Elements look like (HEADER . VALUE) where both
 HEADER and VALUE are strings.

 save when it was sent as s SENT property. this is overwritten on
 subsequent sends. could save them all in a logbook?
 "
   (interactive)
   ; store location.
   (setq *email-heading-point* (set-marker (make-marker) (point)))
   (org-mark-subtree)
   (let ((content (buffer-substring (point) (mark)))
   (TO (org-entry-get (point) "TO" t))
   (CC (org-entry-get (point) "CC" t))
   (BCC (org-entry-get (point) "BCC" t))
   (SUBJECT (nth 4 (org-heading-components)))
   (OTHER-HEADERS (eval (org-entry-get (point) "OTHER-HEADERS")))
   (continue nil)
   (switch-function nil)
   (yank-action nil)
   (send-actions '((email-send-action . nil)))
   (return-action '(email-heading-return)))

     (compose-mail TO SUBJECT OTHER-HEADERS continue switch-function yank-action send-actions return-action)
     (message-goto-body)
     (insert content)
     (when CC
       (message-goto-cc)
       (insert CC))
     (when BCC
       (message-goto-bcc)
       (insert BCC))
     (if TO
   (message-goto-body)
       (message-goto-to))
     ))

 ;; This works pretty well for me. Since I normally use this to send tasks to
 ;; people, it keeps the task organized where I want it, and I can embed an
 ;; org-id in the email so if the person replies to it telling me the task is
 ;; done, I can easily navigate to the task to mark it off. Pretty handy.

 ;;}}
;; Org log note change from different sources:1 ends here

;; Provide this file

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-onchnage/org-onchange.org::*Provide%20this%20file][Provide this file:1]]
(provide 'org-onchnage)
;;; org-onchnage.el ends here
;; Provide this file:1 ends here
