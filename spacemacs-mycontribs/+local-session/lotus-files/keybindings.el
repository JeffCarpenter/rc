
(when (configuration-layer/package-usedp 'ffw)
  (defun spacemacs/ffw-enable ()
    (progn ;; "Keybinding: Ffw"
      (global-set-key-if-unbind (kbd "s-x s-f") 'find-file-wizard)))

  (defun spacemacs/ffw-disable ()
    (progn ;; "Keybinding: Ffw"
      (global-unset-key-if-bound (kbd "s-x s-f") 'find-file-wizard)))

  (spacemacs/ffw-enable))

(when (configuration-layer/package-usedp 'PACKAGE)
  (defun spacemacs/PACKAGE-enable ()
    (progn ;; "Keybinding: Package"
      ;;{{ package
      (define-key evil-emacs-state-map (kbd "") nil)
      ;; (global-unset-key [C-z])
      (global-set-key [] 'package-create)))

  (defun spacemacs/PACKAGE-disable ()
    (progn ;; "Keybinding: Package"
      (define-key evil-emacs-state-map nil)
      (global-unset-key [])))

  (spacemacs/PACKAGE-enable))

(when (configuration-layer/package-usedp 'PACKAGE)
  (defun spacemacs/PACKAGE-enable ()
    (progn ;; "Keybinding: Package"
      ;;{{ package
      (define-key evil-emacs-state-map (kbd "") nil)
      ;; (global-unset-key [C-z])
      (global-set-key [] 'package-create)))

  (defun spacemacs/PACKAGE-disable ()
    (progn ;; "Keybinding: Package"
      (define-key evil-emacs-state-map nil)
      (global-unset-key [])))

  (spacemacs/PACKAGE-enable))
