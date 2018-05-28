;; Preamble


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Preamble][Preamble:1]]
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
;; Preamble:1 ends here

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Preamble][Preamble:2]]
(defgroup org-context-clock nil
  "Emacs Org Context Clocking."
  :tag "Org Clock"
  :group 'org-progress)
;; Preamble:2 ends here

;; Required libraries


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Required%20libraries][Required libraries:1]]
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

(require 'org-onchange)
;; Required libraries:1 ends here

;; It is divided into multiple files for different functionality


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*It%20is%20divided%20into%20multiple%20files%20for%20different%20functionality][It is divided into multiple files for different functionality:1]]
(require 'org-context-clock-api)
(require 'org-context-clock-api-list) ;; "org tasks access api for list org"
(require 'org-context-clock-api-recursive) ;; "org tasks access api for recursive task"
(require 'org-context-clock-api-interaction) ;; "Interactive utitlity API's for adding root subtree etc" ;; "org tasks clocking's API"
(require 'org-context-clock-assoc-predicate) ;; "org tasks associated to context predicate functions"
(require 'org-context-clock-assoc-rank) ;; "Org tasks associated to context rank functions"
(require 'org-context-clock-assoc-key) ;; "org tasks associated to context key functions on recursive taskinfos"
;; It is divided into multiple files for different functionality:1 ends here

;; Global variables

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Global%20variables][Global variables:1]]
(defvar *org-context-clock-task-current-context*  nil)
(defvar *org-context-clock-task-previous-context* nil)
(defvar *org-context-clock-clocked-dyntaskpl-context-history*  nil)
(defvar *org-context-clock-task-current-context-time-interval* 7)
(defvar *org-context-clock-last-buffer-select-time* (current-time))
(defvar *org-context-clock-buffer-select-timer* nil)
(defvar *org-context-clock-update-current-context-msg* "")
;; (defvar org-context-clock-api-name :predicate "API")
(defvar org-context-clock-access-api-name :recursive "Aceess API")
(defvar org-context-clock-assoc-api-name :keys "Assoc API")
(defvar org-context-clock-api-dyntaskpl-print                  (org-context-clock-access-api-get org-context-clock-access-api-name :dyntaskplprint))

;; deprecated
(defvar org-context-clock-api-dyntaskpls-associated-to-context (org-context-clock-access-api-get org-context-clock-access-api-name :dyntaskpls))
(defvar org-context-clock-api-tasks-associated-to-context      (org-context-clock-access-api-get org-context-clock-access-api-name :tasks))
(defvar org-context-clock-build-dyntaskpl                      (org-context-clock-access-api-get org-context-clock-access-api-name :dyntaskpl))
(defvar org-context-clock-matching-dyntaskpls                  (org-context-clock-access-api-get org-context-clock-access-api-name :dyntaskpls))
(defvar org-context-clock-matching-tasks                       (org-context-clock-access-api-get org-context-clock-access-api-name :tasks))
(defvar org-context-clock-api-task-associated-to-context-p     (org-context-clock-assoc-api-get  org-context-clock-assoc-api-name :taskp))
(defvar org-context-clock-api-task-update-tasks                (org-context-clock-access-api-get org-context-clock-access-api-name :update))
(defvar org-context-clock-api-task-update-files                (org-context-clock-access-api-get org-context-clock-access-api-name :files))
;; Global variables:1 ends here

;; Simple function


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Simple%20function][Simple function:1]]
(defun custom-plist-keys (in-plist)
  (if (null in-plist)
      in-plist
      (cons (car in-plist) (custom-plist-keys (cddr in-plist)))))
;; Simple function:1 ends here

;; Disable for some time

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Disable%20for%20some%20time][Disable for some time:1]]
(defun org-context-clock-disable-for (time)
  "Disable context clocking for TIME period."
  ;; Implement
  )
;; Disable for some time:1 ends here

;; Context clock API


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Context%20clock%20API][Context clock API:1]]
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
         (org-context-clock-access-api-get org-context-clock-access-api-name :dyntaskplprint)
         (org-context-clock-access-api-get org-context-clock-access-api-name :dyntaskpl)
         (org-context-clock-access-api-get org-context-clock-access-api-name :dyntaskpls)
         (org-context-clock-access-api-get org-context-clock-access-api-name :tasks)
         (org-context-clock-assoc-api-get org-context-clock-assoc-api-name :taskp)
         (org-context-clock-access-api-get org-context-clock-access-api-name :update))
        (setq
         org-context-clock-api-dyntaskpl-print                  (org-context-clock-access-api-get org-context-clock-access-api-name :dyntaskplprint)

         ;; deprecated
         org-context-clock-api-dyntaskpls-associated-to-context (org-context-clock-access-api-get org-context-clock-access-api-name :dyntaskpls)
         org-context-clock-api-tasks-associated-to-context      (org-context-clock-access-api-get org-context-clock-access-api-name :tasks)
         org-context-clock-build-dyntaskpl                      (org-context-clock-access-api-get org-context-clock-access-api-name :dyntaskpl)
         org-context-clock-matching-dyntaskpls                  (org-context-clock-access-api-get org-context-clock-access-api-name :dyntaskpls)
         org-context-clock-matching-tasks                       (org-context-clock-access-api-get org-context-clock-access-api-name :tasks)
         org-context-clock-api-task-associated-to-context-p     (org-context-clock-assoc-api-get org-context-clock-assoc-api-name :taskp)
         org-context-clock-api-task-update-tasks                (org-context-clock-access-api-get org-context-clock-access-api-name :update)))))
