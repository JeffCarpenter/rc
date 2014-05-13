

;; for editing remote files
;;(require 'tramp) ;stop error caused by no availability of tramp.
;; check C-h f require


;; set shell based on
;; "TERM=dumb" "EMACS=t" "INSIDE_EMACS='23.4.1,tramp:2.1.21-pre'"
;;

(require 'tree)
(eval-when-compile '(require 'tree))

(eval-after-load "tramp"
  '(when *emacs-in-init*
    (sharad/disable-startup-inperrupting-feature)))

(eval-when-compile
  '(require 'tramp))

(deh-require-maybe tramp

  (require 'utils-config)

  (add-hook 'sharad/disable-startup-inperrupting-feature-hook
            ;;will not be called.
            '(lambda () ;very necessary.
              (setq tramp-mode nil ido-mode nil)))


  (when *emacs-in-init*
    (setq                                 ;very necessary.
     tramp-mode nil
     ido-mode nil))

  (deh-require-maybe ido
    (setq
     ;; ido-enable-tramp-completion t ;this guy was missing
     ;; ido-enable-tramp-completion nil ;this guy was missing
     ido-enable-tramp-completion t ;Very much require to complete tramp user /server names.
     ido-record-ftp-work-directories t ;must be true for tramp partial match, very useful.
     ))


  (deh-section "ido tramp problem"
    (when nil
      (setq ido-dir-file-cache (remove-if-not
        (lambda (f)
            (if (ido-is-ftp-directory (car f))
                 (eq (caadr f) 'ftp)
                 t))
            ido-dir-file-cache))))


  (setq ;; tramp-default-method "ssh"
   ;; tramp-default-method "scpc" <- default
   tramp-debug-buffer t
   ;; tramp-verbose 10
   tramp-verbose 1
   tramp-default-user nil
   tramp-default-host "spratap")
  ;; http://www.gnu.org/software/tramp/#Remote-shell-setup
  (setenv "ESHELL" "bash")

  (tramp-set-completion-function "ssh"
                                 '((tramp-parse-sconfig "/etc/ssh_config")
                                   (tramp-parse-sconfig "~/.ssh/config")))

  (ignore-errors
    (deh-section "GVFS DBUS TRAMP IDO Avahi"
     ;; it is not working find why, get it working
     (deh-require-maybe tramp-gvfs
       ;; need it.
       ;; http://comments.gmane.org/gmane.emacs.tramp/6704
       ;; http://www.gnu.org/software/emacs/manual/html_node/tramp/GVFS-based-methods.html
      )))



  (deh-section "All Tramp"

    (deh-require-maybe (progn
                         tramp-cache
                         tramp-cmds
                         tramp-compat
                         tramp-fish
                         tramp-ftp
                         ;; tramp-gvfs
                         tramp-gw
                         tramp-imap
                         tramp-smb
                         tramp-uu
                         trampver)))


  ;; (defun sudo-edit (&optional arg)
  ;;   (interactive "p")
  ;;   (if arg
  ;;       (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
  ;;       (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

  ;; (defun sudo-edit-current-file ()
  ;;   (interactive)
  ;;   (find-alternate-file (concat "/sudo:root@localhost:" (buffer-file-name (current-buffer)))))

  ;; (global-set-key (kbd "C-c C-r") 'sudo-edit-current-file)

  (require 'mime-def)
  (defsubst regexp-* (regexp)
  (concat regexp "*"))

  (defsubst regexp-or (&rest args)
    (if args
        (concat "\\(" (mapconcat (function identity) args "\\|") "\\)")
        nil))

  (when nil ;e.g. regex-or regex-opt usage
    (string-match (regexp-opt '("simba")) "szdfdssimbaasdfds")
    (string-match "\\`simba" "adfsimbaasdfds")

    (regexp-quote (system-name))

    (string-match (regexp-or "\\`simba" "sharad") "afsimbaasdfds")
    (string-match (regexp-or ) "asf"))


  (defun find-alternative-file-with-sudo () ; put in keybinding.el
    (interactive)
    (let ((fname (or buffer-file-name
                     dired-directory)))
      (when fname
        (if (string-match "^/sudo:root@localhost:" fname)
            (setq fname (replace-regexp-in-string
                         "^/sudo:root@localhost:" ""
                         fname))
            (setq fname (concat "/sudo:root@localhost:" fname)))
        (find-alternate-file fname))))

  ;; http://www.gnu.org/software/tramp/#Multi_002dhops
  (deh-require-maybe common-info
    (add-to-list 'tramp-default-proxies-alist
                 `(,tramp-default-proxie "\\`root\\'" "/ssh:%h:"))

    (deh-section "section for tramp-default-proxies-alist"
      (defvar *tramp-default-proxies-config* nil "tramp default proxies config")

      ;; (defun tramp-noproxies-hosts-default-user (user)
      ;;   (tree-node *tramp-default-proxies-config* 'noproxy user :test 'equal))

      ;; (defun tramp-sudoproxies-hosts-default-user (user)
      ;;   (tree-node *tramp-default-proxies-config* 'sudo user :test 'equal))

      (deh-section "general sudo setup for tramp-default-proxies-alist"
        ;; http://www.gnu.org/software/emacs/manual/html_node/tramp/Multi_002dhops.html
        (add-to-list 'tramp-default-proxies-alist
                     '(nil "\\`root\\'" "/ssh:%h:"))

        (add-to-list 'tramp-default-proxies-alist
                     '((regexp-quote (system-name)) nil nil))

        (add-to-list 'tramp-default-proxies-alist
                     '((regexp-quote "localhost") nil nil)))

      (defun tramp-set-no-proxy (hostname)
        (interactive "shostname: ")
        (add-to-list 'tramp-default-proxies-alist
                     `((regexp-quote ,hostname) nil nil)))

      (defun tramp-reset-no-proxy (hostname)
        (interactive "shostname: ")
        ;; (add-to-list 'tramp-default-proxies-alist
        ;;              `((regexp-quote ,hostname) nil nil))
        )

      (eval-after-load "tramp"
        '(progn
          (add-to-list
           'desktop-globals-to-save
           'tramp-default-proxies-alist)
          (add-to-list
           'desktop-globals-to-save
           'tramp-default-proxies-alist)))


      (deh-section "sudo using different user for tramp-default-proxies-alist"
        (dolist (user (mapcar 'car (tree-node *tramp-default-proxies-config* 'sudo :test 'equal)))
          (if (tree-node *tramp-default-proxies-config* 'sudo user :test 'equal)
              (add-to-list 'tramp-default-proxies-alist
                           `((regexp-or
                              ,@(mapcar
                                 (lambda (host)
                                   (concat "\\`" host))
                                 (tree-node *tramp-default-proxies-config* 'sudo user :test 'equal)))
                             "\\`root\\'"
                             ,(concat "ssh:" user "@%h")))))

        (when nil ;; e.g.
          (add-to-list 'tramp-default-proxies-alist
                       '("\\`host" "\\`root\\'" "/ssh:user@%h:"))

          (add-to-list 'tramp-default-proxies-alist
                       '("\\`simba" "\\`root\\'" "/ssh:meru@%h:")))))


    (deh-section "section for tramp-default-user-alist"

      (deh-section "default user setup for tramp-default-user-alist"
        (defvar *tramp-default-user-config* nil "tramp default user config")

        (dolist (method (mapcar 'car (tree-node *tramp-default-user-config* :test 'equal)))
          (dolist (user (mapcar 'car (tree-node *tramp-default-user-config* method :test 'equal)))
            (if (tree-node *tramp-default-user-config* method user :test 'equal)
                (add-to-list 'tramp-default-user-alist
                             `(,method
                               ,(apply 'regexp-or
                                       (mapcar
                                        (lambda (host)
                                          (concat "\\`" host))
                                        (tree-node *tramp-default-user-config* method user :test 'equal)))
                               ,user)))))

        (when nil ;; e.g.
          (add-to-list 'tramp-default-proxies-alist
                       '("\\`method" "\\`host\\'" user) t)))))


  (deh-section "tramp beeps"

    ;; If you, for example, wants to work as ‘root’ on hosts in the
    ;; domain ‘your.domain’, but login as ‘root’ is disabled for
    ;; non-local access, you might add the following rule:

    ;; (add-to-list 'tramp-default-proxies-alist
    ;;              '("\\.your\\.domain\\'" "\\`root\\'" "/ssh:%h:"))

    ;; Opening /sudo:randomhost.your.domain: would connect first
    ;; ‘randomhost.your.domain’ via ssh under your account name, and
    ;; perform sudo -u root on that host afterwards. It is important to
    ;; know that the given method is applied on the host which has been
    ;; reached so far. sudo -u root, applied on your local host,
    ;; wouldn't be useful here.

    ;; {{http://ubuntuforums.org/archive/index.php/t-1375454.html
    ;; TRAMP beep when done downloading files
    (defadvice tramp-handle-write-region
        (after tramp-write-beep-advice activate)
      " make tramp beep after writing a file."
      (interactive)
      (beep))
    (defadvice tramp-handle-do-copy-or-rename-file
        (after tramp-copy-beep-advice activate)
      " make tramp beep after copying a file."
      (interactive)
      (beep))
    (defadvice tramp-handle-insert-file-contents
        (after tramp-copy-beep-advice activate)
      " make tramp beep after copying a file."
      (interactive)
      (beep))
    ;; }}
    )

  (deh-section "Get ssh-add pass from emacs only."
    (defvar getpass-ssh-add-program (concat "timeout -k 16 10 ssh-add " ssh-key-file) "ssh-add command")

    (defvar getpass-ssh-add-prompt "Enter passphrase for \\([^:]+\\):"
      "ssh-add prompt for passphrases")

    (defvar getpass-ssh-add-invalid-prompt "Bad passphrase, try again:"
      "ssh-add prompt indicating an invalid passphrase")

    (defun getpass-ssh-send-passwd (process prompt)
      "read a passphrase with `read-passwd` and pass it to the ssh-add process"
      (let ((passwd (read-passwd prompt)))
        (process-send-string process passwd)
        (process-send-string process "\n")
        (clear-string passwd)))

    (defun getpass-ssh-add-process-filter (process input)
      "filter for ssh-add input"
      (cond ((string-match getpass-ssh-add-prompt input)
             (getpass-ssh-send-passwd process input))
            ((string-match getpass-ssh-add-invalid-prompt input)
             (getpass-ssh-send-passwd process input))
            ;; (t (with-current-buffer (get-buffer-create ssh-agent-buffer)
            ;;      (insert input)))
            ))

    (defun getpass-ssh-add (&optional cmd)
      "run ssh-add"
      (interactive (list (if current-prefix-arg
                             (read-string "Run ssh-add: " getpass-ssh-add-program)
                             getpass-ssh-add-program)))
      (unless cmd
        (setq cmd getpass-ssh-add-program))
      (let ()
        (if cmd
            (set-process-filter
             (apply #'start-process "ssh-add" nil shell-file-name "-c" (list cmd))
             #'getpass-ssh-add-process-filter)
            (error "No command given")))))

  (defun ssh-agent-add-key ()
    (require 'misc-config)
    (provide 'host-info)
    ;; (message "Calling update-ssh-agent > ssh-agent-add-key")
    ;; (message "tramp-mode %s" tramp-mode)
    (if (and
         (boundp 'ssh-key-file)
         ssh-key-file)
        ;; (unless (and (not tramp-mode)
        ;;             (shell-command-local-no-output "ssh-add -l < /dev/null"))
        (with-timeout (7 (message "ssh-add timed out."))
          (cond ((custom-display-graphic-p)
                 (shell-command-local-no-output (concat "timeout -k 16 10 ssh-add " ssh-key-file " < /dev/null")))
                ((eq (frame-parameter (selected-frame) 'window-system) nil)
                 (getpass-ssh-add (concat "timeout -k 16 10 ssh-add " ssh-key-file))))) ;;)
        (error "No ssh-key-file defined")))

  (defun update-ssh-agent-1 (&optional force)
    (unwind-protect
         (save-excursion
           (if ido-auto-merge-timer
               (timer-activate ido-auto-merge-timer t))
           (if force (tramp-cleanup-all-connections))
           (if (getenv "SSH_AGENT_PID" (selected-frame))
               (progn
                 (unless (and (not force)
                              (getenv "SSH_AGENT_PID")
                              (string-equal (getenv "SSH_AGENT_PID")
                                            (getenv "SSH_AGENT_PID" (selected-frame))))
                   (setenv "SSH_AGENT_PID" (getenv "SSH_AGENT_PID" (selected-frame)))
                   (setenv "SSH_AUTH_SOCK" (getenv "SSH_AUTH_SOCK" (selected-frame)))
                   (message "update main pid and sock to frame pid %s sock %s"
                            (getenv "SSH_AGENT_PID" (selected-frame))
                            (getenv "SSH_AUTH_SOCK" (selected-frame))))
                 (unless (and (not force)
                              (shell-command-local-no-output "ssh-add -l < /dev/null"))
                   (ssh-agent-add-key)))
               (message "No frame present.")))
      (if ido-auto-merge-timer
          (timer-activate ido-auto-merge-timer))
      (message nil)))

  (defun update-ssh-agent (&optional force)
    (interactive "P")
    ;; (message "update-ssh-agent called")
    (if (< (length (frame-list)) 2)
        (backtrace-to-buffer "*plan-ssh-key-trace*"))
    (when (or force
              (null (getenv "SSH_AGENT_PID"))
              (not (string-equal (getenv "SSH_AGENT_PID")
                                 (getenv "SSH_AGENT_PID" (selected-frame))))
              (not (shell-command-local-no-output "ssh-add -l < /dev/null")))
      (if (memq epa-file-handler file-name-handler-alist)
          (with-temp-buffer
            (let ((default-directory "~/"))
              (find-file-noselect (or (plist-get (car auth-sources) :source)
                                      "~/.authinfo.gpg"))))
          (message "update-ssh-agent: epa is not enabled."))
      (update-ssh-agent-1)))

  (eval-when-compile
    '(require 'general-testing))

  (require 'general-testing)

  ;; (testing
  (when nil
   (when (or (null (getenv "SSH_AGENT_PID"))
            (not (string-equal (getenv "SSH_AGENT_PID")
                               (getenv "SSH_AGENT_PID" (selected-frame))))
            (not (shell-command-local-no-output "ssh-add -l < /dev/null")))
     (find-file-noselect (or (plist-get (car auth-sources) :source)
                             "~/.authinfo.gpg"))
     (update-ssh-agent-1)))

  (when nil
    (run-with-timer 10 nil (lambda ()
                             (setq xxtframe (selected-frame))))
    (select-frame xxtframe)
    (getenv "SSH_AGENT_PID" xxtframe))

  (defadvice tramp-file-name-handler
      (before ad-update-ssh-agent-env activate)
    "Support ssh agent."
    (unless (tramp-tramp-file-p default-directory) ;why?
      (if tramp-mode
          (update-ssh-agent))))

  ;; gtags-push-tramp-environment  ;; set defadvice with update-ssh-agent

  (defadvice tramp-file-name-handler
     (before ad-update-ssh-agent-env activate)
   "Support ssh agent."
   (update-ssh-agent))


  (when nil
    (ad-remove-advice 'tramp-file-name-handler 'before 'ad-update-ssh-agent-env)
    (ad-update 'tramp-file-name-handler)
    (ad-activate 'tramp-file-name-handler))


  ;; run, do not run it, it trouble at start-up time.
  ;; (update-ssh-agent)

  (defun tramp-output-wash (&optional arg)
    (interactive)
    (save-excursion
      (let ((buffer-read-only nil))
        (goto-char (point-min))

        (while (re-search-forward "\n\\$ " nil t)
          (replace-match "\n$\n" nil nil))

        ;;(replace-regexp "\n\\$ " "\n$\n")
        )))

  (add-hook 'grep-mode-hook #'tramp-output-wash)
  (add-hook 'cscope-list-entry-hook #'tramp-output-wash)

  (deh-section "Info"
    ;; tramp-cleanup-connection (vec)
    ;; want to know what is vec than see definition of tramp-cleanup-connection
    ;; (with-parsed-tramp-file-name buffer-file-name nil v)

    ;; (defun tramp-connectable-p (filename)
    ;;   "Check, whether it is possible to connect the remote host w/o side-effects.
    ;; This is true, if either the remote host is already connected, or if we are
    ;; not in completion mode."
    ;;   (and (tramp-tramp-file-p filename)
    ;;        (with-parsed-tramp-file-name filename nil
    ;; 	 (or (get-buffer (tramp-buffer-name v))
    ;; 	     (not (tramp-completion-mode-p))))))

    ;; (tramp-open-connection-setup-interactive-shell PROC VEC)

    (eval-when-compile
      '(require 'tramp))

    (require 'tramp)

    (defun tramp-file-connection (file-name)
      (when (and file-name (file-remote-p file-name))
        ;; (with-parsed-tramp-file-name file-name nil v)
        (tramp-dissect-file-name file-name)))

    (defun tramp-connection-file (connection)
      (when connection
        (tramp-make-tramp-file-name
         (tramp-file-name-method connection)
         (tramp-file-name-user connection)
         (tramp-file-name-host connection)
         (tramp-file-name-localname connection))))

    (defun tramp-connection-prefix (connection)
      (when connection
        (tramp-make-tramp-file-name
         (tramp-file-name-method connection)
         (tramp-file-name-user connection)
         (tramp-file-name-host connection)
         nil)))

    (defun tramp-file-prefix (file-name)
      (tramp-connection-prefix
       (tramp-file-connection file-name)))

    (defun file-name-localname (file)
      (if (file-remote-p file)
          (tramp-file-name-localname (tramp-file-connection file))
          file))))



(when nil
  (defun tramp-do-file-attributes-with-stat
      (vec localname &optional id-format)
    "Implement `file-attributes' for Tramp files using stat(1) command."
    (tramp-message vec 5 "file attributes with stat: %s" localname)
    (tramp-send-command-and-read
     vec
     (format
      ;; "((%s %s || %s -h %s) && %s -c '((\"%%N\") %%h %s %s %%Xe0 %%Ye0 %%Ze0 %%se0 \"%%A\" t %%ie0 -1)' %s || echo nil)"
      "((%s %s || %s -h %s) && %s -c '((\"%%n\") %%h %s %s %%Xe0 %%Ye0 %%Ze0 %%se0 \"%%A\" t %%ie0 -1)' %s || echo nil)"
      (tramp-get-file-exists-command vec)
      (tramp-shell-quote-argument localname)
      (tramp-get-test-command vec)
      (tramp-shell-quote-argument localname)
      (tramp-get-remote-stat vec)
      (if (eq id-format 'integer) "%u" "\"%U\"")
      (if (eq id-format 'integer) "%g" "\"%G\"")
      (tramp-shell-quote-argument localname))))



  (defun tramp-do-directory-files-and-attributes-with-stat
      (vec localname &optional id-format)
    "Implement `directory-files-and-attributes' for Tramp files using stat(1) command."
    (tramp-message vec 5 "directory-files-and-attributes with stat: %s" localname)
    (tramp-send-command-and-read
     vec
     (format
      (concat
       ;; We must care about filenames with spaces, or starting with
       ;; "-"; this would confuse xargs.  "ls -aQ" might be a solution,
       ;; but it does not work on all remote systems.  Therefore, we
       ;; quote the filenames via sed.
       "cd %s; echo \"(\"; (%s -a | sed -e s/\\$/\\\"/g -e s/^/\\\"/g | xargs "
                                        ; "%s -c '(\"%%n\" (\"%%N\") %%h %s %s %%Xe0 %%Ye0 %%Ze0 %%se0 \"%%A\" t %%ie0 -1)'); "
       "%s -c '(\"%%n\" (\"%%n\") %%h %s %s %%Xe0 %%Ye0 %%Ze0 %%se0 \"%%A\" t %%ie0 -1)'); "
       "echo \")\"")
      (tramp-shell-quote-argument localname)
      (tramp-get-ls-command vec)
      (tramp-get-remote-stat vec)
      (if (eq id-format 'integer) "%u" "\"%U\"")
      (if (eq id-format 'integer) "%g" "\"%G\"")))))



;;{{ from: http://stackoverflow.com/a/4371566
;; throwing error.
;; for emacs tramp timeout.
;; (defun tramp-find-file-timeout ()
;;   ;; (when tramp
;;   (when tramp-mode
;;     (with-timeout (4)
;;       (keyboard-quit))))
;; (add-hook 'find-file-hook 'tramp-find-file-timeout)
;;}}



;; (setq vc-ignore-dir-regexp "\\`\\(?:[\\/][\\/][^\\/]+[\\/]\\|/\\(?:net\\|afs\\|\\.\\.\\.\\)/\\)\\'\\|etc")


;; vc-handled-backends is a variable defined in `vc-hooks.el'.
;; Its value is
;; (P4 RCS CVS SVN SCCS Bzr Git Hg Mtn Arch)



(autoload 'password-in-cache-p "password-cache")

;; believe it need not be here
;; (sharad/disable-startup-inperrupting-feature)



(deh-section "tramp"
  ;; https://idlebox.net/2011/apidocs/emacs-23.3.zip/tramp/tramp_5.html#SEC31

  ;; 5.4.1 Running remote programs that create local X11 windows

  ;; If you want to run a remote program, which shall connect the X11
  ;; server you are using with your local host, you can set the
  ;; $DISPLAY environment variable on the remote host:


  (deh-require-maybe tramp-sh
    (add-to-list 'tramp-remote-process-environment
                 (format "DISPLAY=%s" (getenv "DISPLAY")))))


(deh-section "dailty tramp problem"
  (defun revert-tramp-buffer ()
    (interactive)
    (if (and buffer-file-name
             (tramp-tramp-file-p buffer-file-name))
        (tramp-cleanup-connection (tramp-file-connection buffer-file-name)))
    (revert-buffer)))



(provide 'tramp-config)
