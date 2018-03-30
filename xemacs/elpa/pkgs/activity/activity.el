;;; activity.el --- Emacs Activity logger, analyzer and reporter  -*- lexical-binding: t; -*-

;; Copyright (C) 2016  sharad

;; Author: sharad <sh4r4d@gmail.com>
;; Keywords: data

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

;; This package meant to log, analyze and report all emacs activity of
;; user which could further utilized to visualize activity of user
;; during period of time or editing session.

;; Enable WakaTime for the current buffer by invoking
;; `wakatime-mode'. If you wish to activate it globally, use
;; `global-wakatime-mode'.

;; Set variable `wakatime-api-key' to your API key. Point
;; `wakatime-cli-path' to the absolute path of the CLI script
;; (wakatime-cli.py).

;;; Code:

(defconst wakatime-version "1.0.2")
(defconst wakatime-user-agent "emacs-wakatime")
(defvar wakatime-noprompt nil)
(defvar wakatime-init-started nil)
(defvar wakatime-init-finished nil)
(defvar wakatime-python-path nil)

(defgroup wakatime nil
  "Customizations for WakaTime"
  :group 'convenience
  :prefix "wakatime-")

(defcustom wakatime-api-key nil
  "API key for WakaTime."
  :type 'string
  :group 'wakatime)

(defcustom wakatime-cli-path nil
  "Path of CLI client for WakaTime."
  :type 'string
  :group 'wakatime)

(defcustom wakatime-python-bin "python"
  "Path of Python binary."
  :type 'string
  :group 'wakatime)


(defun wakatime-client-command (savep &optional dont-use-key)
  "Return client command executable and arguments.
   Set SAVEP to non-nil for write action.
   Set DONT-USE-KEY to t if you want to omit --key from the command
   line."
  (let ((key (if dont-use-key
                 ""
                 (format "--key %s" wakatime-api-key))))
    (format "%s %s --file \"%s\" %s --plugin %s/%s %s --time %.2f"
            wakatime-python-bin
            wakatime-cli-path
            (buffer-file-name (current-buffer))
            (if savep "--write" "")
            wakatime-user-agent
            wakatime-version
            key
            (float-time))))

(defun wakatime-call (savep &optional retrying)
  "Call WakaTime command."
  (let* ((command (wakatime-client-command savep t))
         (process-environment (if wakatime-python-path
                                  (cons (format "PYTHONPATH=%s" wakatime-python-path) process-environment)
                                  process-environment))
         (process
          (start-process
           "Shell"
           (generate-new-buffer " *WakaTime messages*")
           shell-file-name
           shell-command-switch
           command)))

    (set-process-sentinel process
      `(lambda (process signal)
         (when (memq (process-status process) '(exit signal))
           (kill-buffer (process-buffer process))
           (let ((exit-status (process-exit-status process)))
             (when (and (not (= 0 exit-status)) (not (= 102 exit-status)))
               (error "WakaTime Error (%s)" exit-status))
             (when (or (= 103 exit-status) (= 104 exit-status))
               ; If we are retrying already, error out
               (if ,retrying
                   (error "WakaTime Error (%s)" exit-status)
                 ; otherwise, ask for an API key and call ourselves
                 ; recursively
                 (wakatime-prompt-api-key)
                 (wakatime-call ,savep t)))))))
    (set-process-query-on-exit-flag process nil)))

(defun wakatime-ping ()
  "Send ping notice to WakaTime."
  (when (buffer-file-name (current-buffer))
    (wakatime-call nil)))

(defun wakatime-save ()
  "Send save notice to WakaTime."
  (when (buffer-file-name (current-buffer))
    (wakatime-call t)))

(defun wakatime-bind-hooks ()
  "Watch for activity in buffers."
  (add-hook 'after-save-hook 'wakatime-save nil t)
  (add-hook 'auto-save-hook 'wakatime-save nil t)
  (add-hook 'first-change-hook 'wakatime-ping nil t))

(defun wakatime-unbind-hooks ()
  "Stop watching for activity in buffers."
  (remove-hook 'after-save-hook 'wakatime-save t)
  (remove-hook 'auto-save-hook 'wakatime-save t)
  (remove-hook 'first-change-hook 'wakatime-ping t))

(defun wakatime-turn-on (defer)
  "Turn on WakaTime."
  (if defer
    (run-at-time "1 sec" nil 'wakatime-turn-on nil)
    (let ()
      (wakatime-init)
      (if wakatime-init-finished
        (wakatime-bind-hooks)
        (run-at-time "1 sec" nil 'wakatime-turn-on nil)))))

(defun wakatime-turn-off ()
  "Turn off WakaTime."
  (wakatime-unbind-hooks))

(defun wakatime-validate-api-key (key)
  "Check if the provided key is a valid API key."
  (not
   (not
    (string-match "^[[:xdigit:]]\\{32\\}$"
                  (replace-regexp-in-string "-" "" key)))))

;;;###autoload
(define-minor-mode wakatime-mode
  "Toggle WakaTime (WakaTime mode)."
  :lighter    " waka"
  :init-value nil
  :global     nil
  :group      'wakatime
  (cond
    (noninteractive (setq wakatime-mode nil))
    (wakatime-mode (wakatime-turn-on t))
    (t (wakatime-turn-off))))

;;;###autoload
(define-globalized-minor-mode global-wakatime-mode wakatime-mode
  (lambda () (wakatime-mode 1)))



(define-minor-mode activity-mode
      "Prepare for working with collarative office project. This
is the mode to be enabled when I am working in some files on
which other peoples are also working."
    :initial-value nil
    :lighter " Act"
    :global t
    (condition-case e
        (when office-mode
          (message "calling office mode")
          (if (or (eq major-mode 'c-mode)
                  (eq major-mode 'c++-mode))
              (c-set-style "stroustrup" 1))
          (set (make-local-variable 'before-save-hook) before-save-hook)
          (remove-hook 'before-save-hook 'delete-trailing-whitespace t)
          (message "called office mode"))
      (error (message "Error: %s" e))))


(provide 'activity)
;;; activity.el ends here
