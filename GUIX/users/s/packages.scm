;; https://wingolog.org/archives/2015/08/04/developing-v8-with-guix
(use-package-modules  base gcc llvm base python version-control less ccache pkg-config glib gnome cmake messaging autotools flex bison m4 gawk xorg onc-rpc commencement)


(use-modules (gnu packages linux))

(use-modules (guix utils))
(use-modules (guix packages))
(use-modules (gnu services networking))
(use-modules (gnu) (gnu system nss))
(use-service-modules networking ssh)
(use-package-modules bootloaders certs suckless wm)

(use-service-modules desktop networking ssh xorg)
(use-package-modules certs gnome)

(use-modules (gnu packages shells))

(use-modules (gnu))
(use-package-modules screen)


;; other guix

(use-modules (gnu system locale))






(define %lotus-other-packages
  (list "vim"
        "emacs-geiser"
        "emacs-sesman"
        "guile-studio"
        "emacs-guix"
        "emacs-math-symbol-lists"
        "emacs-pretty-mode"
        "emacs-el-mock"
        "emacs-flyspell-correct"
        "jupyter"
        "python-git-review"

        "rcs"
        "darcs"

        "font-adobe-source-code-pro"
        "font-terminus"
        "font-dejavu"
        "font-hack"
        "font-awesome"
        "font-arabic-misc"
        "font-lohit"

        ;; "fribidi"
        ;; "bicon"

        "global"

        "p4"

        "firefox"
        "conkeror-firefox"

        "pavucontrol"
        "pulsemixer"

        "patchelf"
        "gdb"
        "tree"

        "time"

        "xclip"
        "xmodmap"
        ;; at
        "curl"
        "perl"
        "python"
        "ruby"
        "autocutsel"
        "xcompmgr"
        "wget"
        "xmlstarlet"
        "xwininfo"
        "xmlstarlet"
        "imagemagick"
        "setxkbmap"
        "xkeyboard-config"

        "fasd"

        "wmctrl"
        ;; https://sourceforge.net/p/motif/code/ci/master/tree/INSTALL.configure
        ;; https://sourceforge.net/p/cdesktopenv/wiki/LinuxBuild/
        ;; "cdesktopenv"

        ;; "bsdmainutils"
        "rdup"
        "git-annex"
        "git-remote-gcrypt"

        "ledger"
        "emacs-ledger-mode"
        "sbcl-cl-ledger"

        "lsh"

        "enscript"

        "agda"
        "emacs-agda2-mode"

        "gnupg"
        "gpgme"
        "qgpgme"
        "pinentry"
        "pinentry-tty"
        "pinentry-gtk2"
        "emacs-pinentry"
        "signing-party"
        "pius"
        "gpa"
        "jetring"))

(define %lotus-system-selected-package-names
  (list
   "m4"
   "binutils"
   ;; "coreutils"
   ;; "diffutils"
   ;; "findutils"
   ;; "gnu-make"
   ;; "patch"
   "libxdg-basedir"
   "xdg-user-dirs"
   "xdg-utils"
   "shroud"
   "git"
   "git-remote-gcrypt"
   "guile-colorized"
   "file"
   ;; "macchanger"
   ;; "font-lohit"
   "screen"
   "tmux"
   "kitty"
   "lxqt-openssh-askpass"
   "gettext"
   ;; "ecryptfs-utils"
   "zsh"
   "zsh-autosuggestions"
   "hstr"
   "shflags"
   "the-silver-searcher"
   "emacs-ag"
   "emacs-helm-ag"
   "emacs"
   ;; "gparted"
   ;; "parted"
   "ncurses-with-gpm"
   "ncurses"

   "dconf"
   ;; "gsettings-desktop-schemas"

   ;; "dconf"
   ;; "polkit"
   ;; "polkit-gnome"

   "redshift"
   "xcursor-themes"
   "unclutter"


   ;; "sbcl"
   ;; "cl-fad"
   ;; "cl-slime-swank"

   ;; "glibc-utf8-locales"

   "stapler"
   ;; "gcc-toolchain"
   "strace"
   "guile-readline"))

(define %lotus-mail-packages
  (list "mailutils"
        "offlineimap"
        "notmuch"
        "mu"))

(define %lotus-font-packages
  (list))
   
        ;; "font-indic"

(define %lotus-media-packages
  (list "libva"
        "libva-utils"
        "gstreamer"
        "gst-libav"
        "gst123"
        "libvdpau"
        "mpg123"
        "mpg321"))

(define %lotus-gui-packages
  (list ;; "xinit"
        "i3status"
        "dmenu"
        "st"
        "xrdb"
        "xterm"
        "xdotool"
        "xrandr"
        "arandr"
        "autorandr"
        "xrandr-invert-colors"
        "rxvt-unicode"
        "sakura"
        "gnome-keyring"
        "gcr"
        "seahorse"
        "libsecret"
        "libxft"
        "scsh"
        ;; "stumpwm"
        ;; "guile-wm"
        ;; "stumpwm-with-slynk"
        ;; "cl-stumpwm"
        ;; "openbox"
        ;; "awesome"
        ;; "i3-wm"
        ;; "windowmaker"
        ;; "twm"
        ;; "herbstluftwm"
        "wmnd"
        "menumaker"
        "emacs-stumpwm-mode"
        "keynav"
        "conky"
        ;; "surf"
        "xprop"
        "xwininfo"
        "xautolock"
        ;; "slock" -- need suid
        "xset"
        "xsetroot"
        "pidgin"
        "pidgin-otr"
        "telegram-purple"))

(define %lotus-text-packages
  (list "aspell"
        "aspell-dict-en"
        "aspell-dict-hi"
        "fortune-mod"
        "xmlstarlet"
        "libxslt"
        "tidy"))

(define %lotus-notification-packages
  (list "guile-xosd" 
        ;; "osdsh"
        "xosd"
        "libnotify"
        "dunst"))

(define %lotus-package-names-for-installation 
  (append %lotus-system-selected-package-names
          %lotus-other-packages
          %lotus-mail-packages
          ;; %lotus-font-packages
          %lotus-media-packages
          %lotus-gui-packages
          %lotus-text-packages
          %lotus-notification-packages))

;; (define %lotus-system-desktop-packages
;;   (list lvm2
;;         ;; for HTTPS access
;;         nss-certs
;;         ;; for user mounts
;;         gvfs))

(define %lotus-system-selected-packages
  (map specification->package
       %lotus-package-names-for-installation))

(define %lotus-system-packages (append ;; %lotus-system-desktop-packages
                                       %lotus-system-selected-packages))

(define %lotus-packages (append %lotus-system-packages
                                %base-packages))

(packages->manifest %lotus-packages)
