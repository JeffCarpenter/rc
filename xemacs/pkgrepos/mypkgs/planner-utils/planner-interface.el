;;; planner-interface.el --- Planner interface

;; Copyright (C) 2012  Sharad Pratap

;; Author: Sharad Pratap <sharad at home>
;; Keywords: lisp, convenience

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

(require 'general-testing)
(require 'cl)

(eval-when-compile
  '(require 'cl))

(require 'tree)

(defvar status-mappings nil "Status Mapping")

(defvar task-stati '(open inprogress completed cancelled delegated pending))

(defun pushnew-alist (key value list)
  (unless (assoc key list)
    (pushnew (cons key nil) list :key #'car))
   (pushnew value (cdr (assoc key list)) :test #'string-equal))

(defun task-status-map (sys status)
  (cdr (assoc sys (cdr (assoc status status-mappings)))))

(defun task-status-add-map (sys status sysstatus)
  (setf (tree-node* status-mappings status sys) sysstatus))

(defun task-status-add-maps (sys maps)
  (dolist (m maps)
    (task-status-add-map sys (car m) (cdr m))))

(task-status-add-maps 'planner
                      '((inprogress . "o")
                        (open       . "_")
                        (completed  . "C")
                        (cancelled  . "X")
                        (delegated  . "D")
                        (pending    . "P")))

;; (task-status-add-maps bugz ((completed .("CLOSED" "asdfdsaf"))))

;; single status query
(defun task-status-of-sys (sys status &optional mappings)
  (let* ((mappings (or mappings status-mappings))
         (rstatus (cdr (assoc sys (cdr (assoc status mappings))))))
    rstatus))

(defun task-map-from-sys-status (sys status &optional mappings)
  (let* ((mappings (or mappings status-mappings))
        (map (find status mappings
                   :key #'(lambda (e)
                            (cdr (assoc sys (cdr e))))
                   :test #'(lambda (statusa statusb)
                             (if (consp statusb)
                                 (member statusa statusb)
                                 (string-equal statusa statusb))))))
    map))

(defun task-status-from-sys-status (sys status &optional mappings)
  (car (task-map-from-sys-status sys status)))

(defun task-src-status-to-trg-status (src status trg &optional mappings)
  (cdr (assoc trg (cdr (task-map-from-sys-status src status)))))

;; status list query

(defun task-stati-of-sys (sys stati &optional mappings)
  (let* ((mappings (or mappings status-mappings))
         (rstatus
          (if (consp stati)
              (loop for s in stati
                 collect (task-status-of-sys sys s mappings))
              (task-status-of-sys sys stati mappings))))
    rstatus))

(defun task-maps-from-sys-stati (sys stati &optional mappings)
  (let* ((mappings (or mappings status-mappings))
         (map (if (consp stati)
                  (loop for s in stati
                       collect (task-map-from-sys-status sys s mappings))
                  (task-map-from-sys-status sys stati mappings))))
    map))

(defun task-stati-from-sys-stati (sys stati &optional mappings)
  (if (consp stati)
      (car (task-map-from-sys-status sys stati mappings))
      (mapcar #'car (task-maps-from-sys-stati sys stati mappings))))

(defun task-src-stati-to-trg-stati (src stati trg &optional mappings)
  (if (consp stati)
      (mapcar #'(lambda (map)
                  (cdr (assoc trg (cdr map))))
              (task-maps-from-sys-stati src stati mappings))
      (cdr (assoc trg (cdr (task-map-from-sys-status src stati mappings))))))

(testing

 (task-status-add-maps bugz ((pending ."ASSIGNED")))
 (macroexpand '(task-status-add-maps bugz ((pending ."ASSIGNED"))))

 (macroexpand '(task-status-add-maps bugz ((completed . "CLOSED"))))



 (task-status-add-map 'bugz '(completed . ("CLOSED")))
 (task-status-add-map bugz completed ("CLOSED"))

 (macroexpand '(task-status-add-map bugz completed ("CLOSED")))





 (cdr (assoc 'open status-mappings))
 (task-status-map 'planner 'open))

(defun planner-today-ensure-exists ()
  (let ((tramp-mode nil))
   (unless (file-exists-p (concat planner-directory (planner-today) ".muse"))
    (save-excursion
      (save-window-excursion
        (calendar)
        (plan))))
   (planner-today)))

(defun planner-task-lists (plan)
  (let ((tramp-mode nil))
    (planner-extract-tasks
     (list (cons plan (concat planner-directory "/" plan ".muse"))))))

;;test
;;
(testing
 (planner-task-lists (planner-today-ensure-exists)))


(defun planner-plans-on-task-lists-main (task-lists)
  (remove-duplicates
   (apply
    'append
    (mapcar
     '(lambda (task)
        (split-string (nth 6 task) ","))
     task-lists))
   :test 'equal))

(defun planner-plans-on-task-lists (task-lists)
  (mapcar
   '(lambda (str)
     (if (string-match "\\[\\[\\(\\S\\+\\)\\]\\]" str)
         (replace-match "\\1" t nil str)))
   (planner-plans-on-task-lists-main task-lists)))

;; (defun planner-plans-on-task-lists (task-lists)
;;   (mapcar
;;    '(lambda (str)
;;      (let ((task
;;             (if (string-match "\\[\\[\\(\\S\\+\\)\\]\\]" str)
;;                 (replace-match "\\1" t nil str))))
;;      (cons task task)))
;;    (planner-plans-on-task-lists-main task-lists)))

;; test
(testing
 (let ((str "[[TaskBy]]"))
   (if (string-match "\\[\\[\\(\\S\\+\\)\\]\\]" str)
       (replace-match "\\1" t nil str))))

;;test
(testing
 (planner-plans-on-task-lists
  (planner-task-lists (planner-today-ensure-exists))))

(defun planner-plans-on-page (page)
  (planner-plans-on-task-lists
   (planner-task-lists page)))

(defun planner-plans-on-today ()
  (planner-plans-on-page (planner-today-ensure-exists)))

(testing
 (planner-plans-on-today))

;; (defun planner-task-lists-if (test task-lists &key fun)
;;   (loop for task in task-lists          ;lisp is beautiful !!
;;         when (funcall test task)
;;         collect (if fun (funcall fun task) task)))

(defun planner-task-lists-if (test task-lists &key fun)
  (mapcar fun
          (remove-if-not test task-lists)))

;;start: one way to get tasks of plan from one page
(defun task-lists-of-plan-with-status-p (task plan status)
  (and
   (member (concat "[[" plan "]]") (nth 5 task))
   (member (nth 3 task) status)))

;; (defvar planner-task-simple-name-regex "^\\(.\+\}\}\\)\\(\s\+[[][[]\\)\?" "planner task simple name regex")
;; b39437 code: Un reason (0x0001) {{Tasks:42}}
(defvar planner-task-simple-name-regex "^\\(.\+\\)\s\{\{" "planner task simple name regex")
;; b39437 code: Un reason (0x0001)


(defun extract-task-name (task)
  (if (string-match "^\\(.\+\}\}\\)\\(\s\+[[][[]\\)\?" task)
      (match-string 1 task)))
  ;; (if (string-match "^\\(.\+\}\}\\)\s\+" task)

(defun extract-task-name (task)
  ;; (if (string-match "^\\(.\+\}\}\\)\s\+[[][[]" task)
  ;; (if (string-match "^\\(.\+\}\}\\)\s\+" task)
  (let* ((task-with-links-removed
          (if (string-match planner-task-simple-name-regex task)
              (match-string 1 task)
              task))
         (task-with-links-url-removed
          (replace-regexp-in-string
           "\s*[[][[].*[]][[]url[]][]]"
           ""
           task-with-links-removed)))
    task-with-links-url-removed))


(testing
 (kill-new
  (extract-task-name
   "b39437 code: Un reason (0x0001) [[https://bugzilla.merunetworks.com/bugzilla/show_bug.cgi?id=39437][url]] {{Tasks:42}} ([[2013.08.14]],[[MyMIS]],[[TasksByProject]])")))

(defun extract-task-name-from-list (task-list)
  (extract-task-name (nth 4 task-list)))

(defun planner-tasks-of-plan-from-page (page plan status) ;should be fault tolrent.
  (planner-task-lists-if                         ;else face lot of time waste.
   '(lambda (task)
     (task-lists-of-plan-with-status-p task plan status))
   (planner-task-lists page)
   :fun #'extract-task-name-from-list))
;;end

;;test
(testing
 (planner-task-lists-if
  '(lambda (task) (task-list-of-plan-with-status-p task (planner-today-ensure-exists) '("_" "o")))
  (planner-task-lists (planner-today-ensure-exists))
  :fun #'extract-task-name-from-list))

;;start: another way to get tasks of plan from one page
(defun task-lists-with-status-p (task status)
  (member (nth 3 task) status))

(defun planner-tasks-from-page (page &optional status)
  (planner-task-lists-if
   (if status
       '(lambda (task)
         (task-lists-with-status-p task plan status))
       'identity)
   (planner-task-lists page)
   :fun '(lambda (task-list) (nth 4 task-list))))

(defun planner-tasks-of-pages-intersection (plan1 plan2 status)
  (intersection
   (planner-tasks-from-page plan1 status)
   (planner-tasks-from-page plan2 status)))
;;end

;;test
(testing
 (planner-tasks-of-plan-from-page
  (planner-today-ensure-exists) "LinuxMIS" '("_" "o")))

;;should be fault tolrent. else face lot of time waste.
(defun planner-tasks-of-plan-today (plan status)
  (planner-tasks-of-plan-from-page
   (planner-today-ensure-exists) plan '("_" "o")))

;;test
(testing
 (planner-tasks-of-plan-today "LinuxMIS" (task-stati-of-sys 'planner '(open inprogress)))
 (planner-tasks-of-plan-today (planner-today-ensure-exists) (task-stati-of-sys 'planner '(open inprogress)))
 (planner-tasks-of-plan-today "TasksByProject" (task-stati-of-sys 'planner '(open inprogress)))
 (planner-tasks-of-plan-today (planner-today-ensure-exists) '("_" "o"))
 )

(defun normalize-task (task)
  (replace-regexp-in-string
   "\\([]\\[]\\)" "\\\\\\1" task))



;; {{
(defun planner-find-task-in-page-main (task page &optional buf-op)
  "return t if able to find task in page and leave in that page."
  (let ((task (normalize-task task))
        (buf (find-file
              (concat planner-directory "/" page ".muse"))))
    (when buf
      (goto-char 0)
      (if (re-search-forward "^*\s\+Tasks")
          (let ((start (point))
                (end (if (re-search-forward "^*\s\+\\w\+")
                         (point))))
            (when (and end (not (equal end start)))
              (goto-char start)
              (re-search-forward task)
              ;; (read-from-minibuffer "sfddsf: " (format "%d %d eq %s" end start (not (equal end start))))
              (if (functionp buf-op) (funcall buf-op buf))
              t))))))

(defun planner-find-task-in-page (task page &optional restore buf-op)
  "return t if able to find task in page and leave in that page."
  (if restore
      (save-window-excursion
        (save-excursion
          (save-restriction
            (planner-find-task-in-page-main task page buf-op))))
      (planner-find-task-in-page-main task page buf-op)))

(defun planner-task-change-status (task statusfn &optional page)
  (planner-find-task-in-page task (or page (planner-today-ensure-exists))
                             t
                             #'(lambda (b)
                                 ;; (timeclock-in)
                                 (if (functionp statusfn) (funcall statusfn))
                                 (save-buffer)
                                 (bury-buffer b)
                                 ;; (kill-buffer b)
                                 )))
;; }}



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; bugz ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;








(provide 'planner-interface)
;;; planner-interface.el ends here