;; Context clock API:1 ends here

;; Update tasks


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Update%20tasks][Update tasks:1]]
;;;###autoload
(defun org-context-clock-task-update-tasks (&optional force)
  "Update task infos"
  (interactive "P")
  (message "calling org-context-clock-task-update-tasks")
  (funcall org-context-clock-api-task-update-tasks force))

;;;###autoload
(defun org-context-clock-task-update-files (&optional force)
  "Update task infos"
  (interactive "P")
  (funcall org-context-clock-api-task-update-files force))

(defun org-context-clock-build-tasks (file)
  (when (member*
              file
              (org-context-clock-task-update-files)
              :test #'(lambda (f1 f2)
                        (string-equal
                         (file-truename f1)
                         (file-truename f2))))
    (org-context-clock-task-update-tasks t)))

(defun org-context-clock-after-save-hook ()
  (when (and (eq major-mode 'org-mode)
             (buffer-file-name))
    (org-context-clock-build-tasks (buffer-file-name))))
;; Update tasks:1 ends here

;; Build context


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Build%20context][Build context:1]]
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
         (buf (org-base-buffer buf))
         (file (buffer-file-name buff))
         (context (list :file file :buffer buff)))
    context))
;; Build context:1 ends here

;; Unnamed task related global variable

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Unnamed%20task%20related%20global%20variable][Unnamed task related global variable:1]]
(defvar *org-context-clock-unassociate-context-start-time* nil)
(defvar *org-context-clock-swapen-unnamed-threashold-interval* (* 60 2)) ;2 mins
;; Unnamed task related global variable:1 ends here

;; Unnamed task functions

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Unnamed%20task%20functions][Unnamed task functions:1]]
(defun org-context-clock-unassociate-context-start-time-reset ()
  (setq *org-context-clock-unassociate-context-start-time* nil))

(defun org-context-clock-can-create-unnamed-task-p ()
  (unless *org-context-clock-unassociate-context-start-time*
    (setq *org-context-clock-unassociate-context-start-time* (current-time)))
  (let ((unassociate-context-start-time *org-context-clock-unassociate-context-start-time*))
    (prog1
        (>
         (float-time (time-since unassociate-context-start-time))
         *org-context-clock-swapen-unnamed-threashold-interval*))))

(defun org-clock-marker-is-unnamed-clock-p (&optional clock)
  (let ((clock (or clock org-clock-marker)))
    (when (and
           clock
           (lotus-org-unnamed-task-clock-marker))
     (equal
      (marker-buffer org-clock-marker)
      ;; id:x11 make org-context-clock version
      (marker-buffer (lotus-org-unnamed-task-clock-marker))))))

(defun org-context-clock-maybe-create-clockedin-unnamed-heading ()
  (when (org-context-clock-can-create-unnamed-task-p)
    (let ((org-log-note-clock-out nil))
      (if (org-clock-marker-is-unnamed-clock-p)
          (org-context-clock-debug :debug "org-context-clock-maybe-create-unnamed-task: Already clockin unnamed task")
          (prog1
              (lotus-org-create-unnamed-task-task-clock-in)
            (org-context-clock-unassociate-context-start-time-reset))))))

