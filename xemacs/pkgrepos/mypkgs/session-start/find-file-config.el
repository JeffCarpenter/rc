;;; find-file-config.el --- files

;; Copyright (C) 2012  Sharad Pratap

;; Author: Sharad Pratap <>
;; Keywords:

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


(deh-require-maybe locations
  ;; may be good
  ;; https://www.assembla.com/code/saintamh/subversion/nodes/2389/emacs/.emacsd/locations.el
  )





(deh-section "find-file-wizard"

  (defvar *find-file-wizard-alist* nil "find-file-wizard-alist")
  (setq *find-file-wizard-alist* nil)

  (defun find-file-wizard-add (name ff &optional setup failval)
    "hook where initial set could be defined\n
"

    (unless setup
      (setq setup
            (lambda (ff initial-string)
              (let (oldbinding)
                (minibuffer-with-setup-hook
                    (lambda ()
                      ;; (key-binding key t)
                      (setq oldbinding (key-binding (kbd "s-f") t))
                      ;; (local-set-key key binding)
                      (local-set-key
                       ;; (define-key minibuffer-local-completion-map
                       (kbd "s-f") ;; (plist-get plist :key)
                       (lambda (arg)
                         (interactive "P")
                         (message "oldbinding %s" oldbinding)
                         (if oldbinding
                             (local-set-key (kbd "s-f") oldbinding)
                             (local-unset-key (kbd "s-f")))
                         (setq initial-string ido-text
                               ;; ido-text 'fallback-wizard
                               ;; ido-exit 'done
                               )
                         ;; (exit-minibuffer)
                         (throw 'nextff (list 'next (list (cons :initial-string initial-string)))))))
                  (funcall ff initial-string))))))

    (if (assoc name *find-file-wizard-alist*)
        (setcdr
         (assoc name *find-file-wizard-alist*)
         (list :ff ff :setup setup :failval failval))
        (let ((elt (cons name (list :ff ff :setup setup :failval failval))))
          (push elt *find-file-wizard-alist*))))


  ;;  (pop *find-file-wizard-alist*)
  ;; (define-key minibuffer-local-map (kbd "C-f") 'forward-char)

  (find-file-wizard-add "ffip"
      ;; ido-find-file
      (lambda (initstr)
        (setq minibuffer-history (delete 'fallback-wizard minibuffer-history))
        (ffip)))

  (find-file-wizard-add "contentswitch"
      ;; ido-find-file
      (lambda (initstr)
        (setq minibuffer-history (delete 'fallback-wizard minibuffer-history))
        (contentswitch)))

  (find-file-wizard-add "find-file"
      ;; ido-find-file
      (lambda (initstr)
        (setq minibuffer-history (delete 'fallback-wizard minibuffer-history))
        (find-file
         (find-file-read-args "Find file: "
                        (confirm-nonexistent-file-or-buffer))))

      (lambda (ff initial-string)
        (let (oldbinding)
         (minibuffer-with-setup-hook
            (lambda ()
              ;; (key-binding key t)
              (setq oldbinding (key-binding (kbd "s-f") t))
              ;; (local-set-key key binding)
              (local-set-key
              ;; (define-key minibuffer-local-completion-map
               (kbd "s-f") ;; (plist-get plist :key)
                (lambda (arg)
                  (interactive "P")
                  (message "oldbinding %s" oldbinding)
                  (if oldbinding
                      (local-set-key (kbd "s-f") oldbinding)
                      (local-unset-key (kbd "s-f")))
                  (setq initial-string ido-text
                        ;; ido-text 'fallback-wizard
                        ;; ido-exit 'done
                        )
                  ;; (exit-minibuffer)
                  (throw 'nextff (list 'next (list (cons :initial-string initial-string)))))))
          (funcall ff initial-string)))))

  (find-file-wizard-add "lusty"
      ;; ido-find-file
      (lambda (initstr)
        (setq minibuffer-history (delete 'fallback-wizard minibuffer-history))
        (lusty-file-explorer))

      (lambda (ff initial-string)
        (let ((lusty-setup-hook
               (cons
                (lambda ()
                  (define-key lusty-mode-map
                      (kbd "s-f") ;; (plist-get plist :key)
                    (lambda (arg)
                      (interactive "P")
                      (setq initial-string ido-text
                            ;; ido-text 'fallback-wizard
                            ;; ido-exit 'done
                            )
                      ;; (exit-minibuffer)
                      (throw 'nextff (list 'next (list (cons :initial-string initial-string)))))))
                lusty-setup-hook)))
          (funcall ff initial-string))))


  (find-file-wizard-add "idorelative"
      ;; TODO
      ;; ido-find-file
      (lambda (initstr)
        (setq minibuffer-history (delete 'fallback-wizard minibuffer-history))
        (find-same-file-in-relative-dir))


      (lambda (ff initial-string)
        (let ((ido-setup-hook
               (cons
                (lambda ()
                  (define-key ido-completion-map ;; ido-mode-map
                      (kbd "s-f") ;; (plist-get plist :key)
                    (lambda (arg)
                      (interactive "P")
                      (setq initial-string ido-text
                            ido-text 'fallback-wizard
                            ido-exit 'done)
                      ;; (message "magic Alambda3: ido-text: %s initial-string: %s" ido-text initial-string)
                      ;; (exit-minibuffer)
                      (throw 'nextff (list 'next (list (cons :initial-string initial-string))))
                      ;; (message "magic Alambda3x: ido-text: %s initial-string: %s" ido-text initial-string)
                      )))
                ido-setup-hook)))
          (funcall ff initial-string))))


  (find-file-wizard-add "idoff"
      ;; ido-find-file
      (lambda (initstr)
        (setq minibuffer-history (delete 'fallback-wizard minibuffer-history))
        (ido-find-file))


      (lambda (ff initial-string)
        (let ((ido-setup-hook
               (cons
                (lambda ()
                  (define-key ido-completion-map ;; ido-mode-map
                      (kbd "s-f") ;; (plist-get plist :key)
                    (lambda (arg)
                      (interactive "P")
                      (setq initial-string ido-text
                            ido-text 'fallback-wizard
                            ido-exit 'done)
                      ;; (message "magic Alambda3: ido-text: %s initial-string: %s" ido-text initial-string)
                      ;; (exit-minibuffer)
                      (throw 'nextff (list 'next (list (cons :initial-string initial-string))))
                      ;; (message "magic Alambda3x: ido-text: %s initial-string: %s" ido-text initial-string)
                      )))
                ido-setup-hook)))
          (funcall ff initial-string))))



    (defun find-file-wizard ()
      (interactive)
      (let ((wizard-alist *find-file-wizard-alist*)
            (plist (cdar *find-file-wizard-alist*))
            ;; (file 'fallback-wizard)
            (retval '(next))
            initial-string)
        (while (and wizard-alist ;; (eq file 'fallback-wizard)
                    (and (consp retval) (eq 'next (car retval))))
          ;; (message "fileB: %s" file)
          (letf ((plist (cdar wizard-alist))
                 (initial-string (plist-get (cdr retval) :initial-string)))
            (let ((failval  (plist-get plist :failval))
                  (ffretval (catch 'nextff
                              (condition-case e
                                  (funcall (plist-get plist :setup) (plist-get plist :ff) initial-string)
                                (error '(next))))))
              (if (eq failval ffretval)
                  (setq retval '(next)))
              (setq wizard-alist (or (cdr wizard-alist)
                                     (setq wizard-alist *find-file-wizard-alist*))))))))


    (global-set-key-if-unbind (kbd "s-x s-f") 'find-file-wizard))










(deh-section "ffap trouble"

  (require 'ffap)

  (defun ignore-ffap-p (name abs default-directory)
  (string-match "\\*\\*\\*\\*" name))

  (defadvice ffap-file-at-point (around ignore-ffap activate)
    "calculate ignore criteria to no call ffap"
    ;; Note: this function does not need to look for url's, just
    ;; filenames.  On the other hand, it is responsible for converting
    ;; a pseudo-url "site.com://dir" to an ftp file name
    (let* ((case-fold-search t)		; url prefixes are case-insensitive
           (data (match-data))
           (string (ffap-string-at-point)) ; uses mode alist
           (name
            (or (condition-case nil
                    (and (not (string-match "//" string)) ; foo.com://bar
                         (substitute-in-file-name string))
                  (error nil))
                string))
           (abs (file-name-absolute-p name))
           (default-directory default-directory)
           (oname name))
      (unless (ignore-ffap-p name abs default-directory)
        ad-do-it)))




  (deh-section "fallback from ffap"


    (deh-require-maybe (and ffap ido)

      (defun ido-plain-directory ()
        "Read current directory again.
May be useful if cached version is no longer valid, but directory
timestamp has not changed (e.g. with ftp or on Windows)."
        (interactive)
        (if (and ido-mode (memq ido-cur-item '(file dir)))
            (progn
              (if (ido-is-unc-root)
                  (setq ido-unc-hosts-cache t)
                  (ido-remove-cached-dir ido-current-directory))
              (setq ido-current-directory default-directory)
              ;; (setq ido-text-init ido-text)
              (setq ido-text-init "")
              (setq ido-rotate-temp t)
              (setq ido-exit 'refresh)
              (exit-minibuffer))))

      ;; ido-file-completion-map is only defined when ido-mode is called.
      (add-hook 'ido-setup-hook
                (lambda ()
                  (keymap-set-key-if-unbind
                   ido-file-completion-map
                   (kbd "C-.")
                   'ido-plain-directory)))
      )))


(provide 'find-file-config)
;;; find-file-config.el ends here
