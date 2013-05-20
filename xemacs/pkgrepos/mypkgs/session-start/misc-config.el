;; create an indirect buffer
(defun indirect-buffer ()
  "Edit stuff in this buffer in an indirect buffer.
The indirect buffer can have another major mode."
  (interactive)
  (let ((buffer-name (generate-new-buffer-name "*indirect*")))
    (pop-to-buffer (make-indirect-buffer (current-buffer) buffer-name))))

;; Here is another function which I started using so often I bound it to
;; a key. Now I can use C-c i to insert the current date.

;; Insertion of Dates.
(defun insert-date-string ()
  "Insert a nicely formated date string."
  (interactive)
  (insert (format-time-string "%Y-%m-%d")))



(if (not running-xemacs)
    (menu-bar-mode -10))

(tool-bar-mode -10)



;; geometry of the opened window, I have a big screen, please adapt to yours.
;; (setq default-frame-alist
;;       '(
;;         (top . 000)
;;         (left . 1000)
;;         (width . 150)
;;         (height . 90)))
;;}}}

(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(column-number-mode 1)
(setq font-lock-maximum-decoration     ;; for setting the level of
      '((c-mode . 3) (c++-mode . 3)))  ;; fontification.
; Make all "yes or no" prompts show "y or n" instead
(fset 'yes-or-no-p 'y-or-n-p)
;; (tool-bar-mode 0)                       ;no buttons, thanks
;; (display-time-mode 1)			;not available in XEmacs.


;show white spaces (in "pale turquoise", see "custom-set-faces" below)
;at the end of lines
(setq-default show-trailing-whitespace t)


;; (c-set-style "gnu")
;; (load "~/emacslib/loaddefs.el" t t t )
;; (run-with-idle-timer 5 t 'zone)
;; (run-with-idle-timer 12  t 'toggle-read-only 10)
;; (zone)
;; (run-with-idle-timer 20 t 'vc-toggle-read-only 10)

;;Resuming Emacs with Arguments
;;You can specify ordinary arguments for Emacs when you resume it
;;after a suspension. To prepare for this, put the following code in
;;your `.emacs' file (see section Hooks):
(add-hook 'suspend-hook 'resume-suspend-hook)
;; timestamps rule
;;;Turn on time-stamp updating. Timestamp must be in first 8 lines of file and look like:
;;; Time-stamp: <>
(add-hook 'write-file-hooks 'time-stamp)
;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq time-stamp-format                 ; format of the stamp
;;       ;;use describe-variable for info
;;       "[%f] modified by Sharad on %:a, %:y.%02m.%02d at %02H:%02M:%02S on %s"
;;       time-stamp-active t               ; update timestamps
;;       time-stamp-warn-inactive t)       ; warn if unable

;;For allowing/prohibiting #file and file~
(setq auto-save-list-file-name t)       ;need it

;; The default flyspell behavior is to highlight incorrect words.
;; With no argument, this command toggles Flyspell mode.
;; With a prefix argument ARG, turn Flyspell minor mode on iff ARG is positive.
;; Consider using the `ispell-parser' to check your text.  For instance
;; consider adding:
(add-hook 'tex-mode-hook                ;for tex
          (function (lambda () (setq ispell-parser 'tex))))
(add-hook 'text-mode-hook
          (lambda () (flyspell-mode 1)))
(add-hook 'fundamental-mode-hook
          (lambda () (flyspell-mode 1)))

;; peace
(setq ring-bell-function (lambda () (message "bell !!")))

;; Make minibuffer larger if there is more to see
(when (functionp 'resize-minibuffer-mode)
  (resize-minibuffer-mode 1))
;; Allow marking of the region using cursor keys and the shift key and
;; other stuff, not highlight selected region.
;;(pc-selection-mode)

;; The following line will do away with the scrollbar! Scrollbars are
;; for sissies, anyway. Seriously, though, this can be usefull if you
;; want to choose on which side of the the frame scrollbars ought to
;; be. Try (set-scroll-bar-mode 'left) and (set-scroll-bar-mode
;; 'right) instead.
;; No scrollbar
(when (functionp 'set-scroll-bar-mode)
    (set-scroll-bar-mode nil))
;; No beeping
;; (setq visible-bell t)
;; I don't like VB
(setq visible-bell nil)
;; Hilight matching parenthesis
(unless (featurep 'xemacs) (show-paren-mode 1))
;; fix missing INSERT key to toggle overwrite-mode on the console
(global-set-key-if-unbind [insertchar] 'overwrite-mode)
;; The following function allows filename completion in the buffer
;; (file name completion in the minibuffer is usually available if you
;; have to enter a file name in the minibuffer).
;; from comint.el: filename completion
(autoload 'comint-dynamic-complete-filename
  "comint" "Complete filenames." t)



;; simple math using calculator
(autoload 'calculator "calculator" "Simple calculator." t)

;; (defun calculator-buffer ()
;;   (if (get-buffer "*caluclator*")
;;       ()))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mouse wheel: try it with S and C
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)

(defun up-one () (interactive) (scroll-up 1)) ;key set in keymap.el
(defun down-one () (interactive) (scroll-down 1)) ;key set in keymap.el

(unless (featurep 'xemacs)
    (progn
      (global-set-key [S-mouse-4] 'down-one)
      (global-set-key [S-mouse-5] 'up-one)))

(defun up-a-lot () (interactive) (scroll-up))
(defun down-a-lot () (interactive) (scroll-down))

(unless (featurep 'xemacs)
    (progn
      (global-set-key-if-unbind [C-mouse-4] 'down-a-lot)
      (global-set-key-if-unbind [C-mouse-5] 'up-a-lot)))
;;;;;;;

;; MAN PAGE FOR SYS CALLS
(global-set-key-if-unbind  [(f4)]
		 (lambda ()
		   (interactive)
		   (manual-entry (current-word))))

;;customization of major modes
(setq auto-mode-alist
      (append (list
               '("\\.mpl$" . maplev-mode)
               '("\\.cfg$" . python-mode)
               '("\\.py$" . python-mode)
               '("\\.php$" . php-mode)
	      ;; '("\\.crm$" . crm114-mode)
	      ;; '("/etc/apache2/.*\\.\\(conf$\\|load$\\)" . apache-mode)
	      ;; '("\\.r$" . R-mode)
	      ;; '("\\.ahk$"  ahk-mode)
               `("\\.html$" . ,(if (functionp 'html-helper-mode) 'html-helper-mode 'html-mode))
               `("\\.html.tmpl$" . ,(if (functionp 'html-helper-mode) 'html-helper-mode 'html-mode))
               '("Makefile" . makefile-mode)
               )
      auto-mode-alist))

;; remember www.maruko.ca/i18n/
;; (if (not running-xemacs) nil ))

;; http://www.gnu.org/software/emacs/manual/html_node/emacs/Terminal-Coding.html
;; (set-keyboard-coding-system nil)

(xrequire 'elscreen)

;; ;; From Eric Richmond
;; (if (not running-xemacs)
;;     ( progn (autoload 'server-edit "server" nil t)
;;           (server-edit))
;;   (server-edit))



(when (functionp 'zone-leave-me-alone)
  (zone-leave-me-alone))

(xrequire 'redo)


;; Amazing http://www.emacswiki.org/cgi-bin/wiki?EmacsNiftyTricks
(setq hcz-set-cursor-color-color "")
(setq hcz-set-cursor-color-buffer "")
(defun hcz-set-cursor-color-according-to-mode ()
  "change cursor color according to some minor modes."
  ;; set-cursor-color is somewhat costly, so we only call it when needed:
  (let ((color
         (if buffer-read-only "black"
             (if overwrite-mode "red" "coral"))))
                 ;;"blue"))))
    (unless (and
             (string= color hcz-set-cursor-color-color)
             (string= (buffer-name) hcz-set-cursor-color-buffer))
      (set-cursor-color (setq hcz-set-cursor-color-color color))
      (setq hcz-set-cursor-color-buffer (buffer-name)))))
(add-hook 'post-command-hook 'hcz-set-cursor-color-according-to-mode)
;; throwing warnnings
;; In hcz-set-cursor-color-according-to-mode:
;; misc.el:234:31:Warning: reference to free variable
;;     `hcz-set-cursor-color-color'
;;     `hcz-set-cursor-color-buffer'
;;     `hcz-set-cursor-color-color'
;;     `hcz-set-cursor-color-buffer'
;;     `whitespace-auto-cleanup'




;; delete trailing save before sving. Is it good :-)
(add-hook 'before-save-hook 'delete-trailing-whitespace)
(remove-hook 'before-save-hook 'untabify)
; (remove-hook 'before-save-hook 'delete-trailing-whitespace)

;; To customize the color of the background, use the code
;; below. Command list-colors-display displays all available colors.
;; (set-face-background 'hl-line "IndianRed") ;; using the color name
;; (set-face-background 'hl-line "#8b4513")   ;; using html code
;;}}

(put 'downcase-region 'disabled nil)

(put 'upcase-region 'disabled nil)

(put 'narrow-to-region 'disabled nil)

(put 'narrow-to-page 'disabled nil)

(put 'set-goal-column 'disabled nil)

(deh-require-maybe flymake               ;excellent
  (add-hook 'find-file-hook 'flymake-find-file-hook))


;; from http://www.dotemacs.de/dotfiles/DavidJolley.emacs.html
;; Load whitespace.el library. Nukes trailing whitespace from the ends
;; of lines, and deletes excess newlines from the ends of buffers.
;;
;; get it from: http://www.dsmit.com/lisp/
(deh-require-maybe whitespace
  (setq whitespace-auto-cleanup t)
  (when (functionp 'whitespace-global-mode)
    (whitespace-global-mode 1)))



;; see http://cl-cookbook.sourceforge.net/.emacs for common lisp
;;     http://sugarshark.com/elisp/init/lisp.el.html

(if (file-directory-p *work-dir*)
    (cd *work-dir*))


(deh-require-maybe smart-operator)


(deh-require-maybe thingatpt)
(deh-require-maybe thingatpt+)

(deh-require-maybe (progn help+ help-fns+ help-macro+ help-mode+)
  )

(deh-require-maybe (progn ido-load-library kill-ring-ido kill-ring-search)
  )


(deh-section "Close all frame"
  (defun close-all-frames ()
    (interactive)
    (dolist (f (frame-list))
      (delete-frame f t))))

(defun hindi-devanagari-itrans ()
  (interactive)
  (if (string-equal current-input-method "devanagari-itrans")
      (set-input-method nil nil)
      (set-input-method "devanagari-itrans" nil)))


(deh-require-maybe imenu-tree
  (setq imenu-tree-windata '(frame right 0.2 delete)))


(deh-require-maybe (progn pastie pastbin paste2)
  )


(deh-require-maybe oneliner
  (setq oneliner-temp-dir-name (if (getenv "TMPDIR")
                                   (expand-file-name (getenv "TMPDIR"))
                                   (expand-file-name "temp" (getenv "HOME"))
                                   ;; (error "test")
                                   )
        oneliner-debug t
        oneliner-shell-type 'zsh
        oneliner-sync-default-directory-after-prompt t)


  (defadvice oneliner (around shell-call-shell-file-name activate)
    ;; I can not make (env ESELL) to zsh, becasue of tramp
    ;; see in tramp-config.el
    ;; oneliner choose shell-type by shell-file-name
    "make (shell) to prefer shell-file-name"
    (let ((explicit-shell-file-name shell-file-name))
      ad-do-it))


  (defun cd-tramp-absolute (dir &optional base-directory)
    (let* ((tramp-prefix "\\`/[^/]+[@:][^:/]+:")
           (base-directory (or base-directory default-directory))
           (prefix (if (string-match tramp-prefix base-directory)
                       (match-string 0 base-directory)))
           (tdir (concat  prefix dir)))
      (cd-absolute tdir)))

  (require 'utils-config)

  (defun get-tramp-env (variable)
    (with-temp-buffer
      (process-file "bash" nil t nil "-c" (concat "echo $" variable) )
      (trim-string (buffer-string))))


  (defun shell-process-cd (arg)
    (let ((new-dir (cond ((zerop (length arg)) (concat comint-file-name-prefix
                                                       (get-tramp-env "HOME")))
                         ((string-equal "-" arg) shell-last-dir)
                         (t (shell-prefixed-directory-name arg)))))
      (setq shell-last-dir default-directory)
      (shell-cd new-dir)
      (shell-dirstack-message))))


(deh-section "crontab-mode"
  (autoload 'crontab-mode "crontab-mode.el" "Major mode for editing your crontab file." t))



(deh-section "centered-cursor-mode"
  (defun centered-cursor-stay-same-pos ()
    (interactive)
    (unless (ad-find-advice 'ccm-first-start 'before 'reset-ccm-vpos)
      (defadvice ccm-first-start (before reset-ccm-vpos (animate) activate)
        (setq ccm-vpos nil) t))
    (setq ccm-vpos-init
          '(or ccm-vpos
            (1- (count-lines (window-start) (point)))))
    (ad-enable-advice 'ccm-first-start 'before 'reset-ccm-vpos)
    (ad-activate #'ccm-first-start)
    (ad-update #'ccm-first-start))

  (defun centered-cursor-unstay-same-pos ()
    (interactive)
    (unless (ad-find-advice 'ccm-first-start 'before 'reset-ccm-vpos)
      (defadvice ccm-first-start (before reset-ccm-vpos (animate) activate)
        (setq ccm-vpos nil) t))
    (setq ccm-vpos-init
          (default-value 'ccm-vpos-init))
    (ad-disable-advice 'ccm-first-start 'before 'reset-ccm-vpos)
    (ad-activate #'ccm-first-start)
    (ad-update #'ccm-first-start))

  (defun centered-cursor-toggle-stay-same-pos ()
    (interactive)
    (if (eq ccm-vpos-init
            (default-value 'ccm-vpos-init))
        (centered-cursor-stay-same-pos)
        (centered-cursor-unstay-same-pos)))

  (defalias 'toggle-ccm-stay 'centered-cursor-toggle-stay-same-pos)
  (defalias 'ccm-stay 'centered-cursor-stay-same-pos)
  (defalias 'ccm-unstay 'centered-cursor-unstay-same-pos)

  (defalias 'ccm 'centered-cursor-mode))




(deh-section "New"
  (deh-require-maybe ipa
    ;;http://www.emacswiki.org/emacs/InPlaceAnnotations
    )
  (deh-require-maybe alert
    ;;http://www.emacswiki.org/emacs/alert.el
    )
  (deh-require-maybe org-pua
    ;;http://www.emacswiki.org/emacs-es/org-pua.el
    )
  )



(provide 'misc-config)