(defun org-context-clock-maybe-create-unnamed-heading ()
  (when (org-context-clock-can-create-unnamed-task-p)
    (let ((org-log-note-clock-out nil))
      (if (org-clock-marker-is-unnamed-clock-p)
          (org-context-clock-debug :debug "org-context-clock-maybe-create-unnamed-task: Already clockin unnamed task")
          (cdr (lotus-org-create-unnamed-task))))))


(defun org-context-clock-maybe-create-unnamed-task ()
  ;; back
  (let* ((unnamed-heading-marker
         (cdr (lotus-org-create-unnamed-task)))
        (unnamed-task
         (when unnamed-heading-marker
           (with-current-buffer (marker-buffer unnamed-heading-marker)
             (goto-char unnamed-heading-marker)
             (org-context-clock-collect-task)))))
    unnamed-task))

(defun org-context-clock-maybe-create-unnamed-dyntaskpl (context)
  ;; back
  (let* ((unnamed-task
         (org-context-clock-maybe-create-unnamed-task))
        (unnamed-dyntaskpl
         (if unnamed-task
           (org-context-clock-build-dyntaskpl unnamed-task context))))
    unnamed-dyntaskpl))

(defun org-context-clock-maybe-create-clockedin-unnamed-dyntaskpl (context)
  ;; back
  (when (org-context-clock-can-create-unnamed-task-p)
    (let ((org-log-note-clock-out nil))
      (if (org-clock-marker-is-unnamed-clock-p)
          (org-context-clock-debug :debug "org-context-clock-maybe-create-unnamed-task: Already clockin unnamed task")
          (let* ((unnamed-dyntaskpl (org-context-clock-maybe-create-unnamed-dyntaskpl context))
                 (unnamed-task (plist-get unnamed-dyntaskpl :task))
                 (unnamed-marker (plist-get unnamed-task :task-clock-marker)))
            (prog1
                (org-context-clock-clockin-dyntaskpl unnamed-dyntaskpl)
              ;; id:x11 make org-context-clock version
              (lotus-org-unnamed-task-clock-marker unnamed-marker)
              (message "clockin to unnnamed task.")
              (org-context-clock-unassociate-context-start-time-reset)))))))

(defun org-context-clock-changable-p ()
  "Stay with a clock at least 2 mins."
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
;; Unnamed task functions:1 ends here

;; Main context clock function update-current-context

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Main%20context%20clock%20function%20update-current-context][Main context clock function update-current-context:1]]
;;;###autoload
(defun org-context-clock-update-current-context (&optional force)
  (interactive "P")
  (if (>
       (float-time (time-since *org-context-clock-last-buffer-select-time*))
       *org-context-clock-task-current-context-time-interval*)
      (let* ((context (org-context-clock-build-context))
             (buff    (plist-get context :buffer)))
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
              (if (and
                   (not (org-clock-marker-is-unnamed-clock-p))
                   (> (org-context-clock-current-task-associated-to-context-p context) 0))
                  (progn
                    (org-context-clock-debug :debug "org-context-clock-update-current-context: Current task already associate to %s" context))
                  (progn                ;current clock is not matching
                    (org-context-clock-debug :debug "org-context-clock-update-current-context: Now really going to clock.")
                    (unless (org-context-clock-dyntaskpl-run-associated-dyntaskpl context)
                      ;; not able to find associated, or intentionally not selecting a clock
                      (org-context-clock-debug :debug "trying to create unnamed task.")
                      (org-context-clock-maybe-create-clockedin-unnamed-dyntaskpl context))
                    (org-context-clock-debug :debug "org-context-clock-update-current-context: Now really clock done."))))

            (org-context-clock-debug :debug "org-context-clock-update-current-context: context %s not suitable to associate" context)))
      (org-context-clock-debug :debug "org-context-clock-update-current-context: not enough time passed.")))


