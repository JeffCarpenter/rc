;; -*-lisp-*-
;;
;; Copyright 2009 Sharad Pratap
;;
;; Maintainer: Sharad Pratap
;;
;; This file is part of stumpwm.
;;
;; stumpwm is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; stumpwm is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this software; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 59 Temple Place, Suite 330,
;; Boston, MA 02111-1307 USA


;; make its own package.
;;; {{{
;; (defpackage :stumpwm.contrib.mem
;;   (:use :common-lisp :stumpwm :cl-ppcre))

;; (in-package :stumpwm.contrib.mem)


;; (defpackage :stumpwm.contrib.battery-portable
;;   (:use :common-lisp :stumpwm :cl-ppcre)
;;   (:export #:*refresh-time*
;;            #:*prefer-sysfs*
;;            ))
;; (in-package :stumpwm.contrib.battery-portable)

;; (defpackage :stumpwm.contrib.net
;;   (:use :common-lisp :stumpwm :cl-ppcre)
;;   (:export #:*net-device*))

;; (in-package :stumpwm.contrib.net)

;; (defpackage :stumpwm.contrib.wifi
;;   (:use :common-lisp :stumpwm )
;;   (:export #:*iwconfig-path*
;;            #:*wireless-device*))
;; (in-package :stumpwm.contrib.wifi)
;;; }}}


;; (defpackage :stumpwm.pa
;;   (:use :common-lisp :stumpwm :cl-ppcre)
;;   ;(:export #:*net-device*)
;;   )
;; (in-package :stumpwm.pa)

(in-package :stumpwm)

;; utilities.
(defun compact (list)
  (remove-if #'null list))

(export '(*run-cli-program-hook*))

(defvar *run-cli-program-hook* '()
  "A hook called whenever run-cli-progam called, it will be supplied with cli.")



;; Basic operations
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun string-ignore= (char string1 string2)
  (apply #'string= (mapcar #'(lambda (s)
                               (remove char s))
                           (list string1 string2))))

(defun string-ignore-space= (s1 s2)
  (string-ignore= #\Space s1 s2))

(defun space-stripped (s)
  (remove #\Space s))

;; TODO:
;;    * prepare all callee's to consider nil return vaule.
(defun cli-of-pid (pid)                    ;done.
  (if pid                                  ;yes pid could be nil.
      (let* ((statfilename (concatenate 'string "/proc/" (write-to-string pid) "/cmdline"))
             (cmdline (with-open-file (clifile statfilename :if-does-not-exist nil)
                        (if clifile
                            (read-line clifile)))))
                                        ; (testr cmdline)  ; yes for some pid return vaule is nil
        (if (and cmdline
                 (stringp cmdline) (not (string-equal "" cmdline)))
            (substitute #\Space #\Null (string-trim '(#\Null) cmdline))))))

;; test
;; (string-trim '(#\Null) "sadfds sfdsf ")
;; (substitute #\Space #\Null "sfdsdf safd dsf")

(defun testr (&optional x)
  "This function is for debugging."
  (let* ((tt (type-of x))
         (ttt (if (consp tt) (car tt) tt)))
    (read-one-line (current-screen) "test: " :initial-input
                   (if x
                       (concat (symbol-name ttt) " A" (if (stringp x) x "dn") "A ")
                       "empty"))))
;; test
;; (symbol-name (car (type-of "")))
;; (testr -1)
;; (if (not (string-equal "" "")) "asfd")

(defun process-pid (process)
  #+sbcl (sb-ext:process-pid process)
  #-sbcl (error 'not-implemented))

(defun process-status (process)
  #+sbcl (sb-ext:process-status process)
  #-sbcl (error 'not-implemented))

;; (defun pid-of-win (&optional (win (current-window)))
;;   (let ((x (format nil "~d" (xproperty 'pid win))))
;;     (read-one-line (current-screen) (concat x " : "))
;;     (xproperty 'pid win)))

(defun pid-of-win (&optional (win (current-window)))
  (xproperty 'pid win))

(defcommand pid-of-window (&optional (win (current-window))) ()
  (if %interactivep%
      (message "~a" (xproperty 'pid win))
      (xproperty 'pid win)))

;; (defun set-property)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; from window.lisp
;; (defun xwin-class (win)
;;   (multiple-value-bind (res class) (xlib:get-wm-class win)
;;     (declare (ignore res))
;;     class))
;;
;; (defun xwin-res-name (win)
;;   (multiple-value-bind (res class) (xlib:get-wm-class win)
;;     (declare (ignore class))
;;     res))
;;
;; Implement (defun (setf xwin-class)
;; take help of (xlib:set-wm-class (window-xwin (current-window)) "emacs" "Semacs")
;; could be found in /usr/share/common-lisp/source/clx
;; manager.lisp:68:(defun set-wm-class (window resource-name resource-class)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (defun get-windows-if (test window-list &key key) ;; return multiple ;; Correct it.
;;   (if key
;;       (remove-if-not test window-list :key key)
;;       (remove-if-not test window-list)))

;; (get-windows #'(lambda (p) (and p (= 4267 p))) (screen-windows (current-screen)) :key #'pid-of-win)

(defun all-windows ()
  "Windows in all screens."
  (mapcan (lambda (s) (copy-list (screen-windows s))) *screen-list*))


;; (defun get-windows-from-pid (pid &optional (window-list (screen-windows (current-screen)))) ;; return multiple ;; Correct it.
;;   (if pid                               ;yes here times when pid is nil
;;       (remove-if-not #'(lambda (p) (and p (= pid p)))
;;                      window-list
;;                      :key #'pid-of-win))
;;   (progn
;;     (dformat 3 "fun: get-windows-from-pid:: pid given is nil")
;;     nil))

(defun get-windows-from-pid (pid &optional (window-list (all-windows))) ;; return multiple ;; Correct it.
  (if pid                               ;yes here times when pid is nil
      (remove-if-not #'(lambda (p) (and p (= pid p)))
                     window-list
                     :key #'pid-of-win))
  (progn
    (dformat 3 "fun: get-windows-from-pid:: pid given is nil")
    nil))

;; TEST optional form evaluated at run time.
;; (defun xx (&optional (w (screen-windows (current-screen))))
;;   w)
;; (xx)

;; (defun get-windows-from-cli (cli &optional (window-list (screen-windows (current-screen)))) ;; return multiple ;; Correct it.
;;   (remove-if-not #'(lambda (c) (and c (string-ignore-space= cli c)))
;;                  window-list
;;                  :key #'cli-of-win))

(defun get-windows-from-cli (cli &optional (window-list (all-windows))) ;; return multiple ;; Correct it.
  (remove-if-not #'(lambda (c) (and c (string-ignore-space= cli c)))
                 window-list
                 :key #'cli-of-win))

;; working.
;; (get-windows-from-cli "xterm -bg black")

;; (read-line (current-screen))

(defvar *gtd-debug-mesg* nil "Hi")

;; (read-one-line (current-screen) "sdfds: " :initial-input  "")

;; read-one-line screen prompt initial-input


(defgeneric xproperty (prop obj)
  (:documentation "Get the property of object"))

(defmethod xproperty ((prop (eql 'cli)) (window window))
  (let ((utfcli (xlib:get-property
                 (window-xwin window) :STUMPWM_WCLI)))
    (if utfcli (utf8-to-string utfcli))))

;; TODO: it return nil also. Yes do arrangement
(defmethod xproperty ((prop (eql 'pid)) (window window))
  (first (xlib:get-property
          (window-xwin window) :_NET_WM_PID)))

;; (xproperty 'cli win)
;; (xproperty 'cli (current-window))

;; (defun complete-cmdline (&optional
;;                          (getcli #'cli-of-win)
;;                          (prompt "command: " )
;;                          (initial-input "")
;;                          (windows-list (screen-windows (current-screen)))
;;                          (screen (current-screen)))
;;   (completing-read screen prompt
;;                    (remove-if #'null (mapcar getcli windows-list))
;;                    :initial-input initial-input))

(defun complete-cmdline (&optional
                         (getcli #'cli-of-win)
                         (prompt "command: " )
                         (initial-input "")
                         (windows-list (all-windows)) ;supply unassigned cmdlines.
                         (screen (current-screen)))
  (completing-read screen prompt
                   (remove-if #'null (mapcar getcli windows-list))
                   :initial-input initial-input))

(defun get-all-clis (&optional
                     (getcli #'cli-of-win)
                     (windows-list (all-windows))) ;supply unassigned cmdlines.
  (remove-if #'null (mapcar getcli windows-list)))

;; (defun choose-or-provide (choices
;;                           &key
;;                           (dialog "select: ")
;;                           (autoselect-if-only t)
;;                           (screen (current-screen))
;;                           (extra-choices `(("New" ,#'complete-cmdline)
;;                                            ("nothing" nil))))
;;   (let* ((mchoice (if (and autoselect-if-only (= (length choices) 1))
;;                       (car choices)
;;                       (select-from-menu screen
;;                                         (mapcar (lambda (x)
;;                                                   (if (symbolp x)
;;                                                       (list (symbol-name x) x)
;;                                                       x))
;;                                                 (append choices extra-choices))
;;                                         dialog)))
;;          (choice (cond ((listp mchoice) (second mchoice))
;;                        (t mchoice))))
;;     (if (functionp choice) (funcall choice) choice)))


(defun choose-or-provide (choices
                          &key
                          (dialog "select: ")
                          (autoselect-if-only t)
                          (screen (current-screen))
                          (extra-choices `(("New" ,#'complete-cmdline)
                                           ("nothing" nil))))
  (let* ((mchoice (if (and autoselect-if-only (= (length choices) 1))
                      (car choices)
                      (menu-with-timeout
                       (mapcar (lambda (x)
                                 (if (symbolp x)
                                     (list (symbol-name x) x)
                                     x))
                               (append choices extra-choices))
                       :prompt dialog :default 0)))
         (choice (cond ((listp mchoice) (second mchoice))
                       (t mchoice))))
    (if (functionp choice) (funcall choice) choice)))


(progn
  (defvar *a-mutex* (sb-thread:make-mutex :name "my lock"))

  (let (new-windows)

    ;; (defun set-new-window-before-focus (&optional window (current-window))
    ;;   (sb-ext:with-timeout 1
    ;;     (sb-thread:with-mutex (*a-mutex*) ; :value 1);  :wait-p t)
    ;;       (push window new-windows)
    ;;       (read-one-line (current-screen) "A Not able to find cli for you: " :initial-input  "")
    ;;     )))

    (defun set-new-window-before-focus (&optional window (current-window))
      (unless (xproperty 'cli window)
        (push window new-windows))
      (dformat 3 "BEFORE set-new-window-before-focus ~w~%" window))
                                        ;(read-one-line (current-screen) "A Not able to find cli for you: " :initial-input  ""))

    ;; (defun set-new-window-before-focus (current last)
    ;;   (let (window current)
    ;;       (if (find window new-windows)
    ;;           (set-window-cli window)
    ;;           (message "Not matched"))))

    ;; (defun set-new-window-after-focus (current last)
    ;;       (sb-ext:with-timeout 1
    ;;         (sb-thread:with-mutex (*a-mutex*) ; :value 1) ; :wait-p t)
    ;;           (if (find current new-windows)
    ;;               (progn
    ;;           ; (read-one-line (current-screen) "A Not able to find cli for you: " :initial-input  "")

    ;;                 (if (set-window-cli current)
    ;;                     (setf new-windows (remove current new-windows))))
    ;;                                       ;(message "Not matched")
    ;;               ))))

    (defun set-new-window-after-focus (current last)
      (if (or (when (find current new-windows)
                (setf new-windows (remove current new-windows))
                t)
              (null last))
          (set-window-cli current))
      (dformat 3 "AFTER set-new-window-after-focus ~w~%" current))

    ;; Old implementation.
    ;; (defun set-new-window (&optional (window (current-window)))
    ;;   (set-window-cli window))


    ;; (let (x)
    ;;   (push 1 x)
    ;;   (push 2 x)
    ;;   x)

                                        ; (find  (current-window) (screen-windows (current-screen)))

    (if t ;(boundp 'debug)

        ;; In ideal case these two will not be required, as above two
        ;; function will always take care of new-windows

        (defcommand show/new-windows-for-focus () ()
          (if new-windows
              (message "~{~w~%~}" new-windows)
              (message "No windows for focus.")))

        (defcommand clear/new-windows-for-focus () ()
          (setf new-windows nil))))

  (progn
    (setf *new-window-hook* nil
          *focus-window-hook* nil)
    (add-hook *new-window-hook* #'set-new-window-before-focus)
    (add-hook *focus-window-hook* #'set-new-window-after-focus)
    )

  (defcommand run-cli-command (cmd) ((:shell "program: "))
    "Run the specified shell command. If @var{collect-output-p} is @code{T}
then run the command synchonously and collect the output. Be
careful. If the shell command doesn't return, it will hang StumpWM. In
such a case, kill the shell command to resume StumpWM."
    (let* ((cmdlist (cl-ppcre:split " " cmd)))
      (run-prog (first cmdlist)
                :args (rest cmdlist)
                :wait nil
                :search (getenv "PATH"))))

  (let (unassigned-cmdlines) ;Command line that have not assigned
    (defcommand run-wcli-command (cmd &optional background) ((:shell "program: "))
      "Run the specified shell command. If @var{collect-output-p} is @code{T}
then run the command synchonously and collect the output. Be
careful. If the shell command doesn't return, it will hang StumpWM. In
such a case, kill the shell command to resume StumpWM."
      (let* ((cmdlist (cl-ppcre:split " " cmd))
             (unassigned-cmdlines-filtered
              (remove-if-not #'stringp unassigned-cmdlines))
              ;((cmdlist (cl-ppcre:split "(\w*): ?("?[\w\s\.]*"?)\s|(\w*): ?("?[\w\s\.]*"?)|("[\w\s]*")|([\w]+)" cmd))
             (window-list (get-windows-from-cli cmd))
             (current-group (current-group))
             cli-pid)

        (cond
          (window-list
           (progn
             (message "~{~%~a~}" (mapcar #'cli-of-win window-list))        ;; correct it.
             (mapcar (lambda (w)
                       (move-window-to-group w current-group)
                       ;;(tag-window tag w)
                       ) ;; remember window in group
                     window-list)
             (unless background
               (move-window-to-head (current-group) (first window-list))
               (really-raise-window (first window-list)))))
          ((find cmd
                 unassigned-cmdlines-filtered
                 :test #'string-ignore-space=)
           (message (concat "Cool! I am also waiting for " cmd)))
          (t (setf cli-pid
                   (run-prog (first cmdlist)
                             :args (rest cmdlist)
                             :wait nil
                             :search (getenv "PATH")))
             (push cmd unassigned-cmdlines)))

        (if (or cli-pid window-list)
            (run-hook-with-args *run-cli-program-hook* cmd))
        cli-pid))

    ;; Question left
    ;; When simulteniously more than one clis present in the
    ;; unassigned-cmdlines than it, do not able to find foundcli, find
    ;; the solution for it.

    ;; TODO:
    ;; Add support for %interactivep%
    ;; Add support for transposing other window or windows' group's cli with current window
    (defun set-window-cli (&optional (window (current-window)))          ;work on it.
      "It is new-window-hook Set cli property of window."
      (let* (;; mesg                          ;initialize with nil
             (win-pid (pid-of-win window))  ;remember donot go for cli-of-win
             (cli (cli-of-pid win-pid))
             (unassigned-cmdlines-filtered
              (remove-if-not #'stringp unassigned-cmdlines))

             ;;(windows-list (screen-windows (current-screen))) ;here are window existing in other screens also, resolve it.
             (windows-list (all-windows))
             (clis-of-other-windows-of-win-pid
              (remove-duplicates
               (compact
                (mapcar #'(lambda (win)
                            (let ((wcli (xproperty 'cli win)))
                              (if wcli
                                        ; (concat (window-name win) ": " wcli)
                                  (list (concat (window-name win) ": " wcli) wcli))))
                        (remove window (get-windows-from-pid win-pid windows-list))))
               :test #'string-ignore-space=))

             (foundcli (if unassigned-cmdlines-filtered
                           (or (if cli
                                   (find cli  ;yes found cli in win and list same
                                         unassigned-cmdlines-filtered
                                         :test #'string-ignore-space=))
                               (if (= (length unassigned-cmdlines-filtered) 1) ;list length is one
                                   (car unassigned-cmdlines-filtered)
                                   (choose-or-provide (append clis-of-other-windows-of-win-pid unassigned-cmdlines)
                                                      :dialog "1. Which command created this window ?: ")))

                           (when clis-of-other-windows-of-win-pid
                             (choose-or-provide clis-of-other-windows-of-win-pid
                                                :dialog "2. Which command created this window ?: "))
                           )))

        (if foundcli                      ;what if foundcli is nil
            (let ((cliprop (xproperty 'cli window)))
              (message (setf *gtd-debug-mesg* (format nil "~% cli searched ~a" foundcli))) ; add into debugging.

              (setf (cli-of-win window) foundcli     ;will not set into winprop if
                                        ;it comes from find
                                        ;No need of unset-window-cli, we are clearing unassigned-cmdlines here only.
                    unassigned-cmdlines
                    (if cliprop
                        (substitute cliprop foundcli unassigned-cmdlines :test #'string-ignore-space=)
                        (delete foundcli ;not working find reason.
                                unassigned-cmdlines
                                :test #'string-ignore-space=)))
              foundcli)                   ;pass
            (progn                        ;fail
                                        ;(read-one-line (current-screen) "Not able to find cli for you: " :initial-input  "")
              (message "Not able to find any cli for you")
              nil)
            )))

    (defcommand show/unassigned-cmlines () ()
      (if unassigned-cmdlines
          (message "~{~a~%~}" unassigned-cmdlines)
          (message "No unassigned cmdlines")))

    (defcommand clear/unassigned-cmlines () ()
      (setf unassigned-cmdlines nil))

    (defcommand test/choose-or-provide-on-unassigned-cmdlines () ()
      (choose-or-provide unassigned-cmdlines :dialog "Test: "))

    (defcommand reassign-cli (window) ((:shell "program: "))
      "dddd"
      (let* ((opt (choose-or-provide '(both unassigned-cmdlines wincmd)
                                     :dialog "sel: "
                                     :extra-choices nil))
             (cmdlist ()))
        )
      (if unassigned-cmdlines
          (choose-or-provide :dialog "2. Which command created this window ?: ")
          )
      )
    ))
;;sharad

;; (type-of
;; (choose-or-provide *unassigned-cmdlines* "Which command created this window: ")
;; )

(defun pull-group-tag (current last)
  "Recall all windows in group."
  (let ((tag (remove #\Space (group-name current))))
    (pull-tag tag)))

;; (add-hook *focus-group-hook* #'pull-group-tag)

;; (add-hook *focus-window-hook* #'(lambda (win1 win2)
;;                                   (tag-window (remove #\Space (group-name (current-group))) win1)))

(defcommand gtd-gmove-with-window () ()
  (gmove)
  (tag-window
   (remove #\Space (group-name (current-group)))
   (current-window)))

(defcommand get-match () ()
  (do* ((c #\a (read-one-char (current-screen)))
        (ar "" (concatenate 'string ar (list c))))
       ((char= c #\Return) ar)
    (message-no-timeout "~a" (format nil "~a~^~a~^~a" ar ar ar))))

(defcommand remove-window () ()
  (clear-tags (space-stripped (group-name (current-group))))
  (push-window))

(defcommand cli-of-win (&optional (win (current-window))) ()
  "Show window tags"
  (let* ((window-cli
          (or (xproperty 'cli win) ;it must have priority
              (cli-of-pid (pid-of-win win)))))
    (if %interactivep%
        (let ((new-supplied-window-cli
               (complete-cmdline #'cli-of-win
                                 (if window-cli
                                     "wincli: "
                                     "NULL wincli is here, provide new wincli: ")
                                 (if window-cli window-cli ""))))
          (when new-supplied-window-cli
            (setf (cli-of-win win) new-supplied-window-cli)))
        window-cli)))

(defun (setf cli-of-win) (cli-string &optional (win (current-window)))
  "Set the window tag set for a window"

  (let ((cli-string (if cli-string (string-trim '(#\Space #\Tab #\Newline) cli-string)))
        (cli-pid (cli-of-pid (pid-of-win win)))
        (cli-win (cli-of-win win)))
    (if (and
         cli-string (stringp cli-string)
         cli-pid    (stringp cli-pid)
         (string-ignore-space= cli-string cli-pid)
         (string-ignore-space= cli-string cli-win))
        cli-string
        (xlib:change-property (window-xwin win)
                              :STUMPWM_WCLI
                              (string-to-utf8 cli-string)
                              :UTF8_STRING 8))))


(defcommand disappear-window (&optional (win (current-window))) ()
  (move-window-to-group win
                        (find-group (current-screen) ".hold")))



