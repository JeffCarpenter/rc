;;; package-config.el --- package

;; Copyright (C) 2012  Sharad Pratap

;; Author: Sharad Pratap <>
;; Keywords: lisp

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





;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.

;; (when
;;     (load
;;      (expand-file-name "~/.xemacs/elpa/package.el"))
;;   (package-initialize))

(eval-after-load "package"
  '(progn

    (require 'cl)
    (require 'utils-config)

    (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))

    (add-to-list 'package-archives '("ELPA" . "http://tromey.com/elpa/"))

    (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))

    (defconst *elpa-package-dir* "~/.xemacs/pkgrepos/elpa")

    (when (file-directory-p *elpa-package-dir*)
      (mapc #'(lambda (path)
                (when (file-directory-p path)
                  (add-to-list 'load-path path)))
            (directory-files *elpa-package-dir* t "[a-zA-Z]+"))
      (byte-recompile-directory *elpa-package-dir*))

    (setq package-user-dir
     (expand-file-name (convert-standard-filename "~/.xemacs/pkgrepos/elpa")))
    (package-initialize)

    (defvar sharad/package-installed-archive "~/.xemacs/pkgrepos/elpa/installed-archive.el" "Known Installed packages.")

    (defun sharad/update-installed-package-archive ()
      (interactive)
      (if package-alist
          (write-region
           (with-output-to-string
               (pp package-alist))
           ;; (prin1-to-string package-alist)
           nil sharad/package-installed-archive)
          (message "package-alist is not defiend, not doing anything.")))

    (defun sharad/package-install-from-installed-archive ()
      (interactive)
      (require 'cl)
      (let* ((packages-from-installed-archive  (mapcar 'car  (sharad/read-file sharad/package-installed-archive)))
             (packages-from-package-alist (mapcar 'car package-alist))
             (packages-missing (set-difference packages-from-installed-archive packages-from-package-alist)))
        (if packages-missing
            (progn
              (package-refresh-contents)
              (dolist (p packages-missing)
              (package-install p)))
            (message "No missing package found."))))

    (when (file-exists-p sharad/package-installed-archive)
      (when (set-difference (mapcar 'car  (sharad/read-file sharad/package-installed-archive))
                            (mapcar 'car package-alist))
        (message "Your do not have all packages installed.\n install it will sharad/package-install-from-installed-archive.")))))


(autoload 'package-list-packages "package" "Elap Package" t)
(autoload 'list-packages "package" "Elap Package" t)
(autoload 'package-install "package" "Elap Package" t)



(deh-require-maybe (progn
                     apt-utils
                     apt-utils-ido
                     ;; apt-mode ;; http://www.netfort.gr.jp/~dancer/software/downloads/list.cgi#apt-el
                     apt
                     apt-elserv
                     helm-apt)
  ;; make  function to install missing package.

  )


(provide 'package-config)

;;; package.el ends here