(defun org-context-clock-update-current-context-x (force)
  (interactive "P")
  (if t
      (let* ((context (org-context-clock-build-context)))
        (unless nil
          (setq
           *org-context-clock-task-previous-context* *org-context-clock-task-current-context*
           *org-context-clock-task-current-context*  context)

          (unless (and
                   (not (org-clock-marker-is-unnamed-clock-p))
                   (> (org-context-clock-current-task-associated-to-context-p context) 0))
            (unless (org-context-clock-dyntaskpl-run-associated-dyntaskpl context)
              (org-context-clock-debug :debug "trying to create unnamed task.")
              ;; not able to find associated, or intentionally not selecting a clock
              (org-context-clock-maybe-create-clockedin-unnamed-dyntaskpl context)))))))
;; Main context clock function update-current-context:1 ends here

;; Create task info out of current clock
;; When org-clock-marker was hidden that time (org-context-clock-collect-task) not able to
;; collect correct task, so here cloned buffer need to be created.
;; see here[[https://emacs.stackexchange.com/questions/9530/how-can-i-get-an-org-mode-outline-in-a-2nd-buffer-as-a-dynamic-table-of-contents][ How can I get an org-mode outline in a 2nd buffer as a dynamic table of contents?]]


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Create%20task%20info%20out%20of%20current%20clock][Create task info out of current clock:1]]
;;;###autoload
(defun org-context-clock-task-current-task ()
  (when (and
         org-clock-marker
         (markerp org-clock-marker)
         (> (marker-position-nonil org-clock-marker) 0))
    (org-with-cloned-marker org-clock-marker "<tree>"
      (let ((view-read-only nil)
            (buffer-read-only t))
        (read-only-mode)
        (org-previous-visible-heading 1)
        (let ((info (org-context-clock-collect-task)))
          info)))))
;; Create task info out of current clock:1 ends here

;; Test if TASK is associate to CONTEXT

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Test%20if%20TASK%20is%20associate%20to%20CONTEXT][Test if TASK is associate to CONTEXT:1]]
(defun org-context-clock-task-associated-to-context-p (task context)
  (if task
      (funcall org-context-clock-api-task-associated-to-context-p task context)
      0))
;; Test if TASK is associate to CONTEXT:1 ends here

;; Collect and return task matching to CONTEXT

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Collect%20and%20return%20task%20matching%20to%20CONTEXT][Collect and return task matching to CONTEXT:1]]
;;;###autoload
(defun org-context-clock-current-task-associated-to-context-p (context)
  (let ((task (org-context-clock-task-current-task)))
    (org-context-clock-task-associated-to-context-p task context)))
;; Collect and return task matching to CONTEXT:1 ends here

;; TODO add org-insert-log-not

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*add%20org-insert-log-not][add org-insert-log-not:1]]
(defun org-context-clock-clockin-dyntaskpl (new-dyntaskpl)
  ;;TODO add org-insert-log-not
  (org-context-clock-debug :debug "org-context-clock-clockin-marker %s" new-dyntaskpl)
  (let* (retval
         (old-dyntaskpl (car *org-context-clock-clocked-dyntaskpl-context-history*))
         (old-task    (plist-get old-dyntaskpl :task))
         (old-marker  (or (if old-task (plist-get old-task :task-clock-marker)) org-clock-hd-marker))
         (old-heading (if old-task (plist-get old-task :task-clock-heading)))
         (new-task    (plist-get new-dyntaskpl :task))
         (new-marker  (if new-task (plist-get new-task :task-clock-marker)))
         (new-heading (if new-task (plist-get new-task :task-clock-heading))))
  (when (and
         new-marker
         (marker-buffer new-marker))

    (let* ((org-log-note-clock-out nil)
           (old-marker org-clock-marker)
           (old-buff   (marker-buffer old-marker)))

      (org-context-clock-debug :debug "clocking in %s" new-marker)

      (let ((old-buff-read-only
             (if old-buff
                 (with-current-buffer (marker-buffer old-marker)
                   buffer-read-only))))

        (if old-buff
            (with-current-buffer old-buff
              (setq buffer-read-only nil)))

        (setq *org-context-clock-update-current-context-msg* old-marker)

        (when (and
               new-heading
               old-marker
               (marker-buffer old-marker))
          (org-insert-log-note old-marker (format "clocking out to clockin to <%s>" new-heading)))

        (with-current-buffer (marker-buffer new-marker)
          (let ((buffer-read-only nil))
            (when old-heading
              (org-insert-log-note new-marker (format "clocking in to here from last clock <%s>" old-heading)))
            (condition-case err
                (progn
                  (org-clock-clock-in (list new-marker))
                  (setq retval t)
                  (push new-dyntaskpl *org-context-clock-clocked-dyntaskpl-context-history*))
              ((error)
               (progn
                 (setq retval nil)
                 (signal (car err) (cdr err)))))))
        (if old-buff
            (with-current-buffer old-buff
              (setq buffer-read-only old-buff-read-only)))
        retval)))))
