;;; dev-config.el --- dev config

;; Copyright (C) 2012  Sharad Pratap

;; Author: Sharad Pratap <sharad>
;; Keywords: internal, internal

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




(deh-require-maybe which-func
  (which-function-mode 1)
  (defface which-func
      '((((class color) (min-colors 88) (background dark)) (:foreground "Green")))
    "which-face"))

(deh-require-maybe 'member-functions
  ;; for C++ mode
  )

(deh-require-maybe devel-notes
  ;; http://www.emacswiki.org/emacs/DevelNotes
  (global-set-key "\C-cza" 'develnotes-add-annotation)
  (global-set-key "\C-czv" 'develnotes-visit-file)
  (global-set-key "\C-czt" 'develnotes-add-TODO)
  (global-set-key "\C-czf" 'develnotes-add-FIXME))

(deh-require-maybe sidebrain
;; (when nil
  ;;http://www.emacswiki.org/emacs/SideBrain
  ;;http://sidebrain.sourceforge.net/manual/index.html
  ;; (add-hook 'find-file-hook
  ;;           #'sidebrain-read-todo-from-comments)

  ;; (add-hook 'sharad/enable-login-session-inperrupting-feature-hook
  ;;           #'(lambda ()
  ;;               (add-hook 'find-file-hook
  ;;                         #'sidebrain-read-todo-from-comments)) t)

  ;; (add-hook 'sharad/disable-login-session-inperrupting-feature-hook
  ;;           #'(lambda ()
  ;;               (remove-hook 'find-file-hook
  ;;                            #'sidebrain-read-todo-from-comments)) t)


  ;; (xml-parse-file sidebrain-file-name)
  ;; (defun filter-ws (tree)
  ;;   (if (listp tree)
  ;;       (mapcar 'tree tree)
  ;;       tree))

  ;; xmllint --noblanks ~/.sidebrain.xml | tr -d '\n' |  sed 's/>[[:space:]]\+</></g'
  ;; (xml-parse-file "~/x.xml" )
  ;; (defun filter-ws (tree)
  ;;   (if (listp tree)
  ;;       (mapcar 'tree tree)
  ;;       tree))
  )


(deh-require-maybe subword
  ;; (global-subword-mode 1)
  (add-element-to-lists '(lambda nil (subword-mode 1)) pgm-langs))




(eval-after-load "simple-call-tree+"
    '((defun left-word (arg)
        (interactive)
        (backward-word arg))

      (defun right-word (arg)
        (interactive)
        (forward-word arg))))

  (eval-after-load 'outline
    '(progn
      (require 'outline-magic)
      (define-key outline-minor-mode-map (kbd "<C-tab>") 'outline-cycle)))


(deh-require-maybe (and simple-call-tree+ fm outline outline-magic)
  )

(provide 'dev-config)
;;; dev-config.el ends here
