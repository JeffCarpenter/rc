;; ensure we elc files.


(when (file-exists-p (setq custom-file "~/.xemacs/custom.el"))
  (load-file custom-file))


;;{{{ setq lot of variables
(setq
 case-fold-search t       ; searches and matches should ignore case
 column-number-mode t     ; display the column number
 confirm-kill-emacs nil   ; don't confirm when exiting emacs
                          ; kill-ring-max 20 ;number of remembered
                          ; cutted texts
 show-paren-style 'mixed  ; my favorite style of highlighting matching
                          ; parentheses

 ;;standard-indent 2 ;don't go to fast towards right
 transient-mark-mode t             ; show the region
 scroll-preserve-screen-position t ; don't move the cursor when scrolling
 ;;doxymacs: emacs mode for doxygen, a source code documentation generator
 european-calendar-style t
 frame-title-format "%b (%f)"  ; the title-bar displays the filename
                               ; of the current buffer
 font-lock-maximum-decoration t         ; as colored as possible
 ;; visible-bell t                      ; stop beeping
 show-paren-delay 0                     ;Show the matching immediately
 default-indicate-empty-lines t ;show me empty lines at the end of the buffer
 ;; inhibit-startup-message t              ;no startup message
 ;; next-line-add-newlines t ; for use with comment-and-go-down, see below
 kill-whole-line t                    ;take the CR when killing a line
 x-stretch-cursor t      ;when on a TAB, the cursor has the TAB length
 require-final-newline t ;adds a newline at the end of the file beeing
                                        ;saved if it doesn't already have one
 compile-command '"make"
 ;; version-control t ; Allow numbered backups, enough
 version-control nil  ; Allow numbered backups, enough
 time-stamp-active t                    ; update timestamps
 time-stamp-warn-inactive t             ; warn if unable
 ispell-dictionary "english" ; check ispell-dictionary-base-alist variable for possible vaules
 save-abbrevs 'silently

 ;; english british american
)
;;}}}

;; Are we running XEmacs or Emacs?
(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;;{{{ define xrequire
(defvar exclude-lib
  (if (string-equal (system-name) "spratap")
      '(tramp)))

(defun xrequire (feature)
  (unless (member feature exclude-lib)
      (if (not running-xemacs)
          (require feature nil t)
          (require feature nil))))

;; create it ASAP
;(defun srlib (sym path)
;  ( if path
;      (if (file-exists-p
;	   ( concat ( car load-path ) (symbol-name sym )))
;	  t
;	(srlib sym (cdr path))
;	)
;    nil
;    )
;  )

;(file-exists-p 'asdasdf )


;;}}}

;;{{{ Mode line and custom-set-faces
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Mode line
;; Set a Mode Line that tells me which machine, which directory,
;; and which line I am on, plus the other customary information.
;; (setq default-mode-line-format
;;  (quote
;;   (#("-" 0 1
;;      (help-echo
;;       "mouse-1: select window, mouse-2: delete others ..."))
;;    mode-line-mule-info
;;    mode-line-modified
;;    mode-line-frame-identification
;;    "    "
;;    mode-line-buffer-identification
;;    "    "
;;    (:eval (substring
;;            (system-name) 0 (string-match "\\..+" (system-name))))
;;    ":"
;;    default-directory
;;    #(" " 0 1
;;      (help-echo
;;       "mouse-1: select window, mouse-2: delete others ..."))
;;    (line-number-mode " Line %l ")
;;    global-mode-string
;;    #("   %[(" 0 6
;;      (help-echo
;;       "mouse-1: select window, mouse-2: delete others ..."))
;;    (:eval (mode-line-mode-name))
;;    mode-line-process
;;    minor-mode-alist
;;    #("%n" 0 2 (help-echo "mouse-2: widen" local-map (keymap ...)))
;;    ")%] "
;;    (-3 . "%P")
;;    ;;   "-%-"
;;    )))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; lib load
;; (add-to-list 'load-path                           ; added all subdir's
;; 	     (file-expand-wildcards "~/.xemacs/packages/*")
;; 	     )


(defconst *package-dir* "~/.xemacs/packages")

(when (file-directory-p *package-dir*)
  (mapc #'(lambda (path)
            (add-to-list 'load-path path))
        (directory-files *package-dir* t "[a-zA-Z]+"))
  (mapc #'byte-recompile-directory
        (directory-files *package-dir* t "[a-zA-Z]+")))

;; (add-to-list 'load-path
;;              (concat *package-dir* "/auto-install"))

(add-to-list 'load-path
             (concat *package-dir* "/pde"))


(load-file "~/.xemacs/basic.el")
(load-file "~/.xemacs/utils.el")
(load-file "~/.xemacs/macros.el")

(user-require 'common-info)

(when (xrequire 'server)
  (setq server-use-tcp t
        server-name (or (getenv "EMACS_SERVER_NAME") server-name))
  (setq server-host (system-name))
  (if (functionp 'server-running-p)
      (when (not (server-running-p))
	(server-start)))
  (message (concat "SERVER: " server-name))
  (when (server-running-p "general")
    (message (concat "YES SERVER: " server-name))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load all files present in ~/\.xemacs/session-start\.d directory.
(defconst *session-file-dir* "~/\.xemacs/session-start\.d")
(defconst *work-dir* "~/\.\./paradise")

;; (defconst *session-file-dir*
;;   (if (file-directory-p (concat "~/.xemacs/" server-name ".d"))
;; 	(concat "~/.xemacs/" server-name ".d")
;;     "~/\.xemacs/session-start\.d"))

(when (file-directory-p *session-file-dir*)
  (byte-recompile-directory *session-file-dir* 0)
  (mapc 'load-file
        (directory-files *session-file-dir* t "^[a-zA-Z0-9-]+\.elc$")))


;; (when (file-directory-p *session-file-dir*)
;;  (byte-recompile-directory *session-file-dir* 0)
;;  (mapc '(lambda (file)
;;          (user-require
;;           (intern (file-name-sans-extension
;;                    (file-name-nondirectory file)))
;;           "~/.xemacs/session-start.d"))
;;        (directory-files *session-file-dir* t "^[a-zA-Z0-9-]+\.elc$")))



;;end


;; (file-name-sans-extension
;;  (file-name-nondirectory "~/.xemacs/basic.el"))


(put 'scroll-left 'disabled nil)


