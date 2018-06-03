;;; occ-common.el --- occ-api               -*- lexical-binding: t; -*-
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

;; TODO org-base-buffer

;; https://stackoverflow.com/questions/12262220/add-created-date-property-to-todos-in-org-mode

;; "org tasks accss common api"
    ;; (defvar org-)
(defvar occ-verbose 0)



(defun sym2key (sym)
  (if (keywordp sym)
      sym
    (intern-soft (concat ":" (symbol-name sym)))))
(defun sym2key (sym)
  (if (keywordp sym)
      (intern-soft (concat ":" (symbol-name sym)))
    sym))
(defun cl-classname (inst)
  (intern
   (substring
    (symbol-name (aref inst 0))
    (length "cl-struct-"))))
(defun cl-get-field (object field)
  (cl-struct-slot-value (cl-classname object) field object))
(defun cl-set-field (object field value)
  (setf (cl-struct-slot-value (cl-classname object) field object) value))
(defun class-slots (class)
  (mapcar
   #'(lambda (slot) (aref slot 1))
   (cl--struct-class-slots
    (cl--struct-get-class class))))



(provide 'occ-common)
;;; occ-common.el ends here
