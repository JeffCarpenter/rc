;;; packages.el --- basic-startup layer packages file for Spacemacs.
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
;; added to `basic-startup-packages'. Then, for each package PACKAGE:
;;
;; - If PACKAGE is not referenced by any other Spacemacs layer, define a
;;   function `basic-startup/init-PACKAGE' to load and initialize the package.

;; - Otherwise, PACKAGE is already referenced by another Spacemacs layer, so
;;   define the functions `basic-startup/pre-init-PACKAGE' and/or
;;   `basic-startup/post-init-PACKAGE' to customize the package as it is loaded.

;;; Code:


;;; Documentation
;; https://github.com/syl20bnr/spacemacs/blob/master/doc/LAYERS.org
;; https://github.com/syl20bnr/spacemacs/blob/master/doc/DOCUMENTATION.org

(defconst basic-startup-packages
  '(
    (basic-utils :location local)
    (init-setup :location local)
    (utils-custom :location local)
    startup-hooks
    sessions-unified
    elscreen
    lotus-wrapper
    )
  "The list of Lisp packages required by the basic-startup layer.

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

(defun basic-startup/init-basic-utils ()
  (use-package basic-utils
      ;; :ensure t
      ;; :defer t
      :demand t
      :commands (add-to-hook)
      :config
    (progn
      )))

(defun basic-startup/init-init-setup ()
  (use-package init-setup
      ;; :ensure t
      :config
      (progn
        )))

(defun basic-startup/init-utils-custom ()
  (use-package utils-custom
      ;; :ensure t
      :config
      (progn
        )))

(defun basic-startup/init-startup-hooks ()
  (use-package startup-hooks
      ;; :ensure t
      ;; :demand t
      :defer t
      :commands (startup-hooks-insuniate)
      :config
      (progn
        ))
  (add-hook 'after-init-hook #'startup-hooks-insinuate))

(defun basic-startup/init-sessions-unified ()
  (use-package startup-hooks)
  (use-package sessions-unified
      ;; :ensure t
      :demand t
      :commands 'lotus-desktop-session-restore
      :config
      (progn

        (progn
          (setq
           *session-unified-desktop-enabled* t
           *frame-session-restore-screen-display-function* #'spacemacs-buffer/goto-buffer))

        (progn
          (add-to-disable-desktop-restore-interrupting-feature-hook
           '(lambda ()
             (setq
              tags-add-tables nil)
             (setq vc-handled-backends (remove 'P4 vc-handled-backends))
             (when (fboundp 'spacemacs/check-large-file)
               (remove-hook
                'find-file-hook
                'spacemacs/check-large-file))))
          (add-to-enable-desktop-restore-interrupting-feature-hook
           '(lambda ()
             (setq
              tags-add-tables (default-value 'tags-add-tables))
             (add-to-list 'vc-handled-backends 'P4)
             (when (fboundp 'spacemacs/check-large-file)
               (add-hook
                'find-file-hook
                'spacemacs/check-large-file)))))

        (progn
          (with-eval-after-load "utils-custom"
            (setq sessions-unified-utils-notify 'message-notify)))
        (progn
          (with-eval-after-load "startup-hooks"
            (add-to-enable-startup-interrupting-feature-hook
             'frame-session-restore-hook-func
             t)
            (add-to-enable-startup-interrupting-feature-hook
             '(lambda ()
               (run-at-time-or-now 7 'lotus-desktop-session-restore))))))

  (use-package init-setup
      ;; :ensure t
      :config
    (progn
      (progn
        (use-package startup-hooks
            :defer t
            :config
            (progn
              (progn
                (add-to-enable-login-session-interrupting-feature-hook
                 #'set-dbus-session)
                (add-to-enable-startup-interrupting-feature-hook
                 #'set-dbus-session)
                (with-eval-after-load "utils-custom"
                  (add-hook 'emacs-startup-hook
                            '(lambda ()
                              (message-notify "Emacs" "Loaded Completely :)")
                              (message "\n\n\n\n"))))))))))))

(defun basic-startup/init-elscreen ()
  (use-package elscreen
      :defer t
      :config
      (progn
        (defun elscreen-move-right ()
          (interactive)
          (elscreen-next)
          (elscreen-swap)
          (elscreen-notify-screen-modification))

        (defun elscreen-move-left ()
          (interactive)
          (elscreen-previous)
          (elscreen-swap)
          ;; (elscreen-next)
          (elscreen-notify-screen-modification)))))

(defun lotus-orgclocktask/init-lotus-wrapper ()
  (progn
    (progn
      (use-package lotus-wrapper
          :defer t
          :config
          (progn
            (progn
              ))))

    (progn ;; Need it.
      (lotus-wrapper-insinuate))))

;;; packages.el ends here