;; add org-insert-log-not:1 ends here

;; Clock-into one of associated tasks

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*Clock-into%20one%20of%20associated%20tasks][Clock-into one of associated tasks:1]]
;;;###autoload
(defun org-context-clock-dyntaskpl-run-associated-dyntaskpl (context)
  "marker and ranked version"
  (interactive
   (list (org-context-clock-build-context)))
  (progn
    (let* ((context (or context (org-context-clock-build-context)))
           (matched-dyntaskpls
            (remove-if-not
             #'(lambda (dyntaskpl)
                 (and
                  (plist-get dyntaskpl :marker)
                  (marker-buffer (plist-get dyntaskpl :marker))))
             (org-context-clock-dyntaskpls-associated-to-context-filtered context))))
      (if matched-dyntaskpls
          (let* ((sel-dyntaskpl
                  (if (> (length matched-dyntaskpls) 1)
                      (sacha/helm-select-dyntaskpl-timed matched-dyntaskpls)
                      (car matched-dyntaskpls)))
                 ;; (sel-task   (if sel-dyntaskpl (plist-get sel-dyntaskpl :task)))
                 ;; (sel-marker (if sel-task      (plist-get sel-task      :task-clock-marker)))
                 )
            ;; (org-context-clock-message 6 "sel-dyntaskpl %s sel-task %s sel-marker %s" sel-dyntaskpl sel-task sel-marker)
            (if sel-dyntaskpl (org-context-clock-clockin-dyntaskpl sel-dyntaskpl)))
          (progn
            ;; here create unnamed task, no need
            (setq *org-context-clock-update-current-context-msg* "null clock")
            (org-context-clock-message 6
                                       "No clock found please set a match for this context %s, add it using M-x org-context-clock-add-context-to-org-heading."
                                       context)
            (org-context-clock-add-context-to-org-heading-when-idle context 7)
            nil)))))

(when nil                               ;testing
  (sacha/helm-select-dyntaskpl-timed
   (remove-if-not
    #'(lambda (dyntaskpl)
        (and
         (plist-get dyntaskpl :marker)
         (marker-buffer (plist-get dyntaskpl :marker))))
    (org-context-clock-dyntaskpls-associated-to-context-filtered (org-context-clock-build-context))))
  )
;; Clock-into one of associated tasks:1 ends here

;; function to setup context clock timer


