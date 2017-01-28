;;; packages.el --- lotus-editing layer packages file for Spacemacs.
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; Author: sharad <s@think530-spratap>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;;; Commentary:

;; See the Spacemacs documentation and FAQs for instructions on how to implement
;; a new layer:
;;
;;   SPC h SPC layers RET
;;
;;
;; Briefly, each package to be installed or configured by this layer should be
;; added to `lotus-editing-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `lotus-editing/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `lotus-editing/pre-init-PACKAGE' and/or
;;   `lotus-editing/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:


;;; Documentation
;; https://github.com/syl20bnr/spacemacs/blob/master/doc/lotus-editingS.org
;; https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org


;; http://www.emacswiki.org/emacs/CopyAndPaste#toc5
;; (global-set-key [mouse-2] 'mouse-yank-primary)

(defconst lotus-editing-packages
  '(
    (common-win :location local)
    (light-symbol :location local)
    hilit-chg
    (show-wspace :location local)
    )
  "The list of Lisp packages required by the lotus-editing layer.

Each entry is either:

1. A symbol, which is interpreted as a package to be installed, or

2. A list of the form (PACKAGE KEYS...), where PACKAGE is the
    name of the package to be installed or loaded, and KEYS are
    any number of keyword-value-pairs.

    The following keys are accepted:

    - :excluded (t or nil): Prevent the package from being loaded
      if value is non-nil

    - :location: Specify a custom installation location.
      The following values are legal:

      - The symbol `elpa' (default) means PACKAGE will be
        installed using the Emacs package manager.

      - The symbol `local' directs Spacemacs to load the file at
        `./local/PACKAGE/PACKAGE.el'

      - A list beginning with the symbol `recipe' is a melpa
        recipe.  See: https://github.com/milkypostman/melpa#recipe-format")

(defun lotus-editing/init-common-win ()
  (use-package common-win
      :defer t
      :config
      (progn
        (setq
         x-select-enable-clipboard t
         x-select-enable-primary t
         ;; http://www.emacswiki.org/emacs/CopyAndPaste#toc5
         select-active-regions 'only))))

(defun lotus-editing/init-light-symbol ()
  (use-package light-symbol
      :defer t
      :config
      (progn
        ;; http://stackoverflow.com/a/385676/341107
        ;; (add-element-to-lists 'light-symbol-mode pgm-langs)
        ;; (light-symbol-mode 1) - not works
        )))

(defun lotus-editing/init-hilit-chg ()
  (use-package hilit-chg
      :defer t
      :config
      (progn
        ;; (add-element-to-lists '(lambda ()
        ;;                         (light-symbol-mode 1)
        ;;                         (highlight-changes-visible-mode t)
        ;;                         (highlight-changes-mode t)) pgm-langs)
        ;; (highlight-changes-mode t) - not works
        ;; (highlight-changes-visible-mode t)

        ;;{{
        ;; http://www.emacswiki.org/emacs/TrackChanges
        (make-empty-face 'highlight-changes-saved-face)
        (setq highlight-changes-face-list '(highlight-changes-saved-face))

        ; Example: activate highlight changes with rotating faces for C programming
        (add-hook 'c-mode-hook
                  (function (lambda ()
                    (add-hook 'local-write-file-hooks 'highlight-changes-rotate-faces)
                    (highlight-changes-mode t)
                    ;; (... other stuff for setting up C mode ...)
                    )))
        ;;}}

        ;;{{
        (defun DE-highlight-changes-rotate-faces ()
          (let ((toggle (eq highlight-changes-mode 'passive)))
            (when toggle (highlight-changes-mode t))
            (highlight-changes-rotate-faces)
            (when toggle (highlight-changes-mode nil))))

        ; Example for c-mode-hook:
        (add-hook 'c-mode-hook
                  (function (lambda ()
                    (add-hook 'local-write-file-hooks 'DE-highlight-changes-rotate-faces)
                    (highlight-changes-mode t)
                    (highlight-changes-mode nil)
                    ;; (... other stuff for setting up C mode ...)
                    )))
        ;;}}

        ;;{{
        ;; Following function can make the highlight vanish after save file --coldnew
        (defun highlight-changes-remove-after-save ()
          "Remove previous changes after save."
          (make-local-variable 'after-save-hook)
          (add-hook 'after-save-hook
                    (lambda ()
                      (highlight-changes-remove-highlight (point-min) (point-max)))))
        ;;}}
        )))

(defun lotus-editing/init-show-wspace ()
  ;; http://emacswiki.org/emacs/ShowWhiteSpace
  (use-package show-wspace
      :defer t
      :config
      (progn
        )))

(defun lotus-editing/init-paren ()
  (use-package paren
      :defer t
      :config
      (progn
        ;; Hilight matching parenthesis
        ;; (unless (featurep 'xemacs) (show-paren-mode 1))
        (show-paren-mode 1)

        ;; http://www.emacswiki.org/emacs/ShowParenMode#toc1
        (defadvice show-paren-function (after show-matching-paren-offscreen activate)
          "If the matching paren is offscreen, show the matching line in the
        echo area. Has no effect if the character before point is not of
        the syntax class ')'."
          (interactive)
          (let* ((cb (char-before (point)))
                 (matching-text (and cb
                                     (char-equal (char-syntax cb) ?\) )
                                     (blink-matching-open))))
            (when matching-text (message matching-text)))))))

(defun lotus-editing/init-corral ()
  ;; (https://github.com/nivekuil/corral)
  (use-package corral
      :defer t
      :config
      (progn
        )))

(defun lotus-editing/init-PACKAGE ()
  (use-package PACKAGE
      :defer t
      :config
      (progn
        )))

(defun lotus-editing/init-PACKAGE ()
  (use-package PACKAGE
      :defer t
      :config
      (progn
        )))

;;; packages.el ends here
