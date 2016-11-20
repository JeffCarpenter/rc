
;; ensure we elc files.



(defvar *emacs-in-init* t "Emacs is in init.")
(defvar user-emacs-directory "~/.emacs.d")
(setq user-emacs-directory "~/.emacs.d")
(setq *emacs-in-init* t)
(add-hook 'after-init-hook
          (lambda ()
            (setq *emacs-in-init* nil)
            (ad-disable-advice 'server-create-window-system-frame 'around 'nocreate-in-init)))
(when (or t (require 'subr nil t))
  (defvar old-messages-buffer-max-lines 100 "To keep all startup detail.")
  (setq
   old-messages-buffer-max-lines messages-buffer-max-lines
   messages-buffer-max-lines 2000))


(eval-when-compile
  (require 'cl nil nil))

(eval-after-load "server"
  '(progn
    ;; server-auth-dir (auto-config-dir "server" t)
    (defadvice server-create-window-system-frame
     (around nocreate-in-init activate)
     "remove-scratch-buffer"
     (if *emacs-in-init*
         (message "loading init now.")
         ad-do-it))))

(require 'loadpath-config      "~/.xemacs/pkgrepos/mypkgs/session-start/loadpath-config.el")

(when (require 'cl nil) ; a rare necessary use of REQUIRE
  ; http://a-nickels-worth.blogspot.in/2007/11/effective-emacs.html
  (defvar *emacs-load-start* (current-time)))

(defconst *work-dir*
  (expand-file-name "paradise" "~/.."))
;;


(deh-section "custom setup"
 (defvar custom-override-file "~/.xemacs/hand-custom.el" "Hand Custom elisp")

 (when (file-exists-p (setq custom-file "~/.xemacs/custom.el"))
  (load-file custom-file))

 (when (file-exists-p custom-override-file)
   (load-file custom-override-file)))

(deh-require-maybe server
  (setq
   ;; server-auth-dir (auto-config-dir "server" t)
   server-use-tcp t
   server-name (or (getenv "EMACS_SERVER_NAME") server-name))
  (setq server-host (system-name))
  (if (functionp 'server-running-p)
      (when (not (server-running-p))
        (condition-case e
            (server-start)
          ('error
           (progn
             (message "Error: %s, now trying to run with tcp." e)
             (let ((server-use-tcp nil))
               (setq server-use-tcp nil)
               (server-start)))))))
  (message (concat "SERVER: " server-name))
  (when (server-running-p "general")
    (message (concat "YES SERVER: " server-name))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; load all files present in ~/\.xemacs/session-start\.d directory.


(require-dir-libs "~/\.xemacs/pkgrepos/mypkgs/session-start")

;; (load-file "~/.xemacs/wrapper.el")
(require 'wrappers-config)

(progn
  (put-file-in-rcs (auto-config-file "startup/startup.log"))
  (with-current-buffer "*Messages*"
    (setq messages-buffer-max-lines 2000
          ;; old-messages-buffer-max-lines
          )
    ;; (append-to-buffer "*xxemacs-startup-log*" (point-min) (point-max))
    (copy-to-buffer "*emacs-startup-log*" (point-min) (point-max)))

  ;; (with-current-buffer "*emacs-startup-log*"
  ;;   ;; (with-temp-file file body)
  ;;   (set-buffer-file-coding-system
  ;;    (if (coding-system-p 'utf-8-emacs)
  ;;        'utf-8-emacs
  ;;        'emacs-mule))
  ;;   (write-region (point-min) (point-max) "~/.emacs.d/startup.log" t)
  ;;   (put-file-in-rcs "~/.emacs.d/startup.log"))
  )



;; (redefine-function-remembered 'server-create-window-system-frame)
(setq *emacs-in-init* nil)              ;how to ensure it will run.
(ad-disable-advice 'server-create-window-system-frame 'around 'nocreate-in-init)
;;end



;; (when (boundp '*emacs-load-start*)
;;   ;; http://a-nickels-worth.blogspot.in/2007/11/effective-emacs.html
;;     (message "My .emacs loaded in %ds"
;;              (destructuring-bind (hi lo ms) (current-time)
;;                (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*))))))


;; (message "My .emacs loaded in %s" (emacs-init-time))




;; (sharad/enable-startup-inperrupting-feature)

(message "emacs ~/.xemacs/init.el loaded")

;; (notify "Emacs" "Loaded Completely :)")
