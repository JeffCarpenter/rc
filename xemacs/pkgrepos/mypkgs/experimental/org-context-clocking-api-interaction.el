;;; org-context-clocking-api-interaction.el --- org-context-clocking-api               -*- lexical-binding: t; -*-

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

;; "Interactive utitlity API's for adding root subtree etc"

(defun org-property-set-function (property fun)
  "fun is like org-icompleting-read
 (completing-read PROMPT COLLECTION &optional PREDICATE REQUIRE-MATCH INITIAL-INPUT HIST DEF INHERIT-INPUT-METHOD)"
  (push
   (cons property fun)
   org-property-set-functions-alist))


(progn
  ;; (setq org-property-set-functions-alist nil)
  (org-property-set-function "Root"
                             '(lambda (&rest args)
                               (ido-read-directory-name
                                (car args)
                                default-directory default-directory)))
  (org-property-set-function "SubtreeFile"
                             '(lambda (&rest args)
                               (file-relative-name
                                (ido-read-file-name ;; org-iread-file-name
                                 (car args)
                                 default-directory default-directory)))))
(defun task-info-add-root ()
  (interactive)
  (if (org-set-property "Root" nil)
      (org-clocking-entry-update-task-infos t)))
(defun task-info-add-subtree-file ()
  (interactive)
  (if (org-set-property "SubtreeFile" nil)
      (org-clocking-entry-update-task-infos t)))


(provide 'org-context-clocking-api-interaction)
;;; org-context-clocking-api-interaction.el ends here
