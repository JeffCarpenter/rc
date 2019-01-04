;;; config.el --- config                             -*- lexical-binding: t; -*-

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


(when (configuration-layer/package-usedp 'org-clock-in-if-not)
  (defun spacemacs/org-clock-in-if-not-enable ()
    (progn
      (defun call-org-clock-in-if-not-at-time-delay-frame-fn (frame)
        (if (functionp 'org-clock-in-if-not-at-time-delay-fn)
            (org-clock-in-if-not-at-time-delay-fn)
          (warn "function org-clock-in-if-not-at-time-delay-frame-fn not defined.")))))

       ;; "Keybinding: Elscreen"


  (defun spacemacs/org-clock-in-if-not-disable ()
    (progn)) ;; "Keybinding: Elscreen"


  (spacemacs/org-clock-in-if-not-enable))

;; (provide 'config)
;;; config.el ends here
