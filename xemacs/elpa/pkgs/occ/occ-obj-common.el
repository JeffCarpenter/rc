;;; occ-obj-common.el --- occ-api               -*- lexical-binding: t; -*-
;; Copyright (C) 2016  sharad

;; Author: sharad <sh4r4d _at_ _G-mail_>
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

(provide 'occ-obj-common)


(require 'cl-macs)
(require 'cl-generic)



;; TODO org-base-buffer

;; https://stackoverflow.com/questions/12262220/add-created-date-property-to-todos-in-org-mode

;; "org tsks accss common api"
;; (defvar org-)
(defvar occ-verbose 0)

(defvar occ-org-clock-persist nil "Control org-clock-persist at time of occ clock-in")
(defvar occ-org-clock-auto-clock-resolution nil "Control occ-org-clock-auto-clock-resolution at time of occ clock-in")

(defun occ-debug (level &rest args)
  (when (car args)
    (apply #'format args)
    (when (member level '(:emergency :error :warning :debug))
      ;; (apply #'lwarn 'occ level args)
      (apply #'lwarn 'occ level args)))
  (unless (eq level :nodisplay)
   (apply #'message args)))

(when nil ;; https://curiousprogrammer.wordpress.com/2010/07/19/emacs-defstruct-vs-other-languages/

  (defun cl-get-field (object field)
    (cl-struct-slot-value (cl-classname object) field object))

  (defun cl-set-field (object field value)
    (setf (cl-struct-slot-value (cl-classname object) field object) value))

  (get-field dave 'name)
  (set-field dave 'name "Simon Smith"))

(defun sym2key (sym)
  (if (keywordp sym)
      sym
    (intern-soft (concat ":" (symbol-name sym)))))
(defun key2sym (sym)
  (if (keywordp sym)
      (intern-soft (substring (symbol-name sym) 1))
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
(defun cl-get-fields (object fields)
  (mapcar
   #'(lambda (field)
       (cons field (cl-get-field object field)))
   fileds))
(defun cl-class-slots (class)
  (mapcar
   #'(lambda (slot) (aref slot 1))
   (cl--struct-class-slots
    (cl--struct-get-class class))))
;; (defun cl-class-slot-value (obj slot)
;;   (when (member slot (cl-class-slots (cl-classname obj)))
;;     (cl-struct-slot-value (cl-classname obj) slot obj)))
(defun cl-class-obj-slot-value (class slot obj)
  (when (member slot (cl-class-slots class))
    (cl-struct-slot-value class slot obj)))
(defun cl-obj-slot-value (obj slot)
  (cl-class-obj-slot-value (cl-classname obj) slot obj))
(defun cl-obj-plist-value (obj)
  (cl-obj-slot-value obj 'plist))

(defun cl-method-param-signs (method)
  "Get params signatures for all defined methods"
  (let ((method-instances (cl--generic method)))
   (mapcar
    #'(lambda (x) (aref x 1))
    (if method-instances
        (aref method-instances 3)))))

(progn

  (defun cl-method-param-case (signature-val-spec)
   "signature-val-spec = (METHOD (PARAMS VAL))"
   (cl-destructuring-bind (method (param-spec val)) signature-val-spec
     (remove
      nil
      (mapcar
       #'(lambda (fspec)
           (eval
            `(pcase ',fspec
               (,param-spec ,val)
               (_ nil))))
       (cl-method-param-signs method)))))


  ;; (cl-method-param-case '(occ-readprop (`((head ,val) occ-ctx) val)))

  (defun cl-method-param-case-with-value (signature-val-spec obj)
   "signature-val-spec = (METHOD PARAMS VAL)"
   (cl-destructuring-bind (method (param-spec val)) signature-val-spec
     (remove
      nil
      (mapcar
       #'(lambda (fspec)
           (let ((first-arg
                  (eval
                   `(pcase ',fspec
                      (,param-spec ,val)
                      (_ nil)))))
             (when (and
                    first-arg
                    (funcall method (cons first-arg obj)))
               first-arg)))
       (cl-method-param-signs method))))))



(defun cl-method-first-arg (method)
  (let ((methods (cl--generic method)))
    (mapcar
     #'(lambda (fspec) (cadar fspec))
     (cl-method-param-signs method))))

(defun cl-method-first-arg-with-value (method obj)
  (let ((methods (cl--generic method)))
    (mapcar
     #'(lambda (fspec)
         (let ((first-arg (cadar fspec)))
           (when (funcall method (cons first-arg obj)) first-arg)))
     (cl-method-param-signs method))))


(defun occ-chgable-p ()
  "Stay with a clock at least 2 mins."
  (if org-clock-start-time
      (let ((clock-duration
             (if (and
                  (stringp org-clock-start-time)
                  (string-equal "" org-clock-start-time))
                 0
               (float-time (time-since org-clock-start-time)))))
        (or
         (< clock-duration 60)
         (> clock-duration 120)))
    t))

;;;###autoload
(defun occ-straight-org-clock-clock-in (clock &optional resume start-time)
  (let ((org-log-note-clock-out nil))
    (progn
     (lotus-org-clock-load-only)
     (prog1
         (let ((org-clock-persist               occ-org-clock-persist)
               (org-clock-auto-clock-resolution occ-org-clock-auto-clock-resolution))
           (org-clock-clock-in clock resume start-time))
       (setq org-clock-loaded t)))))


(cl-defmethod occ-get-property ((obj occ-obj)
                                (prop symbol))
  ;; mainly used by occ-tsk only.
  (if (memq prop (cl-class-slots (cl-classname obj)))
      (cl-get-field obj prop)
    (plist-get
     (cl-obj-plist-value obj)
     (sym2key prop))))

(cl-defmethod occ-set-property ((obj occ-obj)
                                prop
                                val)
  ;; mainly used by occ-tsk only
  (if (memq prop (cl-class-slots (cl-classname obj)))
      (setf (cl-struct-slot-value (cl-classname obj) prop obj) val)
    (plist-put
     (cl-struct-slot-value (cl-classname obj) 'plist obj) ;TODO ??? (cl-obj-plist-value obj)
     (sym2key prop) val)))

(cl-defmethod occ-get-properties ((obj occ-obj)
                                  (props list))
  ;; mainly used by occ-tsk only.
  (mapcar
   #'(lambda (prop)
       (cons prop (occ-get-property obj prop)))
   props))

(cl-defmethod occ-class-slots ((obj occ-obj))
  (let* ((plist (cl-obj-plist-value obj))
         (plist-keys (plist-get-keys plist))
         (slots (cl-class-slots (cl-classname obj))))
    (append slots
            (mapcar #'key2sym plist-keys))))
(cl-defmethod occ-obj-defined-slots ((obj occ-obj))
  (let* ((plist (cl-obj-plist-value obj))
         (plist-keys (plist-get-keys plist))
         (slots
          (append
           (cl-class-slots (cl-classname obj))
           (mapcar #'key2sym plist-keys))))
    slots))
(cl-defmethod occ-obj-defined-slots-with-value ((obj occ-obj))
  (let* ((slots (occ-obj-defined-slots obj)))
    (remove-if-not
     #'(lambda (slot)
         (occ-get-property obj slot))
     slots)))
(cl-defmethod cl-method-matched-arg ((method symbol)
                                     (ctx symbol))
  (cl-method-first-arg method))
(cl-defmethod cl-method-matched-arg ((method symbol)
                                     (ctx occ-ctx))
  (let ((slots (occ-obj-defined-slots-with-value ctx)))
    (remove-if-not
     #'(lambda (arg) (memq arg slots))
     (cl-method-first-arg method))))
(cl-defmethod cl-method-matched-arg ((method1 symbol)
                                     (method2 symbol)
                                     (ctx occ-ctx))
  (let ((slots (cl-method-first-arg-with-value method2 ctx)))
    (remove-if-not
     #'(lambda (arg) (memq arg slots))
     (cl-method-first-arg method1))))

(when nil
  (occ-readprop-props)
  (cl-method-matched-arg 'occ-readprop nil)
  (cl-method-matched-arg 'occ-readprop (occ-make-ctx))
  (occ-obj-defined-slots-with-value (occ-make-ctx)))

(cl-defgeneric cl-method-sig-matched-arg (method-sig
                                          ctx)
  "test")
(cl-defmethod cl-method-sig-matched-arg ((method-sig cons)
                                         (ctx symbol))
  (cl-method-param-case method-sig))
(cl-defmethod cl-method-sig-matched-arg ((method-sig cons)
                                         (ctx occ-ctx))
  (let ((slots (occ-obj-defined-slots-with-value ctx)))
    (remove-if-not
     #'(lambda (arg) (memq arg slots))
     (cl-method-param-case method-sig))))
(cl-defmethod cl-method-sigs-matched-arg ((method-sig1 cons)
                                          (method-sig2 cons)
                                          (ctx occ-ctx))
  (let ((slots (cl-method-param-case-with-value method-sig2 ctx)))
    (remove-if-not
     #'(lambda (arg) (memq arg slots))
     (cl-method-param-case method-sig1))))


(when nil
  (cl-method-sig-matched-arg '(occ-readprop (`((head ,val) occ-ctx) val)) nil)

  (cl-method-param-signs 'occ-ctx-property-get)
  (cl-method-sigs-matched-arg
   '(occ-readprop (`((head ,val) occ-ctx) val))
   '(occ-ctx-property-get (`((head ,val)) val))
   (occ-make-ctx)))


(when nil
  (defmacro cl-method-first-arg-x (method param-spec val)
    `(let ((methods (cl--generic ,method)))
       (mapcar
        #'(lambda (fspec)
            (pcase (aref fspec 1)
              (,param-spec ,val)
              (_ nil)))
        (when methods (aref methods 3)))))

  (macroexpand-1
   '(cl-method-first-arg-x 'occ-readprop `((head ,val) occ-ctx) val))


  (let ((methods (cl--generic (quote occ-readprop))))
    (mapcar
     (function (lambda (fspec) (pcase fspec ((\` ((head (\, val)) occ-ctx)) val) (_ nil))))
     (when methods (aref methods 3))))


  (let ((methods (cl--generic (quote occ-readprop))))
    (mapcar
     (function
      (lambda (fspec)
        (pcase (aref fspec 1)
          (`((head ,val) occ-ctx) val)
          (_ nil))))
     (when methods
       (aref methods 3))))



  (cl-method-param-case 'occ-readprop `((head ,val) occ-ctx) val)

  (cl-method-param-case '(occ-readprop `(((head ,val) occ-ctx) val)))


  (cl-destructuring-bind (method param-spec val) '(occ-readprop `((head ,val) occ-ctx) val)
    (message "%s" (list method param-spec val)))

  '( `(x))







  (cl-method-first-arg-x 'occ-readprop `((head ,val) occ-ctx) 'val)



  (setq xxnaaa
        (mapcar
         #'(lambda (x) (aref x 1))
         (aref (cl--generic 'occ-readprop) 3)))

  (setq xxnaaa
        (aref (cl--generic 'occ-readprop) 3))


  (let ((param-spec '`((head ,val)))
        (val        ',val))
    (mapcar
     #'(lambda (fspec)
         (pcase--expand fspec
                        (list
                         (list param-spec val)
                         (list '_ nil))))
     xxnaaa)))



;; (occ-reload)
;;; occ-obj-common.el ends here