;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*function%20to%20setup%20context%20clock%20timer][function to setup context clock timer:1]]
;;;###autoload
(defun org-context-clock-run-task-current-context-timer ()
  (interactive)
  (progn
  (setq *org-context-clock-last-buffer-select-time* (current-time))
    (when *org-context-clock-buffer-select-timer*
      (cancel-timer *org-context-clock-buffer-select-timer*)
      (setq *org-context-clock-buffer-select-timer* nil))
    (setq *org-context-clock-buffer-select-timer*
          ;; distrubing while editing.
          ;; run-with-timer
          (run-with-idle-timer
          (1+ *org-context-clock-task-current-context-time-interval*)
          nil
          'org-context-clock-update-current-context))))
;; function to setup context clock timer:1 ends here

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*function%20to%20setup%20context%20clock%20timer][function to setup context clock timer:2]]
(defun sacha-org-context-clock-selection-line (marker)
    "Insert a line for the clock selection menu.
And return a cons cell with the selection character integer and the marker
pointing to it."
    (when (marker-buffer marker)
      (with-current-buffer (org-base-buffer (marker-buffer marker))
        (org-with-wide-buffer
         (progn ;; ignore-errors
           (goto-char marker)
           (let* ((cat (org-get-category))
                  (heading (org-get-heading 'notags))
                  (prefix (save-excursion
                            (org-back-to-heading t)
                            (looking-at org-outline-regexp)
                            (match-string 0)))
                  (task (substring
                         (org-fontify-like-in-org-mode
                          (concat prefix heading)
                          org-odd-levels-only)
                         (length prefix))))
             (when task ;; (and cat task)
               ;; (insert (format "[%c] %-12s  %s\n" i cat task))
               ;; marker
               (cons task marker))))))))

   (defun sacha-org-context-clock-dyntaskpl-selection-line (dyntaskpl)
    "Insert a line for the clock selection menu.
And return a cons cell with the selection character integer and the marker
pointing to it."
    (let ((marker (plist-get dyntaskpl :marker))
          (rank   (plist-get dyntaskpl :rank)))
      (when (marker-buffer marker)
        (with-current-buffer (org-base-buffer (marker-buffer marker))
          (org-with-wide-buffer
           (progn ;; ignore-errors
             (goto-char marker)
             (let* ((cat (org-get-category))
                    (heading (org-get-heading 'notags))
                    (prefix (save-excursion
                              (org-back-to-heading t)
                              (looking-at org-outline-regexp)
                              (match-string 0)))
                    (task (substring
                           (org-fontify-like-in-org-mode
                            (concat prefix heading)
                            org-odd-levels-only)
                           (length prefix))))
               (when task ;; (and cat task)
                 ;; (insert (format "[%c] %-12s  %s\n" i cat task))
                 ;; marker
                 (cons (org-context-clock-dyntaskpl-print dyntaskpl task) dyntaskpl)))))))))


(defun sacha-org-context-clock-dyntaskpl-selection-line (dyntaskpl)
    "Insert a line for the clock selection menu.
And return a cons cell with the selection character integer and the marker
pointing to it."
    (cons (org-context-clock-dyntaskpl-print dyntaskpl nil) dyntaskpl))
;; function to setup context clock timer:2 ends here

;; [[file:~/.repos/git/main/resource/userorg/main/readwrite/public/user/rc/xemacs/elpa/pkgs/org-context-clock/org-context-clock.org::*function%20to%20setup%20context%20clock%20timer][function to setup context clock timer:3]]
;; rank based
  (defun sacha/helm-select-dyntaskpl (dyntaskpls)
    ;; (org-context-clock-debug :debug "sacha marker %s" (car dyntaskpls))
    (helm
     (list
      (helm-build-sync-source "Select matching tasks"
        :candidates (mapcar 'sacha-org-context-clock-dyntaskpl-selection-line dyntaskpls)
        :action (list ;; (cons "Select" 'identity)
                 (cons "Clock in and track" #'identity))
        :history 'org-refile-history)
      ;; (helm-build-dummy-source "Create task"
      ;;   :action (helm-make-actions
      ;;            "Create task"
      ;;            'sacha/helm-org-create-task))
      )))

  (defun sacha/helm-select-dyntaskpl-timed (dyntaskpls)
    (helm-timed 7
      (message "running sacha/helm-select-clock")
      (sacha/helm-select-dyntaskpl dyntaskpls)))

  (defun sacha/helm-dyntaskpl-action (dyntaskpls clockin-fn)
    ;; (message "sacha marker %s" (car dyntaskpls))
    ;; (setq sacha/helm-org-refile-locations tbl)
    (progn
      (helm
       (list
        (helm-build-sync-source "Select matching tasks"
          :candidates (mapcar 'sacha-org-context-clock-dyntaskpl-selection-line dyntaskpls)
          :action (list ;; (cons "Select" 'identity)
                        (cons "Clock in and track" #'(lambda (c) (funcall clockin-fn c))))
          :history 'org-refile-history)
        ;; (helm-build-dummy-source "Create task"
        ;;   :action (helm-make-actions
        ;;            "Create task"
        ;;            'sacha/helm-org-create-task))
        ))))



;; org-context-clock-dyntaskpl-run-associated-dyntaskpl

;; (sacha/helm-clock-action (org-context-clock-markers-associated-to-context (org-context-clock-build-context)) #'org-context-clock-clockin-marker)
;; (sacha/helm-select-clock (org-context-clock-markers-associated-to-context (org-context-clock-build-context)))
;; (sacha/helm-clock-action (org-context-clock-markers-associated-to-context (org-context-clock-build-context (find-file-noselect "~/.xemacs/elpa/pkgs/org-context-clock/org-context-clock.el"))))
;; function to setup context clock timer:3 ends here
