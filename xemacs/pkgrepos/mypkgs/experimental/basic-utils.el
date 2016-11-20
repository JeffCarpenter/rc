;;; basic-utils.el --- Basic utilities               -*- lexical-binding: t; -*-

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

(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

(defvar reloading-libraries nil "used in session-conf.el")


(defun package-dir-add-to-loadpath (package-dir &optional recursive)
  (when (file-directory-p package-dir)
    (mapc
     (if recursive
         (lambda (path)
           (add-to-list 'load-path path)
           (let ((default-directory path))
             (normal-top-level-add-subdirs-to-load-path)))
         (lambda (path)
           (add-to-list 'load-path path)))
     (remove-if-not
      'file-directory-p
      (directory-files package-dir t "[a-zA-Z]+")))))

(defun global-set-key-if-unbind (key cmd)
  "Set binding for key if there is no  existing binding for key."
  ;; (interactive)
  (let ((bindedcmd (key-binding key t)))
    (if bindedcmd
        (when (or (not *emacs-in-init*) (not reloading-libraries))
          (message "key %s already have binded with command %s, can't bind to %s."
                   key bindedcmd cmd))
        (global-set-key key cmd))))

(defun global-set-key-warn-if-bind (key cmd)
  "Set binding for key if there is no  existing binding for key."
  ;; (interactive)
  (let ((bindedcmd (key-binding key t)))
    (if bindedcmd
        (when (or (not *emacs-in-init*) (not reloading-libraries))
          (message "key %s already have binded with command %s, but binding to %s."
                   key bindedcmd cmd)))
        (global-set-key key cmd)))

(defun keymap-set-key-if-unbind (map key cmd)
  "Set binding for key if there is no  existing binding for key."
  ;; (interactive)
  (let ((bindedcmd (key-binding key t)))
    (if bindedcmd
        (when (or (not *emacs-in-init*) (not reloading-libraries))
          (message "key %s already have binded with command %s, can't bind to %s."
                   key bindedcmd cmd))
        (define-key map key cmd))))



(defun fprint (dir)
  "Print the current buffer with same file name."
  (interactive "DDirqectory to put: ")
  (let* ((fname (file-name-nondirectory
                (buffer-file-name)))
         (pname (concat (or dir default-directory) fname ".ps")))
    (ps-print-in-file pname)))



;;{{{ define xrequire

(defun xrequire (feature)
  (unless (member feature exclude-lib)
      (if (not running-xemacs)
          (require feature nil t)
          (require feature nil))))

(defun irequire (feature)
  (ignore-errors
    (unless (member feature exclude-lib)
      (if (not running-xemacs)
          (require feature nil t)
          (require feature nil)))))


;;}}}

;; Are we running XEmacs or Emacs?
(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))


(defun afind-if (fun list) ;; anaphoric
  (let ((result
         (funcall fun (car list))))
    (if result
        result
        (if list (afind-if fun (cdr list))))))




(defun run-each-hooks (hook)
  (dolist (f (symbol-value hook))
    (condition-case e
        (funcall f)
      (error (message "run-each-hooks Error: function %s error %s" f e)))))

(defun run-each-debug-hooks (hook)
  (dolist (f (symbol-value hook))
      (error (message "run-each-hooks Error: function %s error %s" f e))))




(when nil
  (defun toignore ()
    (message "asdfds"))


  (defalias 'toignore 'ignore)

  (fset 'alttoignore (symbol-function 'toignore))
  (fset 'ignore (symbol-function 'alttoignore))

  (toignore)
  (alttoignore))

(defvar *undefine-function-alist* nil "undefine-function-alist")

(defun undefine-function-remember (fnsym)
  "Use (redefine-function-remembered fnsym) to redefine."
  (unless (eq fnsym 'ignore)
   (push (cons fnsym (symbol-function fnsym))
         *undefine-function-alist*)
   (defalias fnsym 'ignore)))

(defun redefine-function-remembered (fnsym)
  "Use (undefine-function-remember fnsym) to undefine."
  (let ((fdef (assoc fnsym *undefine-function-alist*)))
    (if fdef
        (progn
          (fset fnsym (cdr fdef))
          (setq *undefine-function-alist*
                (del-alist (car fdef) *undefine-function-alist*)))
        (message "def for %s function is not available." fnsym))))



;; (add-hook 'aa-hook (lambda ()
;;                      (message "dsafds")))

;; (add-hook 'aa-hook (lambda ()
;;                      (message "errorQQ")
;;                      (error "Err")))


;; (run-each-hooks 'aa-hook)


;; (deh-section "dep"
(when nil
  (defadvice require (around compile-if-fail (feature &optional filename noerror) activate)
    (let ((ret (condition-case e
                   ad-do-it
                 ('error nil))))
      (if ret
          ret
          (let ((file (or
                       filename
                       (locate-library (symbol-name feature)))))

            (load-file file)
            (byte-compile-file file)
            ;; (require feature filename noerror)
            ))))

  (when nil
    (ad-disable-advice 'require 'around 'compile-if-fail)
    (ad-remove-advice 'require 'around 'compile-if-fail)
    (ad-update 'require)))


(defun load-dir-files (dir)
  (let (load-file-with-errors)
   (when (file-directory-p dir)
     (byte-recompile-directory dir 0)
     (mapc '(lambda (f)
             (if (not (ignore-errors (load-file f)))
                 (push f load-file-with-errors)))
           (directory-files dir t "^[a-zA-Z0-9-]+\.elc$"))
     (if load-file-with-errors
         (mapc 'load-file
               load-file-with-errors)
         t))))

(defun require-dir-libs (dir)
  (let (load-lib-with-errors
        reloading-libraries)
    (when (file-directory-p dir)
      (ignore-errors (byte-recompile-directory dir 0))
      (mapc (lambda (lib)
              (let ((feature (if (string-match "\\(.\+\\)\.el" lib)
                                 (intern (match-string 1 lib)))))
                (if feature
                  (unless
                      (and
                       (message "now loading %s.el" feature)
                       (with-report-error "check"
                           (require feature)))
                    (push feature load-lib-with-errors)))))
            (directory-files dir nil "^[a-zA-Z0-9-]+\.el$"))
      (if load-lib-with-errors
          (progn
            (setq reloading-libraries t)
            (message "now loading files ( %s ) with errors." load-lib-with-errors)
            (mapc '(lambda (f)
                    (message "now loading file with error %s.el" f)
                    (with-report-error "check"
                        (require f)))
                  load-lib-with-errors))
          (message "all library loaded in %s directory without error." dir))
      t)))

(defun add-element-to-lists (element lists)
  (dolist (list lists)
          (add-hook (intern (concat (symbol-name list) "-mode-hook")) element)))

(defun remove-element-from-lists (element lists)
  (dolist (list lists)
          (remove-hook (intern (concat (symbol-name list) "-mode-hook")) element)))

(defvar pgm-langs
  '(java
    c
    c++
    perl
    lisp
    emacs-lisp
    cperl
    js
    espresso
    ruby
    sh
    python) "Langauge modes.")

(defvar text-langs
  '(muse
    text))

(defvar reader-requester
  '(rfcview) "Modes that need reader.")

(defvar mode-used '(org planner)  "Modes used.")

(setq mode-used (append mode-used pgm-langs))


;;{{ Pathname Utilities
(deh-section "Pathname Utilities"
  (defun  pathname-end-with-/ (path)
    "Check if path name end with /"
    (equal (elt path (- (length path) 1)) ?/))

  (defun pathname-delete-trailing-/ (path)
    (if (pathname-end-with-/ path)
        (pathname-delete-trailing-/ (subseq path 0 (- (length path) 2)))
        path))

  (defun pathname-equal (p1 p2)
    "Pathname equality"
    (apply #'string-equal
           (mapcar #'pathname-delete-trailing-/ (list p1 p2))))

  ;; (testing
  ;;  (pathname-delete-trailing-/ "/sdfsd/sdgfdg////"))
  )



;;{{ --debug-init
(message "debug-on-error %s" debug-on-error)
;;}}


;;{{

(defun run-at-time-or-now (time fn)
  "Run FN at TIME if numeric is otherwise run now only."
  (if (numberp time)
      (run-with-timer time nil fn)
      (funcall fn)))

(defun run-at-time-or-now-arg (time fn arg)
  "Run FN with ARG at TIME if numeric is otherwise run now only."
  (if (numberp time)
      (run-with-timer time nil
                      (lambda (a) (funcall (car a) (cdr a)))
                      (cons fn arg))
      (funcall fn arg)))



(provide 'basic-utils)
;;; basic-utils.el ends here
