;;; paths-mapper.el ---                           -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Sharad

;; Author: Sharad <sh4r4d at _Gmail_ >
;; Keywords: abbrev

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

(provide 'paths-mapper)

(require 's)                            ;https://github.com/magnars/s.el
(eval-when-compile
  '(require 'cl))

(defvar paths-mapper-map nil)
;; store this in desktop and session
;; (setq paths-mapper-map nil)

(require 'desktop)
(require 'session)


(add-to-list 'desktop-locals-to-save 'paths-mapper-map)
(add-to-list 'session-locals-include 'paths-mapper-map)

(defun paths-mapper-filter-path (path)
  (when path
    (let* ((matched-paths (mapcar
                           #'(lambda (p)
                               (when (s-starts-with? (car p) path)
                                 (if (string-equal (car p) path)
                                     (cdr p)
                                   (when (file-name-directory path)
                                    (expand-file-name
                                     (s-chop-prefix (concat (car p) "/") path) ;fixit
                                     (cdr p))))))
                           paths-mapper-map))
           (existing-matched-paths (remove-if-not #'file-exists-p (remove nil matched-paths))))
      (message "filering [%s] for %s" existing-matched-paths path)
      (if existing-matched-paths
          (car existing-matched-paths)
        path))))

(defun rl-string-len-compare (s1 s2)
  (> (length (car s1)) (length (car s2))))

(defun paths-mapper-add-replacement (path replacement)
  (message "paths-mapper-add-replacement: path=%s replacement=%s"
           path replacement)
  (if (and
         replacement
         (stringp replacement)
         (file-exists-p replacement))   ;check
  ;; remove common suffix
    (let* ((suffix       (s-shared-end path replacement))
           (spath        (s-chop-suffix suffix path))
           (sreplacement (s-chop-suffix suffix replacement)))
      (push (cons spath sreplacement) paths-mapper-map) ;here make case for unreloved path with cdr as nil
      (setq paths-mapper-map
            (sort paths-mapper-map #'rl-string-len-compare)))))

(defun paths-mapper-read-replacement (path &optional again)
  (let ((modpath (read-file-name
                  (format
                   (if again
                       "again replacement for %s: "
                       "replacement for %s: ")
                   path)
                  (dirname-of-file path))))
    (when (<= (or again 0) 3)
      (if (and
           ;; (file-name-directory path)
           (string-equal
            (file-name-nondirectory path)
            (file-name-nondirectory modpath)))
          modpath
        (progn
          (message "wrong %s read for %s, read again" modpath path)
          (paths-mapper-read-replacement path (1+ (or again 0))))))))

(defun paths-mapper-read-add-replacement (path)
  (let ((replacement-path (paths-mapper-read-replacement path)))
    (message "paths-mapper-read-add-replacement: replacement-path=%s"
             replacement-path)
    (paths-mapper-add-replacement path replacement-path)))

;; test
;; (paths-mapper-read-add-replacement "/home/spratap/.opt/p/merunetworks.com/rcfun")
;; (paths-mapper-filter-path "/home/spratap/.opt/p/merunetworks.com/rcfun")

;;; paths-mapper.el ends here
