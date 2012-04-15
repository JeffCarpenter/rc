;;; erefactor-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads (erefactor-lint-by-emacsen erefactor-lint erefactor-lazy-highlight-turn-on
;;;;;;  erefactor-highlight-current-symbol erefactor-eval-current-defun
;;;;;;  erefactor-change-prefix-in-buffer erefactor-rename-symbol-in-buffer
;;;;;;  erefactor-rename-symbol-in-package) "erefactor" "erefactor.el"
;;;;;;  (20362 26163))
;;; Generated autoloads from erefactor.el

(autoload 'erefactor-rename-symbol-in-package "erefactor" "\
Rename symbol at point with queries. This affect to current buffer and requiring modules.

Please remember, this function only works well if
the module have observance of `require'/`provide' system.

\(fn OLD-NAME NEW-NAME)" t nil)

(autoload 'erefactor-rename-symbol-in-buffer "erefactor" "\
Rename symbol at point resolving reference local variable as long as i can with queries.
This affect to current buffer.

\(fn OLD-NAME NEW-NAME)" t nil)

(autoload 'erefactor-change-prefix-in-buffer "erefactor" "\
Rename symbol prefix with queries.

OLD-PREFIX: `foo-' -> NEW-PREFIX: `baz-'
`foo-function1' -> `baz-function1'
`foo-variable1' -> `baz-variable1'

\(fn OLD-PREFIX NEW-PREFIX)" t nil)

(autoload 'erefactor-eval-current-defun "erefactor" "\
Evaluate current defun and add definition to `load-history'

\(fn &optional EDEBUG-IT)" t nil)

(autoload 'erefactor-highlight-current-symbol "erefactor" "\
Highlight current symbol in this buffer.
Force to dehighlight \\[erefactor-dehighlight-all-symbol]

\(fn)" t nil)

(autoload 'erefactor-lazy-highlight-turn-on "erefactor" "\
Not documented

\(fn)" nil nil)

(autoload 'erefactor-lint "erefactor" "\
Execuet Elint in new Emacs process.

\(fn)" t nil)

(autoload 'erefactor-lint-by-emacsen "erefactor" "\
Execuet Elint in new Emacs processes.
See variable `erefactor-lint-emacsen'.

\(fn)" t nil)

(defvar erefactor-map (let ((map (make-sparse-keymap))) (define-key map "L" 'erefactor-lint-by-emacsen) (define-key map "R" 'erefactor-rename-symbol-in-package) (define-key map "A" 'erefactor-add-current-defun) (define-key map "c" 'erefactor-change-prefix-in-buffer) (define-key map "d" 'erefactor-dehighlight-all-symbol) (define-key map "h" 'erefactor-highlight-current-symbol) (define-key map "l" 'erefactor-lint) (define-key map "r" 'erefactor-rename-symbol-in-buffer) (define-key map "x" 'erefactor-eval-current-defun) (define-key map "?" 'erefactor-flymake-display-errors) map))
(add-hook 'emacs-lisp-mode-hook 'erefactor-lazy-highlight-turn-on)
(add-hook 'lisp-interaction-mode-hook 'erefactor-lazy-highlight-turn-on)

;;;***

;;;### (autoloads nil nil ("erefactor-pkg.el") (20362 26163 184074))

;;;***

(provide 'erefactor-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; erefactor-autoloads.el ends here
