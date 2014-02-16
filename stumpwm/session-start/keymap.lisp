;; -*-lisp-*-
;;

(in-package :stumpwm)

(defmacro set-key (map mapping)
  `(loop for pair in ,mapping
      do (if (consp pair)
             (if (null (second pair))
                 (throw 'stumpwm::error "Abort.")
                 (define-key ,map (kbd (first pair)) (second pair)))
             (undefine-key pair))))

; (documentation 'getf 'function)

;; (defmacro setkey (map :rest mapping)
;;   `(labels ((pair (list)
;;               (let ((f (car list))
;;                     (s (cadr list))
;;                     (left (cddr list)))
;;                 (if s
;;                     (define-key ,map (kbd f) s)
;;                     (undefine-key f))
;;                 )))
;;      (pair ,mapping)))



;; (macroexpand-1 (sdefine-key *root-map* (("@" "eval"))))
;; (macroexpand-1 '(setkey *root-map* "@" "eval"))

;; (set-key *gcal-map*
;;          (("w" "gcal-week")
;;           ("m" "gcal-month")
;;           ("a" "gcal-add-event")
;;           ("s" "gcal-search")))

;; (setkey *gcal-map*
;;          "w" "gcal-week"
;;          "m" "gcal-month"
;;          "a" "gcal-add-event"
;;          "s" "gcal-search")




;; Top map
;;{{{ Prefix Key
;; change the prefix key to something else
;; (set-prefix-key (kbd "C-`"))
(set-prefix-key (kbd "C-quoteleft"))
(setf *mouse-focus-policy* :ignore)
;;When not in Stumpwm mode, we want Insert to be bound to enter Stumpwm mode
(define-key *top-map* (kbd "Menu") '*root-map*)
;;When in Stumpwm mode, act like hitting the prefix again would.
(define-key *root-map* (kbd "Menu") "next")
(define-key *root-map* (kbd "]") "next")
(define-key *root-map* (kbd "[") "prev")
;;}}}

;;{{ When Other profile came in

(let ((escape-keystring (print-key *escape-key*))
      (escape-keystring-with-meta (cl-ppcre:regex-replace-all "C" (print-key *escape-key*) "M")))
  (unless (string= escape-keystring escape-keystring-with-meta)
    (define-key *top-map* (kbd escape-keystring-with-meta) "gobackmyp")))

;; TODO: make list of action also possible
;; (define-key *top-map* (kbd "M-`") '("set-profile myprofile"))
;;}}


;;Top map-----------------------------------------------------------------------
(define-key *top-map* (kbd "XF86Video") "mpd-connect")
(define-key *top-map* (kbd "XF86AudioPause") "mpd-toggle-pause")
(define-key *top-map* (kbd "XF86AudioStop") "mpd-stop")
(define-key *top-map* (kbd "XF86AudioNext") "mpd-next")
(define-key *top-map* (kbd "XF86AudioPrev") "mpd-prev")
(define-key *top-map* (kbd "XF86AudioPlay") "mpd-play")

;;Root map --------------------------------------------------------------------
(define-key *root-map* (kbd "SPC") "scratchpad")
;;Terminals
; (define-key *root-map* (kbd "c") "urxvt")
; (define-key *root-map* (kbd "/") "xscreen")
;; (define-key *root-map* (kbd "C") "mrxvt")
(define-key *root-map* (kbd "&") "screen-to")
;;Applications
(define-key *root-map* (kbd "E") "ebib")
(define-key *root-map* (kbd "e") "emacsclient")
(define-key *root-map* (kbd "C-e") "emacsclient")
;; (define-key *root-map* (kbd "m") "conkeror")
(define-key *root-map* (kbd "m") "xbrowser")
;; (define-key *root-map* (kbd "i") "inkscape") ;; ??
;; (define-key *root-map* (kbd "M") "mutt") ;; -- I am able to read through Gnus
;; (define-key *root-map* (kbd "l") "slrn") ;; -- I am able to read through Gnus
;; (define-key *root-map* (kbd "g") "gimp")

;; Controls
(define-key *root-map* (kbd "T") "toggle-touchpad")
(define-key *root-map* (kbd "I") "show-window-properties")
(define-key *root-map* (kbd "S-r") "repack-window-number")
(define-key *root-map* (kbd ")") '*mpd-map*)
;; (define-key *root-map* (kbd "x") "exec xlock")
(define-key *root-map* (kbd "x") "exec xautolock -locknow")

;;Screen management
(define-key *root-map* (kbd "*") "snext")
(define-key *root-map* (kbd "ugrave") "sprev")

;;Window Management
(define-key *root-map* (kbd "eacute") "mark")
(define-key *root-map* (kbd "=") "balance-frames")
(define-key *root-map* (kbd "C-=") "next-in-frame")
(define-key *root-map* (kbd "C-p") "prev-in-frame")
(define-key *root-map* (kbd "n") "pull-hidden-next")
(define-key *root-map* (kbd "p") "pull-hidden-previous")
(define-key *root-map* (kbd "C-SPC") "pull-hidden-other")
(define-key *root-map* (kbd "M-=") "next")
(define-key *root-map* (kbd "M-p") "prev")
(define-key *root-map* (kbd "M-w") "windows")
(define-key *root-map* (kbd "k") "delete")
(define-key *root-map* (kbd "K") "kill")
(define-key *root-map* (kbd "b") "banish")
(define-key *root-map* (kbd "P") "show-pointer")
(define-key *root-map* (kbd "a") "time")
(define-key *root-map* (kbd "'") "select")
(define-key *root-map* (kbd "\"") "windowlist")
(define-key *root-map* (kbd "M-SPC") "other-in-frame")
(define-key *root-map* (kbd "!") "exec")
(define-key *root-map* (kbd "C-g") "abort")
(define-key *root-map* (kbd "R") "remove")
(define-key *root-map* (kbd "s") "vsplit")
(define-key *root-map* (kbd "S") "hsplit")
(define-key *root-map* (kbd "r") "iresize")
(define-key *root-map* (kbd "t") "exchange-direction")
(define-key *root-map* (kbd "C-t") "exchange-direction")

;;Frame management
(define-key *root-map* (kbd "dead_circumflex") "fnext")
(define-key *root-map* (kbd "$") "fprev")
(define-key *root-map* (kbd "TAB") "fother")
(define-key *root-map* (kbd "f") "fselect")
(define-key *root-map* (kbd "F") "curframe")

(define-key *root-map* (kbd "Up")       "move-focus up")
(define-key *root-map* (kbd "Down")     "move-focus down")
(define-key *root-map* (kbd "Left")     "move-focus left")
(define-key *root-map* (kbd "Right")    "move-focus right")
(define-key *root-map* (kbd "C-Up")     "exchange-direction up")
(define-key *root-map* (kbd "C-Down")   "exchange-direction down")
(define-key *root-map* (kbd "C-Left")   "exchange-direction left")
(define-key *root-map* (kbd "C-Right")  "exchange-direction right")
(define-key *root-map* (kbd "M-Up")     "move-window up")
(define-key *root-map* (kbd "M-Down")   "move-window down")
(define-key *root-map* (kbd "M-Left")   "move-window left")
(define-key *root-map* (kbd "M-Right")  "move-window right")

(define-key *root-map* (kbd "RET") "fullscreen")
;;Commands, evaluation, help ...
(define-key *root-map* (kbd ";") "colon")
(define-key *root-map* (kbd ":") "eval")
(define-key *root-map* (kbd "C-h") "help")
(define-key *root-map* (kbd "-") "fclear")
(define-key *root-map* (kbd "Q") "only")
(define-key *root-map* (kbd "v") "version")
;; (define-key *root-map* (kbd "?") "help")
(define-key *root-map* (kbd "+") "balance-frames")
(define-key *root-map* (kbd "A") "title")
(define-key *root-map* (kbd "h") '*help-map*)
(define-key *root-map* (kbd "q") '*web-jump-map*)
(define-key *root-map* (kbd "C-m") "lastmsg")
(define-key *root-map* (kbd "t") "meta Menu")
(define-key *root-map* (kbd "y") "paste")
(define-key *root-map* (kbd "B") "mode-line")

;; ;;Groups
;; (define-key *root-map* (kbd "G") "vgroups")
;; ;; (define-key *root-map* (kbd "Menu") '*groups-map*)
;; (define-key *root-map* (kbd "F1") "gselect 1")
;; (define-key *root-map* (kbd "F2") "gselect 2")
;; (define-key *root-map* (kbd "F3") "gselect 3")
;; (define-key *root-map* (kbd "F4") "gselect 4")
;; (define-key *root-map* (kbd "F5") "gselect 5")
;; (define-key *root-map* (kbd "F6") "gselect 6")
;; (define-key *root-map* (kbd "F7") "gselect 7")
;; (define-key *root-map* (kbd "F8") "gselect 8")
;; (define-key *root-map* (kbd "F9") "gselect 9")
;;Notifications
(define-key *root-map* (kbd "F10") '*notifications-map*)
;;gcal
(define-key *root-map* (kbd "F11") '*gcal-map*)
;;Mails
(define-key *root-map* (kbd "F12") '*mail-map*)
;;Group map----------------------------------------------
;;(setf *groups-map*
      ;; ;;(append *groups-map*
      ;;         (let ((m (make-sparse-keymap)))
(define-key *groups-map* (kbd "g"  ) "groups")
(define-key *groups-map* (kbd "G"  ) "vgroup")
(define-key *groups-map* (kbd "c"  ) "gnew")
(define-key *groups-map* (kbd "b"  ) "gnewbg")
(define-key *groups-map* (kbd "f"  ) "gnew-float")
(define-key *groups-map* (kbd "n"  ) "gnext")

(define-key *root-map*   (kbd ">"  ) "gnext")
(define-key *root-map*   (kbd "M->"  ) "gnext-with-window")
(define-key *groups-map* (kbd "N"  ) "gnext-with-window")

(define-key *root-map*   (kbd "."  ) "gnext-with-window")
(define-key *groups-map* (kbd "p"  ) "gprev")

(define-key *root-map*   (kbd "<"  ) "gprev")
(define-key *root-map*   (kbd "M-<"  ) "gprev-with-window")
(define-key *groups-map* (kbd "P"  ) "gprev-with-window")

(define-key *root-map*   (kbd ","  ) "gprev-with-window")
(define-key *groups-map* (kbd "'"  ) "gselect")
(define-key *groups-map* (kbd "\"" ) "grouplist")
(define-key *groups-map* (kbd "m"  ) "gmove")
(define-key *groups-map* (kbd "C-m") "gmove-marked")
(define-key *groups-map* (kbd "M"  ) "gmerge")
(define-key *groups-map* (kbd "r"  ) "grename")
(define-key *groups-map* (kbd "k"  ) "gkill")
(define-key *groups-map* (kbd "o"  ) "gother")
(define-key *groups-map* (kbd "s"  ) "gsshow")
(define-key *groups-map* (kbd "O"  ) "gspop")
(define-key *groups-map* (kbd "C"  ) "gsclear")
(define-key *groups-map* (kbd "1"  ) "gselect 1")
(define-key *groups-map* (kbd "2"  ) "gselect 2")
(define-key *groups-map* (kbd "3"  ) "gselect 3")
(define-key *groups-map* (kbd "4"  ) "gselect 4")
(define-key *groups-map* (kbd "5"  ) "gselect 5")
(define-key *groups-map* (kbd "6"  ) "gselect 6")
(define-key *groups-map* (kbd "7"  ) "gselect 7")
(define-key *groups-map* (kbd "8"  ) "gselect 8")
(define-key *groups-map* (kbd "9"  ) "gselect 9")
(define-key *groups-map* (kbd "0"  ) "gselect 10")

;;                m))
;;gcal map------------------------------------------------
(setf *gcal-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "w") "gcal-week")
        (define-key m (kbd "m") "gcal-month")
        (define-key m (kbd "a") "gcal-add-event")
        (define-key m (kbd "s") "gcal-search")
        m))
;;Mail map-----------------------------------------------
(setf *mail-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "f") "fetchmail")
        (define-key m (kbd "F") "fetchmail-daemon")
        (define-key m (kbd "k") "fetchmail-kill-daemon")
        m))
;;Help map-----------------------------------------------
(setf *help-map*
      (let ((m (make-sparse-keymap)))
        (define-key m (kbd "m") "man")
        (define-key m (kbd "i") "info")
        (define-key m (kbd "c") "describe-command")
        (define-key m (kbd "v") "describe-variable")
        (define-key m (kbd "f") "describe-function")
        (define-key m (kbd "k") "describe-key")
        (define-key m (kbd "w") "where-is")
        m))
;;Query map----------------------------------------------

;; (setf *query-map*
;;   (let ((m (make-sparse-keymap)))
;;      (define-key m (kbd "i") "imdb")
;;      (define-key m (kbd "g") "google")
;;      (define-key m (kbd "w") "wikipedia")
;;      m))

;; (cl-ppcre:split "(\\w*): ?(\"?[\\w\\s\\.]*\"?)\\s|(\\w*): ?(\"?[\\w\s\\.]*\"?)|(\"[\\w\\s]*\")|([\\w]+)" "sdf dg ")

(defvar *web-jump-map* nil
  "The keymap with net queries (e.g. IMDB)")
(setf *web-jump-map* (make-sparse-keymap))

(defmacro make-web-jump (name url-prefix key)
  `(progn
     (let* ((*input-window-gravity* :center)
            (*message-window-gravity* :center))
       (defcommand ,name (search) ((:rest ,(string-capitalize (string-downcase (concatenate 'string (symbol-name name) ": ")))))
         (run-shell-command (format nil ; "seamonkey -remote 'openURL(~A=~A)'"
                                    (format nil "~a '~a'" (getenv "XBROWSER") ,url-prefix)
                                    (substitute #\+ #\Space search)))))
     (define-key *web-jump-map* (kbd ,key) (string-downcase (symbol-name ',name)))))

(make-web-jump web-jump-open "http://~a/" "o")
(make-web-jump web-jump-imdb "http://www.imdb.com/find?q=~a" "i")
(make-web-jump web-jump-google "http://www.google.com/search?q=~a" "g")
(make-web-jump web-jump-search "http://www.google.com/cse?cx=013269018370076798483:gg7jrrhpsy4&cof=FORID:1&q=~a&sa=Search" "s")
(make-web-jump web-jump-wikipedia "http://en.wikipedia.org/wiki/Special:Search?fulltext=Search&search=~a" "w")
;; (macroexpand-1 '(make-web-jump imdb "http://www.imdb.com/find?q=~a" "i"))



(setf *system-map*
  (let ((m (make-sparse-keymap)))
     (define-key m (kbd "s") "sys-suspend")
     (define-key m (kbd "h") "sys-hibernate")
     (define-key m (kbd "r") "sys-reboot")
     (define-key m (kbd "e") "sys-halt")
     m))

(define-key *root-map* (kbd "~") '*system-map*)


;; (setf *spare-map*
;;   (let ((m (make-sparse-keymap)))
;;      (define-key m (kbd "C") "cprofile")
;;      (define-key m (kbd "M") "myprofile")
;;      m))

;; (define-key *top-map* (kbd "S-Super_L") '*spare-map*)
;; (define-key *root-map* (kbd "Super_L") '*spare-map*)



;; Heirarichal Maps now
;; Window
;; Commands


(defvar *window-commands-map* nil
  "The keymap that group related key bindings sit on. It is bound to @kbd{C-t g} by default.")

(defvar *window-handling-map* nil
  "The keymap that group related key bindings sit on. It is bound to @kbd{C-t g} by default.")

(defvar *window-map* nil
  "The keymap that group related key bindings sit on. It is bound to @kbd{C-t g} by default.")

(defvar *imergency-map* nil
  "The keymap that group related key bindings sit on. It is bound to @kbd{C-t g} by default.")

(defvar *term-commands-map* nil
  "The keymap for terminal emulator commands.")

(fill-keymap *window-commands-map*
             (kbd "t") '*term-commands-map*
             (kbd "b") "xbrowser"
             (kbd "f") "firefox"
             (kbd "T") "torbrowser"
             (kbd "e") "emacsclient"
             (kbd "m") "mail-reader"
             (kbd "n") "new-mail"
             (kbd "E") "editor")

(fill-keymap *term-commands-map*
             (kbd "u") "urxvt"
             (kbd "x") "xterm")

(define-key *top-map* (kbd "XF86Mail") "mail-reader")

;; Handling
(fill-keymap *window-handling-map*
             (kbd "d") "disappear-window")

(define-key *top-map* (kbd "s-w") '*window-map*)
(setf *window-map*
  (let ((m (make-sparse-keymap)))
     (define-key m (kbd "C-c") '*window-commands-map*)
     (define-key m (kbd "c") '*window-commands-map*)
     (define-key m (kbd "C-t") '*window-handling-map*)
     (define-key m (kbd "t") '*window-handling-map*)
     (define-key m (kbd "w") "meta s-w")
     m))


;; Imergency
(define-key *top-map* (kbd "s-i") '*imergency-map*)
(define-key *top-map* (kbd "KP_Enter") '*imergency-map*)

; (undefine-key *top-map* (kbd "s-i"))

(fill-keymap *imergency-map*
             (kbd "s") "show-current-profile"
             (kbd "o") "set-profile cprofile"
             (kbd "m") "set-profile myprofile"
             (kbd "i") "meta s-i"
             (kbd "KP_Enter") "toggle-profile")



;; Press C-c RET for slime-macroexpand-1


;; (defmacro set-key (map mapping)
;;   `(loop for pair in ,mapping
;;       do (if (consp pair)
;;              (if (null (second pair))
;;                  (throw 'stumpwm::error "Abort.")
;;                  (define-key ,map (kbd (first pair)) (second pair)))
;;              (undefine-key pair))))



;; (defun (setf key) (thing key map)
;;   (define-key map (kbd key) thing))

;; (defun key (map key)
;;   )

;; (defmacro fill-xkeymap (map &rest bindings)
;;   `(unless ,map
;;      (setf ,map
;;            (let ((m (make-sparse-keymap)))
;;              ,@(loop for i = bindings then (cddr i)
;;                   while i
;;                   collect `(define-key m
;;                                ,(first i)
;;                              ,(second i)))
;;              m))))

;; ;; (fill-keymap *help-map*
;; ;;   (kbd "v") "describe-variable"
;; ;;   (kbd "f") "describe-function"
;; ;;   (kbd "k") "describe-key"
;; ;;   (kbd "c") "describe-command"
;; ;;   (kbd "w") "where-is")

;; (macroexpand-1
;;  '(fill-keymap *window-commands-map*
;;    (kbd "d") "disappear-window"))

(undefine-key *top-map* (kbd "s-p"))
