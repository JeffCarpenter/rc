
(in-package :stumpwm)

(progn
  ;; Profiles management
  (let (current
        (profile-alist nil))

    (define-stumpwm-type :profile (input prompt)
      (or (find (intern
                 (string-upcase
                  (or (argument-pop input)
                      ;; Whitespace messes up find-symbol.
                      (string-trim " "
                                   (completing-read (current-screen)
                                                    prompt
                                                    ;; find all symbols in the
                                                    ;;  stumpwm package.
                                                    (let (acc)
                                                      (dolist (s (mapcar #'car profile-alist))
                                                        (push (string-downcase (symbol-name s)) acc))
                                                      acc)))
                      (throw 'error "Abort.")))
                 "KEYWORD")
                profile-alist :key #'car :test #'equal)
          (throw 'error "Symbol not in STUMPWM package")))

    (defun profile-add (name &rest alist)
      (if (push (cons name alist) profile-alist)
          (message "Added ~a profile" (setf current name))))

    (defun profile-apply (profile)
      (if (assoc :map profile)
          (run-shell-command (concat "xmodmap " (cdr (assoc :map profile))))))

    (defcommand toggle-profile () ()
      (let ((profile (car (or (cdr (member current profile-alist :key #'car)) profile-alist))))
        (set-profile profile)))

    (defcommand set-profile (profile) ((:profile "profile name: "))
      (let ((pr (if (symbolp profile)
                    (find profile profile-alist :key #'car :test #'equal )
                    profile)))
        (if (profile-apply (cdr pr))
            (message "applied ~a profile" (setf current (car pr))))))

    (defcommand show-profile (profile) ((:profile "profile name: "))
      (message "profile: ~a" profile))

    (defcommand show-current-profile () ()
      (show-profile (find current profile-alist :key #'car :test #'equal)))

    (defcommand show-fullprofile () ()
      (message "profile: ~a" profile-alist)))

  (profile-add :cprofile
               '(:map . "~/.Xmodmaps/xmodmaprc-normal-but-super")
               '(:cmd . "synclient TouchpadOff=0"))
  (profile-add :myprofile
               '(:map . "~/.Xmodmaps/xmodmaprc-swap-alt-ctrl-caps=alt")
               '(:cmd . "synclient TouchpadOff=1"))

  (set-profile :myprofile))


