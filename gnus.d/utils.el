;;; utils.el ---

;; Copyright (C) 2012  Sharad Pratap

;; Author: Sharad Pratap <sh4r4d@gmail.com>
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

(defun google-lucky (search-str)
  (concat search-str " [http://www.google.com/search?hl=en&&q="
          (string-replace-match "\s" search-str "+" t t)
          "&btnI=1]"))




;; (defun string-apply-fn (search-str &optional fn)

(defun string-apply-fn ()
  (interactive)
   (let* ((region-active (and (region-active-p)
                              (not (equal (region-beginning) (region-end)))))
          (bound (if region-active
                     (cons (region-beginning) (region-end))
                     (bounds-of-thing-at-point 'word)))
          (search-str (funcall #'buffer-substring (car bound) (cdr bound)))
          (fn #'google-lucky))
     ;; (list search-str fn)
     (funcall #'delete-region (car bound) (cdr bound))
     ;; (read-from-minibuffer (format "asf %d %d" (car bound)  (car bound)))
     (insert (funcall fn search-str))
     ;; (insert  " " (funcall fn search-str))
     ))








(user-provide 'utils)
;;; utils.el ends here
