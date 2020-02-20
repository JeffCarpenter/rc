#!/usr/bin/env bash

# set -e
## create a setup-disk.sh
## for creating lvm disk layout for different sizes of harddisk of 500GB 1T
## which can have option
## - for full clean where no window is present
## - or window or other OSes, other linuxes could come in future
## - where window already present not going to be there only
##  here also further two
##  + only one ubuntu and window will be there
##  + ubuntu and window and other OSes or other linuxes could come in future.
## tools will be
## parted


# BUG: ${HOME}/.setup/.config/dirs.d/home.d/ is wrongly getting created.

DEBUG=1

if [ -d "/run/current-system/profile" ]
then
    INSTALLER="echo"
    INSTALLER_OPT="-y"
else
    INSTALLER="apt"
    INSTALLER_OPT="-y"
fi

SETUP_TMPDIR="${TMPDIR:-/tmp}/setuptmp"

export GIT_DISCOVERY_ACROSS_FILESYSTEM=1
SSH_KEY_DUMP=$1


logicaldirs=(config deletable longterm preserved shortterm maildata)

dataclassname=data
homeclassname=home

if [ -r "${HOME}/.ssh/authorized_keys" ]
then
    # GIT_SSH_OPTION="ssh -o UserKnownHostsFile=${HOME}/.ssh/authorized_keys -o StrictHostKeyChecking=yes"
    GIT_SSH_OPTION="ssh -o UserKnownHostsFile=${HOME}/.ssh/authorized_keys"
else
    GIT_SSH_OPTION="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
fi

RESOURCEPATH=".repos/git/main/resource"
USERORGMAIN="userorg/main"

APT_REPO_COMMPUNICATION="ppa:nilarimogard/webupd8"
APT_REPO_UTILS="ppa:yartsa/lvmeject ppa:mikhailnov/pulseeffects"

APT_REPO_KOI="ppa:team-xbmc/ppa"

DEB_PKG_FIRST_INSTALL="zsh"
DEB_PKGS1="vim emacs25-lucid emacs emacs-goodies-el org-mode develock-el dash-el s-el zile keychain undistract-me rpm sosreport"
DEB_PKGS2="rxvt-unicode-256color elscreen planner-el p7zip-full pdftk golang gocode gparted"
DEB_PKG_FIRST_INTERCATIVE_QA="macchanger postfix cyrus-clients lyskom-server console-data tlp"
DEB_PKG_EMACS="elpa-git-commit elpa-git-annex elpa-magit elpa-magit-popup elpa-magit-annex elpa-magithub magit elpa-with-editor emacs-goodies-el enscript flim lm-sensors preload pandoc automake g++ gcc libpng-dev libpoppler-dev libpoppler-glib-dev libpoppler-private-dev libz-dev make pkg-config elpa-projectile elpa-ghub elpa-ghub+ git-el rtv elpa-ert-async elpa-ert-expectations elpa-package-lint" #
DEB_PKG_MESSAGING="namazu2 mhc x-face-el compface"
DEB_PKG_NECESSARY_MORE1="xaos xnee xnee-doc xzgv yatex zsh zsh-doc zutils zplug zsh-theme-powerlevel9k screen tmate tmux tmuxp byobu landscape-common update-motd ccze shutdown-at-night sitesummary xterm rxvt-unicode-256color cifs-utils"
# TODO BUG set zsh as login shell
DEB_PKG_NECESSARY_MORE2="gnu-smalltalk-doc gnu-fdisk gnu-standards gnuit gnulib gnupg2 gpa paperkey gnuplot-doc gvpe gtypist hello ht id-utils indent integrit jed latex-mk ledger libaws-doc rar"
##  hello-traditional
DEB_PKG_NECESSARY_MORE3="libcommoncpp2-doc libconfig-dev libsocket++-dev licenseutils lookup-el lyskom-server macchanger mboxgrep mit-scheme-doc mmm-mode ocaml-doc oneliner-el org-mode-doc parted-doc pcb-common moreutils nmap zenmap"
DEB_PKG_NECESSARY_MORE4="pinfo psgml qingy r-doc-info r5rs-doc semi sepia sharutils slime source-highlight spell ssed stow rlwrap ledit teseq time trueprint turnin-ng units vera wcalc gnome-calculator wdiff wizzytex wysihtml-el"
DEB_PKG_GAME="gnugo cmatrix cmatrix-xfont wmmatrix"
DEB_PKGS_BACKUP="bup git-annex tahoe-lafs unison unison-all inotify-tools"
DEB_PKG_NECESSARY="cvs subversion git git-cvs cvs2svn git-review legit git-extras git-flow git-sh git-extras git-crypt ecryptfs-utils openssl stow sbcl cl-clx-sbcl at gksu openssh-server sshpass zssh rcs apt-src flatpak apt-file jargon cutils complexity-doc dejagnu diffutils extract festival ffe gccintro gddrescue geda-doc genparse gpodder gnutls-bin pinentry-gnome3 pinentry-tty pinentry-curses mew-beta mew-beta-bin kwalletcli scdaemon kleopatra pinentry-x2go" # mew-bin
DEB_PKG_NECESSARY1="mosh fish ondir zsh-syntax-highlighting doc-base snooze"
DEB_PKG_WITH_ERROR="edb"
DEB_PKG_APPEARANCE="lxappearance gnome-tweak-tool gnome-themes-standard libgtk-3-dev console-data gnome-session gnome-settings-daemon gnome-panel policykit-1-gnome dex"
DEB_PKG_VIRTURALMACHINE="xrdp rdesktop vncviewer remmina remmina-plugin-rdp virtualbox-dkms virtualbox-guest-x11 vagrant libvirt-clients docker-compose virt-manager libvirt-daemon libvirt-daemon-system qemu kvm vagrant vagrant-libvirt vagrant-lxc vagrant-mutate "

DEB_EXTRA_PKG1=" libpam-tmpdir xdg-utils xdg-user-dirs menu-xdg extra-xdg-menus obsession keyringer menu tree wipe xclip python3-secretstorage copyq parcellite clipit diodon dunst zathura apvlv udiskie xsel xfce4-clipman rofi shellex"
DEB_EXTRA_PKG_COMMUNICATION="pidgin finch pidgin-skype pidgin-skypeweb empathy empathy-skype pidgin-gnome-keyring purple-skypeweb telegram-purple pidgin-plugin-pack bitlbee-libpurple bitlbee-plugin-otr tor" #  bitlbee
DEB_EXTRA_PKG_VIRTUAL=""
DEB_EXTRA_PKG_FONTS="ttf-bitstream-vera texlive-latex-extra texlive-fonts-recommended xfonts-75dpi"
DEB_EXTRA_PKG_LISP="cl-swank slime"
DEB_EXTRA_PKG2="homesick yadm numlockx macchanger xautolock suckless-tools xtrlock xbacklight xautomation ffmpeg"
DEB_EXTRA_PKG3="makepasswd libstring-mkpasswd-perl inotify-tools conky-all macchanger lm-sensors tidy xmlstarlet libxml-compile-perl network-manager-openvpn-gnome duc xmldiff"
DEB_EXTRA_SEC_PKG1="systemd-ui realmd sssd sssd-tools samba-common krb5-user packagekit samba-common-bin samba-libs adcli ntp winbind krb5-kdc krb5-config" # policykit-1 policykit-1-gnome , #  chrony (conflict with ntp)
DEB_EXTRA_SEC_PKG2="pass pasaffe pass-extension-tail pass-git-helper passwdqc password-gorilla passwordmaker-cli passwordsafe"
DEB_DEV_PKG1="cutils python-pip python3-pip silversearcher-ag silversearcher-ag-el global cscope codequery seascope xcscope-el s-el ack-grep doxygen doxymacs libjson-glib-dev npm cmake uncrustify pasystray spacefm-gtk3 thunar thunar-volman pcmanfm xfce4-powermanager xfce4-notifyd ycmd fasd agda opam plsense yad"
DEB_DEV_PYTHON="elpa-pyvenv python3-venv"
DEB_EXTRA_PKG3_UTILS="system-config-lvm lvmeject adcli partclone gpodder parallel libpam-fprintd fprint-demo"
# https://www.cyberciti.biz/faq/removing-password-from-pdf-on-linux/
DEB_PKG_DEV="valgrind libxml2-dev gjs seed-webkit2 gv xpdf-utils ghostscript pdftk qpdf editorconfig elpa-editorconfig vim-editorconfig pythin-editorconfig python3-editorconfig elfutils patchelf "
DEB_PKG_SYSTEM="cpuid inxi x11-xserver-utils autorandr arandr bluez bluez-tools redshift daemontools god circus software-properties-common at hibernate ps-watcher daemonfs daemonize daemon slop scrot"
DEB_PKG_TOOL="atool fpgatools patool usbmount"
DEB_PKG_TOOL_MAIL_TEST="cyrus-clients swaks im namazu2-index-tools prayer-accountd prayer"
DEB_SYS_PKG1="duc baobab agedu tpb daemontools sysstat isag dos2unix powermanagement-interface grub2-splashimages grub2-themes-ubuntu-mate offlineimap libsecret-tools"
# https://linuxconfig.org/fetch-stock-quotes-with-perl-finance-quote-module
DEB_SYS_MAIL="dovecot-core dovecot-imapd mail-stack-delivery ntpdate postfix augeas-tools augeas-lenses notmuch muchsync notmuch-addrlookup notmuch-emacs afew ldap-utils bbdb3 elpa-lbdb lsdb mu-cite libfinance-quote-perl mail-notification"
DEB_DEV_GTD="tomboy zim anki mnemosyne mnemosyne-blog sqlitebrowser"
DEB_PKG_LEARNING="gpodder"
DEB_PKG_TOOL_TERM="jq recutils"
DEB_PKG_TOOL_GUI="lightdm osdsh osd-cat xosd-bin notify-osd notify-osd-icons xosd-bin python-osd gpointing-device-settings touchfreeze bash-completion libinput-tools keynav feh geeqie wmaker libmotif-dev libxss-dev mwm xserver-xephyr xrootconsole tilda eterm" # xserver-xorg-input-synaptics
DEB_PKG2_TOOL_GUI="unclutter xscreensaver xscreensaver-gl xss-lock rss-glx xssproxy xscreensaver-data-extra xscreensaver-gl-extra" # event
DEB_PKG3_TOOL_GUI="synenergy quicksynenergy xserver-xorg-input-synaptics" # xserver-xorg-core-hwe-18.04 xserver-xorg-input-synaptics-hwe-18.04 # event
DEB_PKG1_TOOL_GUI_XORG="python-osd python-gtk2 afnix python-gconf nitrogen"
DEB_PKG_XWM="compton xcompmgr autocutsel sakura wmctrl sawfish"
DEB_PKG_XML="libxml2-utils xsltproc docbook5-xml docbook-xsl-ns"
DEB_PKG_UTILS="gcalcli newsbeuter liblz4-tool tracker gtimelog d-feet linuxbrew-wrapper zsync"
DEB_PKG_TOOL_SUCKLESS="stterm"
# DEB_PKG_GUI_DEV_UTILS="libglib2.0-dev-bin" gdbus-codegen
DEB_PKG_MEDIA="libavcodec-extra pulseeffects pavucontrol pulseaudio-module-gconf pulseaudio-equalizer vokoscreen pulseaudio-utils pulsemixer kodi sox mpg123 mpg321 vlc"
DEB_PKG_WINDOW="smbclient python3-smbc python-smbc awesome awesome-extra"
DEB_PKG1_NET="network-manager-fortisslvpn network-manager-fortisslvpn-gnome openfortivpn python-pyftpdlib python3-pyftpdlib whois woof"
DEB_PKG2_NET="tshark wireshark"
DEB_PKG_DOC="wv epub-utils"
DEB_PKG_DOC_PUB="hugo jekyll"
DEB_PKG_JAVA1="libreoffice-java-common"
DEB_PKG_LINT="shellcheck splint splint-data yapf yapf3 foodcritic ansible-lint adlint ansible-lint api-sanity-checker flycheck-doc"
DEB_PKG_CM_TOOL="ansible itamae"
DEB_PKG_DEB="devscripts revu-tools debaux devscripts dput"
DEB_PKG_BUILD="elida pbuilder"
DEB_PKG_VOICE="espeak-ng espeak-ng-espeak xmms2 gxmms2 promoe gmpc mpd mpc"
# https://github.com/ryanoasis/nerd-fonts
# https://www.reddit.com/r/stumpwm/comments/8nywfc/resetting_font_changes/
DEB_PKG_FONTS="fonts-firacode " # Iosevka
DEB_PKG_MGM_PKG_MGM="wajig vrms"
DEB_PKG_PROGRAMMING=" clangd-9 " # Iosevka
DEB_PKG_ASSEMBLY="nasm yasm " # Iosevka
DEB_PKG_LANG_LEARN="geiser guile-2.2 guile-2.0 guile-2.0-dev ocaml-interp gnu-smalltalk squeak-vm elixir"
DEB_PKG_LANG_OCAML="ocaml-interp"
DEB_PKG_LANG_SMALLTALK="gnu-smalltalk gnu-smalltalk-el gnu-smalltalk-browser"
DEB_PKG_LANG_SCHEME="guile-2.2 guile-2.0 scsh"
DEB_PKG_LANG_HASKELL="ghc alex happy haddock hlint"
# https://hostpresto.com/community/tutorials/how-to-install-erlang-on-ubuntu-16-04/
DEB_PKG_LANG_ERLANG="elixir esl-erlang"
# https://askubuntu.com/questions/77657/how-to-enable-arabic-support-in-gnome-terminal
DEB_PKG_LANGUAGE="dict dict-freedict-eng-hin bicon libfribidi0 libfribidi-dev"
DEB_PKG_NATURAL_LANG="libfribidi-bin bidiv"
DEB_PKG_NATURAL_LANG_INDIC="fonts-indic fonts-deva font-lohit-deva language-pack-hi"
DEB_PKG_NATURAL_LANG_URDU="apertium-urd apertium-urd-hin firefox-locale-ur fonts-paktype fonts-nafees language-pack-ur"
DEB_PKG_NATURAL_LANG_PERSIAN="firefox-locale-fa fonts-freefarsi fonts-farsiweb language-pack-fa"
DEB_PKG_NATURAL_LANG_ARABIC="fonts-arabeyes fonts-hosny-amiri fonts-kacst-one fonts-sil-lateef xfonts-intl-arabic language-pack-ar"
DEB_PKG_CLOUD_VM_TOOLS="cloud-init cloud-utils"

PY_PIP_PKG="termdown "
NODE_PKG="tern "




################################
## BREW PACKAGE
##
## python-yq
## blackbox
## git-crypt
## git-secret

################################
## SNAP PACKAGE
##
## yq



function main()
{

    trap setup_finish EXIT SIGINT SIGTERM

    running debug process_arg $@
    # process_arg $@
    running debug mkdir -p $SETUP_TMPDIR
    running info set_keyboard

    if [ ! -d "/run/current-system/profile" ]
    then
       running info setup_sourcecode_pro_font
    fi

    cd "${HOME}/"

    running info setup_apt_packages
    running info setup_ecrypt_private
    running info setup_tmp_ssh_keys "$SETUP_TMPDIR/ssh" "$SSH_KEY_DUMP"

    if ! ssh-add -l
    then
	      error ssh key no available >&2
	      exit -1
    fi

    # will set the ${HOME}/.setup also
    running info setup_git_repos
    running info setup_config_dirs
    running info setup_user_config_setup
    running info setup_ssh_keys "$SSH_KEY_DUMP"
    running info setup_download_misc

    if [ ! -d "/run/current-system/profile" ]
    then
        running info setup_login_shell
        running info setup_advertisement_blocking
    fi

    running info setup_dirs

    if [ ! -d "/run/current-system/profile" ]
    then
        running info setup_apache_usermod
        running info setup_mail
        running info setup_ldapsearch
        running info setup_password
        running info setup_crontab
    fi

    running info setup_spacemacs

    if [ ! -d "/run/current-system/profile" ]
    then
        running info setup_clib_installer
        running info setup_clib_pkgs
        running info setup_bpkg_installler
        running info setup_bpkg_pkgs
    fi

    running info set_window_share
    rm -rf $SETUP_TMPDIR

    echo Finished setup-user
}

function setup_finish()
{
    rm -rf $SETUP_TMPDIR
}

function setup_count_slash_in_path()
{
    local rel_path="$1"

    rel_path="$(print ${rel_path} | tr -s /)"
    rel_path="${rel_path%/}"

    # TODO?
    # remove last / target=${1%/}
    # remove duplicate /
    #


    local rel_path_array=( ${rel_path//\// } )
    local rel_path_len=$(expr ${#rel_path_array[@]} - 1)

    print $rel_path_len
}

function setup_make_parent_path()
{
    count="$1"

    local updirsrel_path_len_space=$(printf "%${count}s")
    local updirsrel_path=${updirsrel_path_len_space// /"../"}
    updirsrel_path=${updirsrel_path%/}

    print $updirsrel_path

    # TODO?
    # at last no / should be present
    # simply join number of .. by /
}

function setup_make_link()
{
    local target=$1
    local link=$2

    local rtarget="$target"
    if [ "$rtarget" != "${rtarget#/}" ]
    then
        verbose target $target is absolute path. >&2
    else
        verbose target $target is relative path. >&2
        rtarget="$(dirname $link)/$rtarget"
    fi

    if [ ! -L $link -o "$(readlink -m $link)" != "$(readlink -m $rtarget )" ]
    then
        if [ -e $link ]
        then
            if [ ! -L $link ]
            then
                warn link $link is not a link >&2
            else
                warn $link is pointing to  $(readlink $link) >&2
                warn while it should point to "$(readlink -m $rtarget )" >&2
            fi
            warn removing $link
            warn taking $link backup in ${link}-BACKUP
            running warn mv $link ${link}-BACKUP
        else
            verbose $link do not exists >&1
        fi


        local linkdir=$(dirname $link)
        if [ "$linkdir" != . ]
        then
            debug pwd $(pwd)
            debug link=$link
            debug dir "$(dirname $link)"
            mkdir -p "$(dirname $link)"
        fi

        running debug rm -f  $link
        running debug ln -sf $target $link
    else
        verbose $link is correctly pointing to "$(readlink -m $rtarget )" is equal to $target
        rm -f  $link
        ln -sf $target $link
    fi
}

function setup_copy_link()
{
    local link=$1
    local target=$2

    if [ -d $target -a ! -L $target ]
    then
        warn target $traget can not be a directory >&2
        exit -1
    fi
    if [ -L "$link" ]
    then
        if [ ! -L $target -o "$(readlink -m $link)" != "$(readlink -m $target)" ]
        then
            if [ -e $target ]
            then
                if [ ! -L $target ]
                then
                    warn link $target is not a link >&2
                else
                    warn $target is pointing to  "$(readlink $target)" >&2
                    warn while it should point to "$(readlink -m $link )" >&2
                fi
                warn removing $target
                warn taking $target backup in ${target}-BACKUP
                running warn mv $target ${target}-BACKUP
            else
                verbose $target do not exists >&1
            fi
            running debug cp -a $link $target
        else
            verbose $target is correctly pointing to "$(readlink -m $target )" is equal what $link is pointing to "$(readlink -m $link )"
        fi
    else
        warn $link is not a link, not doing anything >&2
    fi
}

function setup_make_relative_link()
{
    local path=$1
    local target=$2
    local link=$3

    local linkcount=$(setup_count_slash_in_path "$link")
    local parents_link=$(setup_make_parent_path "$linkcount")

    debug link=$link
    debug linkcountlink=$linkcount
    debug parents_link=$parents_link
    debug target=$target

    # debug running debug setup_make_link ${parents_link}${target:+/}${target} $path/$link
    # running debug setup_make_link ${parents_link}${target:+/}${target} $path/$link

    if [ -d "${path}/${target}" ]
    then
        local separator=
        if [ "x" != "x$target" -a "x" != "x$parents_link" ]
        then
            separator="/"
        fi

        # debug separator=$separator

        debug running debug setup_make_link ${parents_link}${separator:+/}${target} $path/$link
        running debug setup_make_link ${parents_link}${separator:+/}${target} $path/$link
    else
        warn running debug setup_make_link "${path}/${target}" is broken link not creating link ${parents_link}${separator:+/}${target} $path/$link
    fi
}

function setup_recursive_links_container_dirs()
{
    # create all leaf dirs symlinks recursively.
    basepath="$1"
    linktopdir="$2"
    targetdir="$3"

    debug basepath="$basepath"
    debug linktopdir="$linktopdir"
    debug targetdir="$targetdir"

    debug basepath/linktopdir="${basepath}/${linktopdir}"

    if [ -d "$basepath" -a -d "${basepath}/${linktopdir}" ]
    then
        cd "${basepath}/${linktopdir}"
        # debug SHARAD TEST
        # https://stackoverflow.com/questions/4269798/use-gnu-find-to-show-only-the-leaf-directories
        # https://stackoverflow.com/a/4269862
        local linkdirs=( $(find -type d -links 2 \( \! -name '*BACKUP*' \) | cut -c3- ) )
        debug linkdirs
        debug linkdirs=$linkdirs

        cd - > /dev/null 2>&1

        debug linkdirs=${linkdirs[*]}

        # TODO? do something here
        for lnkdir in "${linkdirs[@]}"
        do
            # debug running debug setup_make_relative_link ${basepath} ${linktopdir}/${lnk} ${targetdir}/${lnk}
            running debug setup_make_relative_link ${basepath} ${linktopdir}/${lnkdir} ${targetdir}/${lnkdir}
        done
    else
        error dir ${basepath}/${linktopdir} not exists
    fi

}                               # function setup_recursive_links_container_dirs()

function setup_recursive_links()
{
    # create all symlinks mirrors symlinks recursively
    basepath=$1
    linkdir=$2
    targetdir=$3

    debug basepath=$basepath
    debug linkdir=$linkdir
    debug targetdir=$targetdir

    if [ -d "${basepath}/${linkdir}" ]
    then
        cd ${basepath}/${linkdir}
        # debug SHARAD TEST
        local links=( $(find -type l \( \! -name '*BACKUP*' \) | cut -c3- ) )
        cd - > /dev/null 2>&1

        debug links=${links[*]}

        # TODO? do something here
        for lnk in "${links[@]}"
        do
            # debug running debug setup_make_relative_link ${basepath} ${linkdir}/${lnk} ${targetdir}/${lnk}
            running debug setup_make_relative_link ${basepath} ${linkdir}/${lnk} ${targetdir}/${lnk}
        done
    else
        error dir ${basepath}/${linkdir} not exists
    fi

}                               # function setup_recursive_links()

# worker
function confirm()
{
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY])
            true
            ;;
        *)
            false
            ;;
    esac
}

SETUP_ADD_TO_VERSION_CONTROL_ASK_RESPONSE=unconfirmed
function setup_add_to_version_control_ask()
{
    local response

    if [ "${SETUP_ADD_TO_VERSION_CONTROL_ASK_RESPONSE}" != "all" -a "${SETUP_ADD_TO_VERSION_CONTROL_ASK_RESPONSE}" != "never" ]
    then
        read -r -p "${1:-Are you sure? } [y(es) Y|A(yes all) n(o) N(ever)] " response
        case "$response" in
            y[[eE][sS]?]?|y) SETUP_ADD_TO_VERSION_CONTROL_ASK_RESPONSE=yes;;
            Y[[eE][sS]?]?|[aA][ll]?) SETUP_ADD_TO_VERSION_CONTROL_ASK_RESPONSE=all;;
            n[o]?|n) SETUP_ADD_TO_VERSION_CONTROL_ASK_RESPONSE=no;;
            N[e][v][e][r]|N) SETUP_ADD_TO_VERSION_CONTROL_ASK_RESPONSE=never;;
            *) SETUP_ADD_TO_VERSION_CONTROL_ASK_RESPONSE=unconfirmed;;
        esac
    fi

    if [ "${SETUP_ADD_TO_VERSION_CONTROL_ASK_RESPONSE}" = "yes" -o "${SETUP_ADD_TO_VERSION_CONTROL_ASK_RESPONSE}" = "all" ]
    then
        true
    else
        false
    fi
}

function setup_add_to_version_control()
{
    local base="$1"
    local relfile="$2"

    if ! git -C "${base}" ls-files --error-unmatch "${relfile}" >/dev/null 2>&1
    then
        debug do   git -C "${base}" add -f "${relfile}"
        if [ -d "${base}/${relfile}" -a ! -L "${base}/${relfile}"  ]
        then
            debug in ${base}
            debug ${relfile} is directory so not adding it in git.
        else
            if setup_add_to_version_control_ask "git -C ${base} add -f ${relfile} ? "
            then
                running debug git -C "${base}" add -f "${relfile}"
            fi
        fi
    else
        verbose Already present git -C ${base} add ${relfile}
    fi
}

function setup_add_to_version_control_recursive_links_container_dirs() # NOT REQUIRED
{
    basepath=$1
    targetdir=$2

    targettopleafdir="${basepath}${basepath:+/}${targetdir}"

    debug basepath=$basepath
    debug targetdir=$targetdir

    if [ ! "${targettopleafdir}" ]
    then
        error targettopleafdir=${targettopleafdir} value missing
    fi

    if [ -d "${targettopleafdir}" ]
    then
        cd "${targettopleafdir}"
        # debug SHARAD TEST
        # https://unix.stackexchange.com/questions/68577/find-directories-that-do-not-contain-subdirectories
        local linkdirs=( $(find -type d -links 2 \( \! -name '*BACKUP*' \) | cut -c3- ) )
        cd - > /dev/null 2>&1

        debug linkdirs=${linkdirs[*]}

        # TODO? do something here
        for lnkdir in ${linkdirs[@]}
        do
            if [ -d "${basepath}/${targetdir}/${lnkdir}" ]
            then
                echo '*' > ${basepath}/${targetdir}/${lnkdir}/.gitignore
                running debug setup_add_to_version_control ${basepath} ${targetdir}/${lnkdir}/.gitignore
            else
                warn setup_add_to_version_control_recursive_links_container_dirs: "${basepath}/${targetdir}/${lnkdir}" not exists not addign .gitignore in it
            fi
        done
    else
        error dir ${targettopleafdir} not exists
    fi

}                               # function setup_add_to_version_control_recursive_links_container_dirs()

function setup_add_to_version_control_recursive_links() # SHARAD
{
    basepath=$1
    linkdir=$2

    gitrelbase=$3
    targetdir=$4

    linkbasepath=${basepath}${basepath:+/}${linkdir}

    debug basepath=$basepath
    debug linkdir=$linkdir
    debug targetdir=$targetdir



    if [ -d "${linkbasepath}" ]
    then
        cd ${linkbasepath}
        # debug SHARAD TEST
        local links=( $(find -type l \( \! -name '*BACKUP*' \) | cut -c3- ) )
        cd - > /dev/null 2>&1

        debug links="${links[*]}"

        # TODO? do something here
        for lnk in "${links[@]}"
        do
            running debug setup_add_to_version_control "${basepath}/${gitrelbase}" "${targetdir}/${lnk}"
        done
    else
        error dir "${basepath}/${linkdir}" not exists
    fi

}                               # function setup_add_to_version_control_recursive_links()

function setup_vc_mkdirpath_ensure()
{
    local vcbase="$1"
    local   base="$2"
    local   path="$3"
    local    all="$4"

    mkdir -p ${vcbase}/${base}/${path}
    local dirpath=$path

    while [ "$dirpath" != "." -a "x$dirpath" != "x" ]
    do
        running debug touch "${vcbase}/${base}${base:+/}${dirpath}/.gitignore"
        if [ "$all" ]
        then
            echo '*' > "${vcbase}/${base}${base:+/}${dirpath}/.gitignore"
        fi
        running debug setup_add_to_version_control "${vcbase}" "${base}${base:+/}${dirpath}/.gitignore"
        dirpath="$(dirname $dirpath)"
    done


}
function set_keyboard()
{
    if [ "$DISPLAY" ]
    then
        KEYMODMAP="$HOME/.Xmodmaps/xmodmaprc"
        if [ ! -f "$KEYMODMAP" ]
        then
            KEYMODMAP=$SETUP_TMPDIR/keymap
            if [ ! -f $KEYMODMAP ]
            then
                running debug mkdir -p $SETUP_TMPDIR
                running debug wget -c 'https://raw.githubusercontent.com/sharad/rc/master/keymaps/Xmodmaps/xmodmaprc-swap-alt-ctrl-caps=alt' -O "$SETUP_TMPDIR/keymap"
            fi
        fi

        if [ "$KEYMODMAP" -a -f "$KEYMODMAP" ]
        then
            running debug xmodmap "$KEYMODMAP" || echo xmodmap returned $?
        else
            warn No KEYMODMAP=$KEYMODMAP exists
        fi
    fi
}

function setup_apt_repo()
{
    if [ -d "/run/current-system/profile" ]
    then
        echo setup_apt_repo
    else
        if [ -r /etc/os-release ]
        then
            . /etc/os-release
            if [ ubuntu = "$ID" ]
            then
                UBUNTU_VERSION_NAME="$VERSION"
                debug "Running Debug Ubuntu $UBUNTU_VERSION_NAME"
            else
                warn "Not running debug an Ubuntu distribution. ID=$ID, VERSION=$VERSION" >&2
                exit -1
            fi
        else
            error "Not running debug a distribution with /etc/os-release available" >&2
        fi

        for repo in "$APT_REPO_COMMPUNICATION" "$APT_REPO_UTILS"
        do
            # /etc/apt/sources.list.d/nilarimogard-ubuntu-webupd8-xenial.list
            # debug repo=$repo
            REPO_NAME1="$(print $repo | cut -d: -f2 | cut -d/ -f1)"
            REPO_NAME2="$(print $repo | cut -d: -f2 | cut -d/ -f2)"

            REPO_FILE_PATH=/etc/apt/sources.list.d/${REPO_NAME1}-${ID}-${REPO_NAME2}-${VERSION_CODENAME}.list

            debug REPO_FILE_PATH=$REPO_FILE_PATH

            if [ ! -f "$REPO_FILE_PATH" ]
            then
                sudo add-apt-repository "$repo"
            else
                verbose "$REPO_FILE_PATH" already added.
            fi
        done
    fi
}

function setup_apt_upgrade_system()
{
    # https://guix.gnu.org/blog/2019/guix-profiles-in-practice/
    # https://guix.gnu.org/cookbook/en/
    # https://guix.gnu.org/cookbook/en/html_node/
    # https://guix.gnu.org/cookbook/en/html_node/Advanced-package-management.html#Advanced-package-management
    # https://guix.gnu.org/cookbook/en/html_node/Basic-setup-with-manifests.html#Basic-setup-with-manifests
    LOCAL_GUIX_EXTRA_PROFILES=("dev" "dynamic-hash" "heavy" "lengthy")
    export LOCAL_GUIX_EXTRA_PROFILES
    LOCAL_GUIX_EXTRA_PROFILE_CONTAINER_DIR="$HOME/.setup/guix-config/per-user/$USER"


    if [ -d "/run/current-system/profile" ]
    then
        if running info guix pull
        then
            running info guix pull --news
            if running info sudo guix system reconfigure "${HOME}/.setup/guix-config/per-domain/desktop/config.scm"
            then
                # verbose guix upgrading
                running info guix upgrade # default
                # running debug guix upgrade -p "${HOME}/.setup/guix-config/per-user/s/cdesktopenv/profiles.d/"
                for profile in "${LOCAL_GUIX_EXTRA_PROFILES[@]}"
                do
                    profile_path="$LOCAL_GUIX_EXTRA_PROFILE_CONTAINER_DIR"/"$profile"/profiles.d/"$profile"
                    if [ -f "${profile_path}"/etc/profile ]
                    then
                        running info guix upgrade -p "${profile_path}"
                    else
                        warn file "${profile_path}"/etc/profile not exist, for "${profile_path}"
                    fi
                    unset profile_path
                    unset profile
                done

                verbose guix installing
                running info guix package -m "${HOME}/.setup/guix-config/per-user/s/simple/manifest.scm" # default
                for profile in "${LOCAL_GUIX_EXTRA_PROFILES[@]}"
                do
                    manifest_path="$LOCAL_GUIX_EXTRA_PROFILE_CONTAINER_DIR"/"$profile"/manifest.scm
                    profile_path="$LOCAL_GUIX_EXTRA_PROFILE_CONTAINER_DIR"/"$profile"/profiles.d/"$profile"
                    if [ -f "${manifest_path}" ]
                    then
                        running info guix package -p "${profile_path}" -m "${manifest_path}"
                    else
                        warn file "${manifest_path}" not exist, for "${profile_path}"
                    fi
                    unset profile_path
                    unset profile
                done
            else
                warn guix system reconfigure -- Failed
            fi



            df -hx tmpfs -x devtmpfs

            if false
            then
	              CLEANUP_TIME=96h

                guix package  --delete-generations=$CLEANUP_TIME
                for profile in $LOCAL_GUIX_EXTRA_PROFILES
                do
                    manifest_path="$LOCAL_GUIX_EXTRA_PROFILE_CONTAINER_DIR"/"$profile"/manifest.scm
                    profile_path="$LOCAL_GUIX_EXTRA_PROFILE_CONTAINER_DIR"/"$profile"/profiles.d/"$profile"
                    if [ -f "${manifest_path}" -a -f "${profile_path}"/etc/profile ]
                    then
                        running info guix package -p "${profile_path}" --delete-generations=$CLEANUP_TIME
                    else
                        warn file "${profile_path}"/etc/profile not exist, for "${profile_path}"
                    fi
                    unset profile_path
                    unset profile
                done

                # sudo guix system delete-generations 10m
                ## guix gc -d 15h -C  15G

            fi

            df -hx tmpfs -x devtmpfs

        else
            warn guix pull -- Failed
        fi
    else
        # sudo ${INSTALLER} ${INSTALLER_OPT} clean
        sudo ${INSTALLER} ${INSTALLER_OPT} autoremove
        sudo ${INSTALLER} ${INSTALLER_OPT} autoclean
        sudo ${INSTALLER} ${INSTALLER_OPT} update
        sudo apt-file update
        # sudo ${INSTALLER} ${INSTALLER_OPT} clean
        sudo ${INSTALLER} ${INSTALLER_OPT} autoremove
        sudo ${INSTALLER} ${INSTALLER_OPT} autoclean
        sudo ${INSTALLER} ${INSTALLER_OPT} upgrade
        # sudo ${INSTALLER} ${INSTALLER_OPT} clean
        sudo ${INSTALLER} ${INSTALLER_OPT} autoremove
        sudo ${INSTALLER} ${INSTALLER_OPT} autoclean
        # sudo ${INSTALLER} ${INSTALLER_OPT} clean
        sudo ${INSTALLER} ${INSTALLER_OPT} autoremove
        sudo ${INSTALLER} ${INSTALLER_OPT} autoclean

        sudo ${INSTALLER} ${INSTALLER_OPT} clean
        sudo ${INSTALLER} update
    fi
}

function setup_apt_packages()
{
    running info setup_apt_repo
    running info setup_apt_upgrade_system

    local deb_pkg_lists=(
        DEB_PKG_FIRST_INSTALL
        DEB_PKGS1
        DEB_PKGS2
        DEB_PKG_FIRST_INTERCATIVE_QA
        DEB_PKG_EMACS
        DEB_PKG_MESSAGING
        DEB_PKG_NECESSARY_MORE1
        # TODO BUG set zsh as login shell
        DEB_PKG_NECESSARY_MORE2
        ##  hello-traditional
        DEB_PKG_NECESSARY_MORE3
        DEB_PKG_NECESSARY_MORE4
        DEB_PKG_GAME
        DEB_PKGS_BACKUP
        DEB_PKG_NECESSARY
        DEB_PKG_NECESSARY1
        # DEB_PKG_WITH_ERROR
        DEB_PKG_APPEARANCE
        DEB_PKG_VIRTURALMACHINE

        DEB_EXTRA_PKG1
        DEB_EXTRA_PKG_COMMUNICATION
        DEB_EXTRA_PKG_VIRTUAL
        DEB_EXTRA_PKG_FONTS
        DEB_EXTRA_PKG_LISP
        DEB_EXTRA_PKG2
        DEB_EXTRA_PKG3
        DEB_EXTRA_SEC_PKG1
        DEB_EXTRA_SEC_PKG2
        DEB_DEV_PKG1
        DEB_DEV_PYTHON
        DEB_EXTRA_PKG3_UTILS
        # https://www.cyberciti.biz/faq/removing-pass
        DEB_PKG_DEV
        DEB_PKG_SYSTEM
        DEB_PKG_TOOL
        DEB_PKG_TOOL_MAIL_TEST
        DEB_SYS_PKG1
        # https://linuxconfig.org/fetch-stock-quotes-
        DEB_SYS_MAIL
        DEB_DEV_GTD
        DEB_PKG_LEARNING
        DEB_PKG_TOOL_TERM
        DEB_PKG_TOOL_GUI
        DEB_PKG2_TOOL_GUI
        DEB_PKG3_TOOL_GUI
        DEB_PKG1_TOOL_GUI_XORG
        DEB_PKG_XWM
        DEB_PKG_XML
        DEB_PKG_UTILS
        DEB_PKG_GUI_DEV_UTILS
        DEB_PKG_MEDIA
        DEB_PKG_WINDOW
        DEB_PKG1_NET
        DEB_PKG2_NET
        DEB_PKG_DOC
        DEB_PKG_DOC_PUB
        DEB_PKG_JAVA1
        DEB_PKG_LINT
        DEB_PKG_CM_TOOL
        DEB_PKG_DEB
        DEB_PKG_BUILD
        DEB_PKG_VOICE
        DEB_PKG_FONTS
        DEB_PKG_PROGRAMMING
        DEB_PKG_ASSEMBLY
        DEB_PKG_LANG_LEARN
        DEB_PKG_LANG_OCAML
        DEB_PKG_LANG_SMALLTALK
        DEB_PKG_LANG_SCHEME
	      DEB_PKG_LANGUAGE
        DEB_PKG_NATURAL_LANG
        DEB_PKG_NATURAL_LANG_INDIC
        DEB_PKG_NATURAL_LANG_URDU
        DEB_PKG_NATURAL_LANG_PERSIAN
        DEB_PKG_NATURAL_LANG_ARABIC
        DEB_PKG_CLOUD_VM_TOOLS
    )

    for pkg in "${deb_pkg_lists[@]}"
    do
        if [ ! -d "/run/current-system/profile" ]
        then
            eval echo Intalling pkg list '\$'$pkg='\(' \${$pkg[*]} '\)'
            if ! eval sudo ${INSTALLER} ${INSTALLER_OPT} install \$$pkg
            then
                for p in $(eval print \$$pkg)
                do
                    running info sudo ${INSTALLER} ${INSTALLER_OPT} install ${p}
                done
            fi
        fi
    done

    if [ ! -d "/run/current-system/profile" ]
    then
        for pkg in "$PY_PIP_PKG"
        do
            sudo pip install $pkg
        done
    fi
}

function setup_ecrypt_private()
{
    sudo ${INSTALLER} ${INSTALLER_OPT} install ecryptfs-utils

    if ! mount | grep $HOME/.Private
    then
        if [ ! -f "${HOME}/.ecryptfs/wrapped-passphrase" ]
        then
	          ecryptfs-setup-private
        fi

        # # TODO BUG check for changes in homedir
        # # sed -i 's@/Private@/.Private@' ${HOME}/.ecryptfs/Private.mnt
        # debug $HOME/${RESOURCEPATH}/${USERORGMAIN}/readwrite/private/user/noenc/Private > ${HOME}/.ecryptfs/Private.mnt
        # ecryptfs-mount-private
    fi
    if [ ! -e "${HOME}/.ecryptfs" -o -d "${HOME}/.ecryptfs" ]
    then
        if [ ! -L "${HOME}/.ecryptfs" ]
        then
            cp -ar          "${HOME}/.ecryptfs"                        "${HOME}/.ecryptfs-BAK"
            setup_copy_link "${HOME}/.setup/.config/_home/.ecryptfs"   "${HOME}/.ecryptfs"
            cp -f           "${HOME}/.ecryptfs-BAK/Private.sig"        "${HOME}/.ecryptfs/Private.sig"
            cp -f           "${HOME}/.ecryptfs-BAK/wrapped-passphrase" "${HOME}/.ecryptfs/wrapped-passphrase"
            cp -f           "${HOME}/.ecryptfs-BAK/sedDxBKNi"          "${HOME}/.ecryptfs/sedDxBKNi"
        else
            setup_copy_link "${HOME}/.setup/.config/_home/.ecryptfs"   "${HOME}/.ecryptfs"
        fi
    fi

    # TODO resolve migration of ${HOME}/.ecryptfs/Private.mnt
    # from $HOME/.Private to $HOME/${RESOURCEPATH}/${USERORGMAIN}/readwrite/private/user/noenc/Private
}

function setup_tmp_ssh_keys()
{
    SSH_KEY_ENC_DUMP=$2
    SSH_DIR=$1
    if ! ssh-add -l
    then
        if [ -f "${HOME}/.ssh/login-keys.d/github" -a -f "${HOME}/.ssh/login-keys.d/github.pub" ]
        then
            ssh-add "${HOME}/.ssh/login-keys.d/github"
        fi
    fi                          # if ! ssh-add -l
    if ! ssh-add -l
    then
        sudo ${INSTALLER} ${INSTALLER_OPT} install openssl
        if [ "x$SSH_KEY_ENC_DUMP" != "x" -a -f "$SSH_KEY_ENC_DUMP" ]
        then
            ## bring the ssh keys
            if [ ! -r $SSH_DIR/nosecure.d/ssh/keys.d/github ]
            then
	              mkdir -p $SSH_DIR
                # TODO BUG not working
	              openssl enc -in "$SSH_KEY_ENC_DUMP" -aes-256-cbc -d | tar -zxvf - -C $SSH_DIR
            fi

            if ! ssh-add -l
            then
	              ssh-add $SSH_DIR/nosecure.d/ssh/keys.d/github
            fi
        else                    # if [ "x$SSH_KEY_ENC_DUMP" != "x" -a -f "$SSH_KEY_ENC_DUMP" ]
            error setup_tmp_ssh_keys: key file not provided or not exists.
            exit -1
        fi
    fi                          # if ! ssh-add -l
}

function setup_ssh_keys()
{
    SSH_KEY_ENC_DUMP=$1

    local OSETUP_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/osetup
    ## bring the ssh keys
    if [ ! -r ${OSETUP_DIR}/nosecure.d/ssh/keys.d/github ]
    then
        if [ "x$SSH_KEY_ENC_DUMP" != "x" -a -f "$SSH_KEY_ENC_DUMP" ]
        then
            sudo ${INSTALLER} ${INSTALLER_OPT} install openssl

            SSH_KEY_ENC_DUMP=$1
            SSH_DIR=$2

            if ! mount | grep "$HOME/.Private"
            then
                running info setup_ecrypt_private
                running info /usr/bin/ecryptfs-mount-private
            fi

            if ! mount | grep "$USER/.Private"
            then
                if [ -d ${OSETUP_DIR} ]
                then
                    if [ -d "${OSETUP_DIR}/nosecure.d" -a -L "${OSETUP_DIR}/secure" -a -d "${OSETUP_DIR}/secure" ]
                    then
                        if [ ! -e "${OSETUP_DIR}/nosecure.d/ssh/authorized_keys" ]
                        then
                            touch "${OSETUP_DIR}/nosecure.d/ssh/authorized_keys"
                        fi

                        if [ ! -e "${OSETUP_DIR}/secure/ssh/known_hosts" ]
                        then
                            touch "${OSETUP_DIR}/secure/ssh/known_hosts"
                        fi

                        if [ ! -e "${OSETUP_DIR}/secure/ssh/authorized_keys" ]
                        then
                            touch "${OSETUP_DIR}/secure/ssh/authorized_keys"
                        fi

                        openssl enc -in "$SSH_KEY_ENC_DUMP" -aes-256-cbc -d | tar -zxvf - -C ${OSETUP_DIR}/
                    else        # if [ -d ${OSETUP_DIR}/nosecure.d -a -L ${OSETUP_DIR}/secure -a -d ${OSETUP_DIR}/secure ]
                        error setup_ssh_keys: directories "${OSETUP_DIR}${OSETUP_DIR}/nosecure.d" or "${OSETUP_DIR}/secure" not exists.
                    fi
                else            # if [ -d ${OSETUP_DIR} ]
                    error setup_ssh_keys: directory "${OSETUP_DIR}" not exists.
                fi
            else                # if ! mount | grep "$USER/.Private"
                error setup_ssh_keys: "$USER/.Private" not mounted. >&2
            fi                  # if ! mount | grep "$USER/.Private"
        else                    # if [ "x$SSH_KEY_ENC_DUMP" != "x" -a -f "$SSH_KEY_ENC_DUMP" ]
            error setup_ssh_keys: key file not provided or not exists.
        fi
    fi                          # if [ ! -r ${OSETUP_DIR}/nosecure.d/ssh/keys.d/github ]

    if ! ssh-add -l
    then
	      ssh-add "${OSETUP_DIR}/nosecure.d/ssh/keys.d/github"
    fi
}

function setup_setup_dir()
{
    if [ ! -L ${HOME}/.setup ]
    then
	      rm -rf ${HOME}/.setup
    fi
    setup_make_link "${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/rc" ${HOME}/.setup
}

function setup_pi_dir()
{
    if [ ! -d ${HOME}/.pi -a -d ${HOME}/.setup/pi ]
    then
	      setup_make_link  ".setup/pi" ${HOME}/.pi
	      setup_make_link  ../${RESOURCEPATH}/${USERORGMAIN}/readwrite/private/user/orgp ${HOME}/.pi/org
    fi
}

function setup_emacs_dir()
{
    if [ ! -d ${HOME}/.emacs.d/.git ]
    then
	      if [ -d ${HOME}/.emacs.d ]
        then
            mv ${HOME}/.emacs.d ${HOME}/.emacs.d-old
        fi
	      setup_make_link "${RESOURCEPATH}/${USERORGMAIN}/readonly/public/user/spacemacs" ${HOME}/.emacs.d
    fi
}

function setup_git_tree_repo()
{
    if [ $# -eq 2 ]
    then
        local GITURL=$1
        local GITDIR_BASE=$2

        verbose GITDIR_BASE=${GITDIR_BASE}

        running debug mkdir -p "$(dirname ${GITDIR_BASE} )"
        if [ ! -d "${GITDIR_BASE}/" ]
        then
            if ! running info git -c core.sshCommand="$GIT_SSH_OPTION" clone --recursive  ${GITURL} ${GITDIR_BASE}
            then
                echo Failed git -c core.sshCommand="$GIT_SSH_OPTION" clone --recursive  ${GITURL} ${GITDIR_BASE} >&2
            fi
        else
            if ! running info git -c core.sshCommand="$GIT_SSH_OPTION" -C ${GITDIR_BASE} submodule foreach git -c core.sshCommand="$GIT_SSH_OPTION" status
            then
                echo Failed git -c core.sshCommand="$GIT_SSH_OPTION" -C ${GITDIR_BASE} submodule foreach git -c core.sshCommand="$GIT_SSH_OPTION" status >&2
            fi
            if ! running info git -c core.sshCommand="$GIT_SSH_OPTION" -C ${GITDIR_BASE} submodule foreach git -c core.sshCommand="$GIT_SSH_OPTION" pull --rebase
            then
                echo Failed git -c core.sshCommand="$GIT_SSH_OPTION" -C ${GITDIR_BASE} submodule foreach git -c core.sshCommand="$GIT_SSH_OPTION" pull --rebase >&2
            fi
            # running info git -c core.sshCommand="$GIT_SSH_OPTION" -C ${GITDIR_BASE} pull --rebase
            if ! running info git -c core.sshCommand="$GIT_SSH_OPTION" -C ${GITDIR_BASE} fetch
            then
                echo Failed git -c core.sshCommand="$GIT_SSH_OPTION" -C ${GITDIR_BASE} fetch >&2
            fi
            if ! running info git -c core.sshCommand="$GIT_SSH_OPTION" -C ${GITDIR_BASE} status
            then
                echo Failed git -c core.sshCommand="$GIT_SSH_OPTION" -C ${GITDIR_BASE} status >&2
            fi
        fi
    else
        error setup_git_tree_repo: Not two args giturl gittreedir_base not provided. >&2
    fi
}

function setup_git_annex_repo()
{
    # if .git is plain file than make it symlink
    local gittreeurl="$1"
    local modulepath="$2"
    running debug setup_git_tree_repo "${gittreeurl}" "${modulepath}"
    if [ -e "${modulepath}/.git" ]
    then
        if [ ! -d ${modulepath}/.git ]
        then
            local modulegitpath="$(cat ${modulepath}/.git)"
            rm -f ${modulepath}/.git
            ln -s "${modulegitpath}" "${modulepath}/.git"
        fi

        modbasename="$(basename $modulepath)"
        git -C ${modulepath} annex init "$modbasename on ${HOST}"
    fi
}

function setup_git_tree_annex_repo()
{
    # if .git is plain file than make it symlink
    local gittreeurl=$1
    local treedir=$2
    local module=$3
    local modulepath=${treedir}/${module}
    running info setup_git_tree_repo "${gittreeurl}" "${treedir}"
    if [ -d "${treedir}" ]
    then
        running info setup_git_annex_repo "${gittreeurl}" "${modulepath}"
    fi
}

function setup_git_repos()
{
    # TODO [ISSUE] add code to handle upstream remote branch changes and merging to origin branch

    # RESOURCEPATH=".repos/git/main/resource"
    # USERORGMAIN="userorg/main"

    running info setup_git_tree_repo "git@github.com:sharad/userorg.git" ${HOME}/${RESOURCEPATH}/userorg
    running info setup_git_annex_repo "git@bitbucket.org:sh4r4d/doclibrary.git" ${HOME}/${RESOURCEPATH}/userorg/main/readwrite/public/user/doc/Library

    if true                    # decide through command line arguments
    then
        running info setup_git_tree_repo "git@bitbucket.org:sh4r4d/docorg.git" ${HOME}/${RESOURCEPATH}/info/doc/orgs/private/doc
        running info setup_git_tree_repo "git@bitbucket.org:sh4r4d/mediaorg.git" ${HOME}/${RESOURCEPATH}/data/multimedia/orgs/private/media/
        running info setup_git_annex_repo "git@bitbucket.org:sh4r4d/mediaorg.git" ${HOME}/${RESOURCEPATH}/data/multimedia/orgs/private/media/collection
    fi
}

function setup_config_dirs()
{
    running info setup_ecrypt_private
    running info setup_setup_dir
    running info setup_pi_dir
    running info setup_emacs_dir
}

function setup_user_config_setup()
{
    RCHOME="$HOME/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/rc/.config/_home/"

    setup_copy_link ${HOME}/.setup/.config/_home/.dirs.d ${HOME}/.dirs.d
    setup_copy_link ${HOME}/.setup/.config/_home/.fa     ${HOME}/.fa


    if [ -d "${RCHOME}" ]
    then
	      if running debug mkdir -p ${HOME}/_old_dot_filedirs
        then
	          # mv ${HOME}/.setup/.config/_home/.setup $SETUP_TMPDIR/Xsetup
	          cd "${RCHOME}"
	          for c in .[a-zA-Z^.^..]* *
	          do
                debug considering $c
                clink=$(readlink $c)
	              if [ "$c" != ".repos" -a "$c" != ".setup" -a "$c" != ".gitignore" -a "$c" != "acyclicsymlinkfix" -a "$c" != "." -a "$c" != ".." -a "$clink" != ".." ] # very important
	              then
                    # setup_copy_link $c ${HOME}/$c
		                if [ -e ${HOME}/$c ]
		                then
                        if [ ! -L ${HOME}/$c -o "$(readlink ${HOME}/$c)" != "$(readlink $c)" ]
                        then

                            if [ ! -L ${HOME}/$c ] # backup
                            then
		                            running debug mv ${HOME}/$c ${HOME}/_old_dot_filedirs
                            fi

                            if [ ! -e ${HOME}/$c ]
                            then
		                            running debug cp -af $c ${HOME}/$c
                                # exit -1
                            elif [ -L ${HOME}/$c ]
                            then
                                running debug rm -f ${HOME}/$c
                                running debug cp -af $c ${HOME}/$c
                                # exit -1
                                # continue
                            fi
                            verbose done setting up $c

                        else    # if [ ! -L ${HOME}/$c -o "$(readlink ${HOME}/$c)" != "$(readlink $c)" ]
                            verbose not doing anything $c ${HOME}/$c
                        fi      # if [ ! -L ${HOME}/$c -o "$(readlink ${HOME}/$c)" != "$(readlink $c)" ]
                    else        # if [ -e ${HOME}/$c ]
                        running debug cp -af $c ${HOME}/$c
                        verbose done setting up $c
		                fi          # if [ -e ${HOME}/$c ]
                else            # if [ "$c" != ".repos" -a "$c" != ".setup" -a "$c" != ".gitignore" -a "$c" != "acyclicsymlinkfix" -a "$c" != "." -a "$c" != ".." -a "$clink" != ".." ] # very important
                    verbose not setting up $c
	              fi              # if [ "$c" != ".repos" -a "$c" != ".setup" -a "$c" != ".gitignore" -a "$c" != "acyclicsymlinkfix" -a "$c" != "." -a "$c" != ".." -a "$clink" != ".." ] # very important
	          done
	          # mv $SETUP_TMPDIR/Xsetup ${HOME}/.setup/.config/_home/.setup
	          cd - > /dev/null 2>&1
        fi                      # if mkdir -p ${HOME}/_old_dot_filedirs
        rmdir ${HOME}/_old_dot_filedirs
    else                        # if [ -d "${RCHOME}" ]
        error "${RCHOME}" not exists >&2
    fi                          # if [ -d "${RCHOME}" ]
}

function setup_download_misc()
{
    if false
    then
        if [ ! -f /usr/local/bin/p4 ]
        then
	          wget 'https://www.perforce.com/downloads/free/p4' -O $SETUP_TMPDIR/p4
	          sudo cp $SETUP_TMPDIR/p4 /usr/local/bin/p4
	          sudo chmod +x /usr/local/bin/p4
        fi
    fi
}

function setup_sshkeys()
{
    :
}

function setup_Documentation()  # TODO
{
    running debug setup_copy_link ${HOME}/.setup/.config/_home/Documents ${HOME}/Documents
}

function setup_public_html()    # TODO
{
    running debug setup_copy_link ${HOME}/.setup/.config/_home/public_html ${HOME}/public_html
}

function setup_mail_and_metadata()
{
    local USERDIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user
    local LOCALDIRS_DIR=${USERDIR}/localdirs
    local maildata_path="${LOCALDIRS_DIR}/org/resource.d/view.d/maildata"
    local preserved_path="${LOCALDIRS_DIR}/org/resource.d/view.d/preserved"


    if [ -e "${maildata_path}" -a -L "${maildata_path}" -a -d "${maildata_path}" ]
    then
        running debug readlink -m "${maildata_path}"
        running debug mkdir -p  "${maildata_path}/mail-and-metadata/offlineimap"
        running debug mkdir -p  "${maildata_path}/mail-and-metadata/maildir"
        running debug mkdir -p  "${preserved_path}/mailattachments"
    else
        warn  mail data path "${maildata_path}" not present.
    fi

}

function setup_mail()
{
    local SYSTEM_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/system/system
    sudo ${INSTALLER} ${INSTALLER_OPT} install dovecot-core dovecot-imapd ntpdate postfix
    if [ -d ${SYSTEM_DIR}/ubuntu/etc/postfix ]
    then
        if [ ! -d /etc/postfix-ORG ]
        then
            running info sudo cp -ar /etc/postfix /etc/postfix-ORG
            for f in ${SYSTEM_DIR}/ubuntu/etc/postfix/*
            do
                b=$(basename $f)
                running debug cp $f /etc/postfix/
            done
        fi

        if [ ! -d /etc/dovecot-ORG ]
        then
            running info sudo cp -ar /etc/dovecot /etc/dovecot-ORG
            running info sudo cp ${SYSTEM_DIR}/ubuntu/etc/dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
        fi
    else
        error ${SYSTEM_DIR}/ubuntu/etc/postfix not exists >&2
    fi
}

function setup_ldapsearch()
{
    echo todo implement setup_ldapsearch >&2

    echo M4 TODO .ldapsearh
}

function setup_gnomekeyring()
{
    echo secret-tool store --label offlineimap server localhost user "$USER" protocol imap
    echo secret-tool store --label offlineimap server '$IMAP_SERVER' user '$DOMAIN\$USER' protocol imap
}

function setup_password()
{
    running info echo ${HOME}/.ldappass /etc/postfix/sasl_passwd etc
}

function setup_crontab()
{
    m4 ${HOME}/.setup/crontab.m4 2>/dev/null | tee ${HOME}/.setup/crontab | crontab
}

function setup_login_shell()
{
    curshell="$(getent passwd $USER | cut -d: -f7)"
    if [ "$curshell" != "/bin/zsh" ]
    then
        running info sudo ${INSTALLER} ${INSTALLER_OPT} install zsh
        running info chsh -s /bin/zsh
    fi
}

function setup_advertisement_blocking()
{
    # TODO: https://github.com/StevenBlack/hosts.git
    # pip3 install --user -r requirements.txt
    # python3 updateHostsFile.py  --extensions fakenews gambling porn social
    :
}

function setup_paradise()
{
    curhomedir="$(getent passwd $USER | cut -d: -f6)"
    if [ "$(basename $curhomedir)" != hell ]
    then
        running info sudo rm -rf $curhomedir/hell # if exists
        newhomedir=$curhomedir/hell
        running info sudo mv $curhomedir ${curhomedir}_tmp
        running info sudo mkdir -p $curhomedir
        running info sudo mv ${curhomedir}_tmp "$newhomedir"
        # sudo mkdir -p "$newhomedir"
        running info sudo usermod -d "$newhomedir" $USER
        warn first change home dir to $newhomedir
        exit -1
        export HOME="$newhomedir"
    fi
}

###{{{ libs
function setup_mvc_dirs()
{
    if [ $# -eq 1 ]
    then
        containerdir="$1"

        running debug mkdir -p ${containerdir}/model.d
        if [ -d ${containerdir}/model.d ] && ls ${containerdir}/model.d/*
        then
            modelsymlink=0
            for sdir in ${containerdir}/model.d/*
            do
                if [ -L "$sdir" ]
                then
                    modelsymlink=1
                fi
                sdirbase=$(basename "$sdir")
                running debug setup_make_link ../model.d/${sdirbase} ${containerdir}/control.d/${sdirbase}
            done
            if [ "$modelsymlink" -eq 0 ]
            then
                error setup_mvc_dirs: No symlink for model dirs exists in ${containerdir}/model.d create it.
            fi
        fi              # if [ -d ${containerdir}/model.d ]

        running debug mkdir -p ${containerdir}/control.d
        if [ -d ${containerdir}/control.d ] && ls ${containerdir}/control.d/*
        then
            modelsymlink=0
            for sdir in ${containerdir}/control.d/*
            do
                if [ -L "$sdir" ]
                then
                    modelsymlink=1
                fi
                sdirbase=$(basename "$sdir")
                running debug setup_make_link ../control.d/${sdirbase} ${containerdir}/view.d/${sdirbase}
            done
            if [ "$modelsymlink" -eq 0 ]
            then
                error setup_mvc_dirs: No symlink for control dirs exists in ${containerdir}/control.d create it.
            fi
        fi              # if [ -d ${containerdir}/control.d ]
    else
        error one dir argument is require, but provided $# "$@"
    fi
}


function setup_machine_dir()
{
    # use namei to track
    # running debug setup_paradise

    local OSETUP_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/osetup
    local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs


    # setup_copy_link ${HOME}/.setup/.config/_home/.dirs.d ${HOME}/.dirs.d
    # setup_copy_link ${HOME}/.setup/.config/_home/.fa     ${HOME}/.fa

    if [ -d ${LOCALDIRS_DIR} ]
    then
        running debug mkdir -p "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d"
        running debug mkdir -p "${LOCALDIRS_DIR}/org/deps.d/control.d/machine.d"
    fi

    # check local home model.d directory
    if [ -d "${LOCALDIRS_DIR}" -a -d "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d" ]
    then
        if [ ! -d "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST" ]
        then
            running debug mkdir -p "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST"
            if [ -d "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST" ]
            then
                running debug  cp -ar "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/sample" "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST"
                debug add "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST" into git
            fi
        fi                      # if [ ! -d ${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST ]
    fi                          # if [ -d ${LOCALDIRS_DIR} -a -d ${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d ]

    if [ -d "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST" ]
    then
        running debug setup_make_link "$HOST" "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/default"
        # debug SHARAD TEST
        debug running debug setup_make_relative_link "${LOCALDIRS_DIR}/org/deps.d" " model.d/machine.d/default"  "control.d/machine.d/default"
    fi
}

###{{{ libs
## workers
function setup_make_path_by_position()
{
    classpath=class/$1
    storage_path=storage/$2
    classcontainer=container/$3
    position=${4-2}

    if [ $# -eq 4 ]
    then
        if [ "class/" != "x${classpath}" ]
        then
            case $position in
                1) print "${classpath}/${storage_path}/${classcontainer}";;
                2) print "${storage_path}/${classpath}/${classcontainer}";;
                3) print "${storage_path}/${classcontainer}/${classpath}";;
            esac
        else
            print "${storage_path}/${classcontainer}"
        fi
    else
        error Need 4 arguments.
    fi
}

function setup_dep_control_storage_class_dir()
{
    debug setup_dep_control_storage_class_dir \#=$#

    if [ $# -eq 4 ]
    then
        local storage_path="$1"
        local class="$2"
        local classinstdir="$3"
        local position=${4-2}


        local classcontainer=$(basename $class)
        local classpath=$(dirname $class)
        if [ ${classpath} = "." ]
        then
            classpath=
        fi

        local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs
        local machinedir="${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d"
        local hostdir="${machinedir}/$HOST"

        # TODO?
        local classcontroldir_rel_path=$(setup_make_path_by_position "${classpath}" "${storage_path}" "${classcontainer}.d" "$position")
        local classcontrol_dir_path="${hostdir}/volumes.d/control.d/${classcontroldir_rel_path}"

        # # TODO?
        # local sysdatasdirname=${dataclassname}/${storage_path}/${sysdataname}s.d
        local pcount=$(setup_count_slash_in_path ${classcontroldir_rel_path})
        local ppath=$(setup_make_parent_path $pcount)


        # local fullupdirs="${ppath}/../../.."
        local fullupdirs="${ppath}/../.."

        debug pcount=$pcount ppath=$ppath for ${classcontroldir_rel_path}
        debug updirsclasscontroldir_rel_path=$updirsclasscontroldir_rel_path fullupdirs-$fullupdirs



        running debug setup_deps_model_volumes_dirs "${storage_path}"


        # mkdir -p $classcontrol_dir_path/model.d
        running debug mkdir -p "$classcontrol_dir_path"
        # mkdir -p $classcontrol_dir_path/view.d
        # TODO?STATS
        if [ -d "${hostdir}/volumes.d/model.d/${storage_path}/" ] && ls "${hostdir}/volumes.d/model.d/${storage_path}"/* > /dev/null 2>&1
        then
            modelsymlink=0
            for mdir in "${hostdir}/volumes.d/model.d/${storage_path}"/*
            do
                if [ -L "$mdir" ]
                then
                    modelsymlink=1
                fi

                mdirbase=$(basename "$mdir")
                volclasspathinstdir="model.d/${storage_path}/${mdirbase}/${classpath}${classpath:+/}${classinstdir}"

                debug mdirbase=$mdirbase

                running debug sudo mkdir -p "${hostdir}/volumes.d/${volclasspathinstdir}"
                running debug sudo chown "$USER.$(id -gn)" "${hostdir}/volumes.d/${volclasspathinstdir}"


                debug fullupdirs=$fullupdirs
                # running debug setup_make_link ${fullupdirs}/${volclasspathinstdir} $classcontrol_dir_path/model.d/${mdirbase}
                # debug running debug setup_make_link ${fullupdirs}/${volclasspathinstdir} $classcontrol_dir_path/${mdirbase}
                running debug setup_make_link "${fullupdirs}/${volclasspathinstdir}" "$classcontrol_dir_path/${mdirbase}"

                # SHARAD
                running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "${classcontrol_dir_path}/${mdirbase}"

            done

            if [ "$modelsymlink" -eq 0 ]
            then
                error setup_dep_control_storage_class_dir: No symlink for model volume dirs exists in "${hostdir}/volumes.d/model.d/${storage_path}/" create it.
            fi
        fi              # if [ -d ${hostdir}/volumes.d/model.d ]

        # running debug setup_mvc_dirs ${classcontrol_dir_path}/
    else
        error setup_dep_control_storage_class_dir Not correct number of arguments.
    fi
}

function setup_deps_control_class_dir()
{
    # use namei to track

    # ls ${HOME}/.fa/localdirs/org/deps.d/model.d/machine.d/default/volumes.d/model.d/*/
    # ls ${HOME}/fa/localdirs/org/deps.d/model.d/machine.d/$HOST/${class}.d/

    debug setup_deps_control_class_dir \#=$#

    if [ $# -eq 4 ]
    then
        local storage_path="$1"
        local class="$2"
        local classinstdir="$3"
        local position=${4-2}

        local classcontainer=$(basename $class)
        local classpath=$(dirname $class)
        if [ ${classpath} = "." ]
        then
            classpath=
        fi

        local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs
        local machinedir="${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d"
        local hostdir="${machinedir}/$HOST"


        # check local home model.d directory
        if [ -d "${LOCALDIRS_DIR}" -a -d "${machinedir}" ]
        then
            if [ -d "${hostdir}" ]
            then
                running debug mkdir -p "${hostdir}"

                running debug setup_make_link "$HOST" "${machinedir}/default"

                # BACK
                debug running debug setup_dep_control_storage_class_dir "$storage_path" "$class" "$classinstdir" "${position}"
                running debug setup_dep_control_storage_class_dir "$storage_path" "$class" "$classinstdir" "${position}"

            else                # if [ -d ${hostdir} ]
                debug Please prepare "${hostdir}" for your machine >&2
                exit -1
            fi                  # if [ -d ${hostdir} ]

        else                    # if [ -d ${LOCALDIRS_DIR} -a -d ${machinedir} ]
            warn "${LOCALDIRS_DIR}" or "${machinedir}" not exists. >&2
        fi                      # if [ -d ${LOCALDIRS_DIR} -a -d ${machinedir} ]
    else
        error setup_deps_control_class_dir: Not correct number of arguments.
    fi                          # if [ $# -eq 2 ]
}

function setup_deps_control_class_all_positions_dirs()
{
    # use namei to track

    # ls ${HOME}/.fa/localdirs/org/deps.d/model.d/machine.d/default/volumes.d/model.d/*/
    # ls ${HOME}/fa/localdirs/org/deps.d/model.d/machine.d/$HOST/${class}.d/
    debug setup_deps_control_class_all_positions_dirs  \#=$#

    if [ $# -eq 3 ]
    then
        local storage_path="$1"
        local class="$2"
        local classinstdir="$3"
        for pos in  1 2 3
        do
            debug running debug setup_deps_control_class_dir "${storage_path}" "${class}" "${classinstdir}" "${pos}"
            running debug setup_deps_control_class_dir "${storage_path}" "${class}" "${classinstdir}" "${pos}"
        done
    else
        error setup_deps_control_class_all_positions_dirs: Not correct number of arguments.
    fi
}

function setup_deps_control_data_usrdata_dirs()
{
    storage_path="${1-local}"

    running debug setup_deps_control_class_all_positions_dirs "$storage_path" "${dataclassname}/usrdatas" "usrdata"
}
function setup_deps_control_data_sysdata_dirs()
{
    storage_path="${1-local}"

    running debug setup_deps_control_class_all_positions_dirs "$storage_path" "${dataclassname}/sysdatas" "sysdata"
}
function setup_deps_control_data_scratches_dirs()
{
    storage_path="${1-local}"

    running debug setup_deps_control_class_all_positions_dirs "$storage_path" "${dataclassname}/scratches" "scratch"
}
function setup_deps_control_data_main_dirs()
{
    storage_path="${1-local}"

    running debug setup_deps_control_class_all_positions_dirs "$storage_path" "${dataclassname}/main" "main"
}
function setup_deps_control_data_dirs()
{
    local storage_path="${1-local}"

    running debug setup_deps_control_data_usrdata_dirs   "$storage_path"
    running debug setup_deps_control_data_sysdata_dirs   "$storage_path"
    running debug setup_deps_control_data_scratches_dirs "$storage_path"
    running debug setup_deps_control_data_main_dirs      "$storage_path"
}
function setup_deps_control_home_Downloads_dirs()
{
    local storage_path="${1-local}"

    # running debug setup_deps_model_volumes_dirs "${storage_path}"
    # running debug setup_deps_control_class_dir "$storage_path" ${homeclassname}/Downloads Downloads
    running debug setup_deps_control_class_all_positions_dirs "$storage_path" "${homeclassname}/Downloads" "Downloads"
}
function setup_deps_control_home_dirs()
{
    local storage_path="${1-local}"

    running debug setup_deps_control_home_Downloads_dirs "$storage_path"
}


function setup_deps_control_data_usrdata_dir()
{
    local storage_path="${1-local}"
    local position=${1-2}

    running debug setup_deps_control_class_dir "$storage_path" "${dataclassname}/usrdatas" "usrdata" "$position"
}
function setup_deps_control_data_sysdata_dir()
{
    local storage_path="${1-local}"
    local position=${1-2}

    running debug setup_deps_control_class_dir "$storage_path" "${dataclassname}/sysdatas" "sysdata" "$position"
}
function setup_deps_control_data_scratches_dir()
{
    local storage_path="${1-local}"
    local position=${1-2}

    running debug setup_deps_control_class_dir "$storage_path" "${dataclassname}/scratches" "scratch" "$position"
}
function setup_deps_control_data_main_dir()
{
    local storage_path="${1-local}"
    local position=${1-2}

    running debug setup_deps_control_class_dir "$storage_path" "${dataclassname}/main" "main" "$position"
}
function setup_deps_control_data_dir()
{
    local storage_path="${1-local}"
    local position=${1-2}

    running debug setup_deps_control_data_usrdata_dir   "$storage_path" "$position"
    running debug setup_deps_control_data_sysdata_dir   "$storage_path" "$position"
    running debug setup_deps_control_data_scratches_dir "$storage_path" "$position"
    running debug setup_deps_control_data_main_dir      "$storage_path" "$position"
}
function setup_deps_control_home_Downloads_dir()
{
    local storage_path="${1-local}"
    local position=${1-2}

    # running debug setup_deps_model_volumes_dir "${storage_path}"
    # running debug setup_deps_control_class_dir "$storage_path" ${homeclassname}/Downloads Downloads
    running debug setup_deps_control_class_dir "$storage_path" "${homeclassname}/Downloads" "Downloads" "$position"
}
function setup_deps_control_home_dir()
{
    local storage_path="${1-local}"
    local position=${1-2}

    setup_deps_control_home_Downloads_dir "$storage_path" "$position"
}




###}}}

# deps/model
function setup_deps_model_storage_volumes_dir()
{
    local storage_path=${1-local}
    local storageclassdirpath="/srv/volumes/$storage_path/"

    local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs

    deps_model_storageclass_path="${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST/volumes.d/model.d/${storage_path}"
    rel_deps_model_storageclass_path="org/deps.d/model.d/machine.d/$HOST/volumes.d/model.d/${storage_path}"

    running debug mkdir -p "${deps_model_storageclass_path}"

    if [ -d ${deps_model_storageclass_path} -a -d $storageclassdirpath ]
    then
        modelsymlink_present=0
        for vgd in "${storageclassdirpath}"/*
        do
            modelsymlink_present=1
            for vld in ${vgd}/*
            do
                local _location="$vld/users/$USER"
                if [ ! -d ${_location} ]
                then
                    running debug sudo mkdir -p "${_location}"
                fi
                if [ -d ${_location} ]
                then
                    running debug sudo chown root.root "${_location}"
                fi

                vgdbase=$(basename $vgd)
                vldbase=$(basename $vld)
                vgldirlink=${vgdbase}-${vldbase}
                debug vgd=$vgd
                debug vld=$vld
                debug vgdbase=$vgdbase
                debug vldbase=$vldbase
                running debug setup_make_link              "${_location}"     "${deps_model_storageclass_path}/${vgldirlink}"
                running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "${rel_deps_model_storageclass_path}/${vgldirlink}"
            done
        done

        if [ "$modelsymlink_present" -eq 0 ]
        then
            error No disk partition mount are present in "${storageclassdirpath}" create them. >&2
        fi
    else
        error No dir exists "${deps_model_storageclass_path}"
    fi       # if [ -d ${deps_model_storageclass_path} -a -d /srv/volumes/local ]
}

function setup_deps_model_volumes_dirs()
{
    local storage_path="${1-local}"

    # use namei to track
    local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs
    # check local home model.d directory

    running debug mkdir -p "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST/volumes.d/model.d"

    running debug setup_deps_model_storage_volumes_dir "$storage_path"
}

function setup_deps_model_dir()
{
    local storage_path="${1-local}"

    running debug setup_machine_dir

    # use namei to track
    local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs
    # check local home model.d directory
    if [ -d "${LOCALDIRS_DIR}" -a -d "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d" ]
    then

        # running debug setup_machine_dir

        if [ -d "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST" ]
        then
            running debug mkdir -p "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST"

            running debug setup_make_link "$HOST" "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/default"

            running debug setup_make_relative_link ${HOME}/ "" "${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs/org/deps.d/model.d/machine.d/$HOST/home"
            running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/deps.d/model.d/machine.d/$HOST/home"

            running debug mkdir -p "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST/volumes.d/model.d"

            running debug setup_deps_model_volumes_dirs "$storage_path"

        else                    # if [ -d ${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST ]
            error Please prepare "${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST" for your machine >&2
            exit -1
        fi                      # if [ -d ${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d/$HOST ]
    fi                          # if [ -d ${LOCALDIRS_DIR} -a -d ${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d ]

}

## Continue from here.

# deps/control
function setup_deps_control_volumes_dirs()
{
    # TODO?
    local storage_path="${1-local}"
    local position=${2-2}

    local sysdataname=sysdata   # ${logicaldirs[*]}
    local viewdirname=view.d
    local sysdatascontinername="${dataclassname}/${sysdataname}s"

    local classcontroldir_rel_path=$(setup_make_path_by_position "${dataclassname}" "${storage_path}" "${sysdataname}s.d" "$position" )
    local sysdatasdirname="${classcontroldir_rel_path}"

    local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs
    local machinedir="${LOCALDIRS_DIR}/org/deps.d/model.d/machine.d"
    local hostdir="${machinedir}/$HOST"
    local volumedir="${hostdir}/volumes.d"

    running debug setup_deps_control_class_dir "$storage_path" "$sysdatascontinername" "$sysdataname" "$position"

    for cdir in "${logicaldirs[@]}" # config deletable longterm preserved shortterm maildata
    do
        debug "${volumedir}/${viewdirname}/$cdir"

        if [ ! -L "${volumedir}/${viewdirname}/$cdir" -o ! -d "${volumedir}/${viewdirname}/$cdir" ]
        then
            # TODO? STATS
            if ls "${volumedir}/control.d/${sysdatasdirname}"/* > /dev/null 2>&1
            then
                for sysdatadir in "${volumedir}/control.d/${sysdatasdirname}"/*
                do
                    # TODO? -sharad
                    volsysdatadirbase="$(basename ${sysdatadir})"
                    running debug mkdir -p "${volumedir}/control.d/${sysdatasdirname}/${volsysdatadirbase}/$cdir"
                done
            fi
        fi
    done
}

function setup_deps_control_dir()
{
    local storage_path="${1-local}"

    running debug setup_deps_control_data_dirs "$storage_path"
    running debug setup_deps_control_home_dirs "$storage_path"

    for pos in 1 2 3
    do
        running debug setup_deps_control_volumes_dirs "$storage_path" "$pos"
    done

}

# deps/view
function setup_deps_view_volumes_dirs()
{

    # TODO? not working ! correct it.

    local storage_path="${1-local}"
    local position=${2-2}

    # TODO?
    # ls ${HOME}/.fa/localdirs/org/deps.d/model.d/machine.d/default/volumes.d/control.d/

    # logicaldirs=(config deletable longterm preserved shortterm maildata)

    # use namei to track
    local BASE_DIR=~
    local LOCALDIRS_DIR="${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs"
    local machinedir="org/deps.d/model.d/machine.d"
    local hostdir="${machinedir}/$HOST"
    local volumedir="${hostdir}/volumes.d"
    local sysdataname="sysdata"
    # TODO?
    local sysdatascontinername="${dataclassname}/${sysdataname}s"
    # TODO?
    # local sysdatasdirname=${dataclassname}/${storage_path}/${sysdataname}s.d
    local viewdirname="view.d"

    # debug SHARAD TEST

    # need to create ${LOCALDIRS_DIR}/org/deps.d/view.d/



    running debug setup_make_relative_link ${BASE_DIR}/${LOCALDIRS_DIR}/org/deps.d control.d/machine.d/default/home       view.d/home
    running debug setup_add_to_version_control ${BASE_DIR}/${LOCALDIRS_DIR} org/deps.d/view.d/home
    running debug setup_make_relative_link ${BASE_DIR}/${LOCALDIRS_DIR}/org/deps.d control.d/machine.d/default/volumes.d  view.d/volumes.d
    running debug setup_add_to_version_control ${BASE_DIR}/${LOCALDIRS_DIR} org/deps.d/view.d/volumes.d



    # check local home model.d directory
    if [ -d ${BASE_DIR}/${LOCALDIRS_DIR} -a -d ${BASE_DIR}/${LOCALDIRS_DIR}/${machinedir} ]
    then                        # doing for path/volume.d mainly
        if [ -d ${BASE_DIR}/${LOCALDIRS_DIR}/${hostdir} ]
        then

            running debug mkdir -p ${BASE_DIR}/${LOCALDIRS_DIR}/${hostdir}

            running debug setup_make_link $HOST ${BASE_DIR}/${LOCALDIRS_DIR}/${machinedir}/default


            if [ -d ${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/model.d ]
            then

                cd ${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/model.d/
                local links=( $(find -type l \( \! -name '*BACKUP*' \) | cut -c3- ) )
                cd - > /dev/null 2>&1

                modelsymlink=0
                for mdir in "${links[@]}"
                do
                    # debug $mdir
                    if [ -L "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/model.d/$mdir" ]
                    then
                        modelsymlink=1
                    fi
                done

                if [ "$modelsymlink" -eq 0 ]
                then
                    error setup_deps_view_volumes_dirs: No symlink for model dirs exists in ${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/model.d create it. >&2
                fi
            else
                error ${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/model.d not exists.
            fi                  # if [ -d ${volumedir}/model.d ]


            # running debug setup_deps_control_data_sysdata_dirs
            # running debug setup_deps_control_class_dir "$storage_path" $sysdatascontinername $sysdataname
            running debug setup_deps_control_volumes_dirs "$storage_path" $position
            # TODO?
            running debug setup_deps_control_class_dir "$storage_path" "$sysdatascontinername" "$sysdataname" "$position"



            # touch ${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/.gitignore
            # echo running debug setup_add_to_version_control ${BASE_DIR}/${LOCALDIRS_DIR} ${volumedir}/${viewdirname}/.gitignore
            # running debug setup_add_to_version_control ${BASE_DIR}/${LOCALDIRS_DIR} ${volumedir}/${viewdirname}/.gitignore

            # TODO? NOW

            local sysdatasdirname=$(setup_make_path_by_position "${dataclassname}" "$storage_path" "${sysdataname}s.d" "$position")

            local todopath="${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/TODO-${sysdatasdirname//\//_}"
            local missingpath="${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/MISSING_TODO-${sysdatasdirname//\//_}"

            running debug rm -f $todopath
            running debug rm -f $missingpath

            running debug mkdir -p ${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}
            running debug rm -f ${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/.gitignore

            for cdir in "${logicaldirs[@]}" # config deletable longterm preserved shortterm maildata
            do
                debug "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir"

                echo $cdir >> ${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/.gitignore

                if [ ! -L "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir" -o ! -d "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir" ]
                then
                    if [ ! -L "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir" ]
                    then
                        error No symlink exists for "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir", prepare it.
                    fi
                    if [ ! -d "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir" ]
                    then
                        error No target directory $(readlink -m $cdir) exist for symlink "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir", create it.
                    fi

                    for sysdatadir in ${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/control.d/${sysdatasdirname}/*
                    do
                        volsysdatadirbase=$(basename ${sysdatadir})
                        debug ln -s ../control.d/${sysdatasdirname}/${volsysdatadirbase}/$cdir "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir"

                    done
                fi




                print  >> $todopath
                print ls "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/control.d/${sysdatasdirname}/" >> $todopath
                ls "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/control.d/${sysdatasdirname}/"      >> $todopath
                print  >> $todopath
                for sysdatadir in "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/control.d/${sysdatasdirname}"/*
                do
                    volsysdatadirbase=$(basename ${sysdatadir})
                    print ln -s ../control.d/${sysdatasdirname}/${volsysdatadirbase}/$cdir "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir" >> $todopath
                    print  >> $todopath
                    print ln -s ../control.d/${sysdatasdirname}/${volsysdatadirbase}/$cdir "$cdir" >> $todopath
                    print  >> $todopath

                    if [ ! -e "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir" -o ! -L "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir" ]
                    then
                        print ln -s ../control.d/${sysdatasdirname}/${volsysdatadirbase}/$cdir "${BASE_DIR}/${LOCALDIRS_DIR}/${volumedir}/${viewdirname}/$cdir" >> $missingpath
                        print  >> $missingpath
                        print ln -s ../control.d/${sysdatasdirname}/${volsysdatadirbase}/$cdir "$cdir" >> $missingpath
                        print  >> $missingpath
                    fi
                done
                print  >> $todopath
                print  >> $todopath

            done

            running debug setup_add_to_version_control "${BASE_DIR}/${LOCALDIRS_DIR}" "${volumedir}/${viewdirname}/.gitignore"

        else                    # if [ -d ${hostdir} ]
            error Please prepare "${hostdir}" for your machine >&2
            exit -1
        fi                      # if [ -d ${hostdir} ]
    else
        error "${BASE_DIR}/${LOCALDIRS_DIR}" or "${BASE_DIR}/${LOCALDIRS_DIR}/${machinedir}" not exists
        exit -1
    fi                          # if [ -d ${LOCALDIRS_DIR} -a -d ${machinedir} ]
}                               # function setup_deps_view_volumes_dirs()

function setup_deps_view_dir()
{
    local storage_path="${1-local}"

    for pos in 1 2 3
    do
        running debug setup_deps_view_volumes_dirs "$storage_path" "$pos"
    done
}

# deps
function setup_deps_dirs()
{
    local storage_path="${1-local}"

    running debug setup_deps_model_dir   "$storage_path"
    running debug setup_deps_control_dir "$storage_path"
    running debug setup_deps_view_dir    "$storage_path"
}

function setup_org_resource_dirs()
{
    # TODO: not getting added in version control
    local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs


    # org/resource.d/control.d/class/data/storage/local/container/scratches.d/Public/
	  # org/resource.d/control.d/class/data/storage/local/container/scratches.d/local

    running debug setup_recursive_links ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user "localdirs/org/resource.d" \
                                                                                         "osetup/dirs.d/org/resource.d"
    running debug setup_add_to_version_control_recursive_links ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user "localdirs/org/resource.d" \
                                                                                                                "osetup" \
                                                                                                                "dirs.d/org/resource.d"

    # TODO: add support for git add
    running debug setup_recursive_links_container_dirs                        "${LOCALDIRS_DIR}/org" \
                                                                        "deps.d/control.d/machine.d/default/volumes.d/model.d" \
                                                                        "resource.d/model.d"

    running debug setup_add_to_version_control_recursive_links_container_dirs "${LOCALDIRS_DIR}" \
                                                                        "org/resource.d/model.d"

    running debug setup_recursive_links_container_dirs                        "${LOCALDIRS_DIR}/org" \
                                                                        "deps.d/control.d/machine.d/default/volumes.d/control.d" \
                                                                        "resource.d/control.d"

    running debug setup_add_to_version_control_recursive_links_container_dirs "${LOCALDIRS_DIR}" \
                                                                        "org/resource.d/control.d"

    running debug setup_make_relative_link                                    "${LOCALDIRS_DIR}/org" \
                                                                        "deps.d/control.d/machine.d/default/volumes.d/view.d" \
                                                                        "resource.d/view.d"

    running debug setup_add_to_version_control                                "${LOCALDIRS_DIR}" \
                                                                        "org/resource.d/view.d"
}

# home/portable
function setup_org_home_portable_local_dirs()
{
    local USERDIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user
    local LOCALDIRS_DIR="${USERDIR}/localdirs"
    local relhomeprotabledir="org/home.d/portable.d"

    running debug setup_vc_mkdirpath_ensure "${LOCALDIRS_DIR}" \
                                      "${relhomeprotabledir}" \
                                      "local.d"

    # for folder in Desktop Documents Downloads Library Music Pictures Scratches Templates tmp Videos
    # for folder in Desktop Documents Downloads Library Music Pictures Templates tmp Videos
    for folder in Desktop Downloads Music Pictures Templates tmp Videos Sink
    do
        running debug setup_vc_mkdirpath_ensure    "${LOCALDIRS_DIR}" \
                                             "${relhomeprotabledir}/local.d" \
                                             "${folder}"
        running debug setup_make_relative_link     "${LOCALDIRS_DIR}/org/home.d" \
                                             "local.d/${folder}" \
                                             "portable.d/${folder}/local"
        running debug setup_add_to_version_control "${LOCALDIRS_DIR}" \
                                             "org/home.d/portable.d/${folder}/local"
    done
}

function setup_org_home_portable_public_dirs()
{
    local USERDIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user
    local LOCALDIRS_DIR="${USERDIR}/localdirs"
    local homeprotabledir="${LOCALDIRS_DIR}/org/home.d/portable.d"
    local relhomeprotabledir="org/home.d/portable.d"

    running debug setup_vc_mkdirpath_ensure "${LOCALDIRS_DIR}" "${relhomeprotabledir}" "Public/Publish/html"

    echo 'Options -Indexes' > "${LOCALDIRS_DIR}/${relhomeprotabledir}/Public/Publish/html/.htaccess"
    running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "${relhomeprotabledir}/Public/Publish/html/.htaccess"
    echo '' > "${LOCALDIRS_DIR}/${relhomeprotabledir}/Public/Publish/html/index.html"
    running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "${relhomeprotabledir}/Public/Publish/html/index.html"

    for folder in local
    do
        running debug mkdir -p "${LOCALDIRS_DIR}/org/home.d/portable.d/${folder}.d/Public/Publish/html"
        running debug setup_make_relative_link "${LOCALDIRS_DIR}/org/home.d/portable.d/" "${folder}.d/Public"              "Public/$folder"
        running debug setup_make_relative_link "${LOCALDIRS_DIR}/org/home.d/portable.d/" "${folder}.d/Public/Publish"      "Public/Publish/$folder"
        running debug setup_make_relative_link "${LOCALDIRS_DIR}/org/home.d/portable.d/" "${folder}.d/Public/Publish/html" "Public/Publish/html/$folder"

        running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/Public/$folder"
        running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/Public/Publish/$folder"
        running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/Public/Publish/html/$folder"

        # setup_add_to_version_control
    done

    local linkdirs=(Documents Library)
    local plaindirs=(Downloads Music Pictures Templates tmp Videos Scratches Sink VolRes)

    # for folder in Documents Downloads Library Music Pictures Scratches Templates tmp Videos
    for folder in "${plaindirs[@]}"
    do
        running debug setup_vc_mkdirpath_ensure "${LOCALDIRS_DIR}" "${relhomeprotabledir}" "${folder}/Public/Publish/html" "ignoreall"

        running debug setup_make_relative_link "${homeprotabledir}" "${folder}/Public"              "Public/${folder}"
        running debug setup_make_relative_link "${homeprotabledir}" "${folder}/Public/Publish"      "Public/Publish/${folder}"
        running debug setup_make_relative_link "${homeprotabledir}" "${folder}/Public/Publish/html" "Public/Publish/html/${folder}"


        running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/Public/$folder"
        running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/Public/Publish/$folder"
        running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/Public/Publish/html/$folder"

    done
    for folder in "${linkdirs[@]}"
    do
        # running debug setup_vc_mkdirpath_ensure ${LOCALDIRS_DIR} ${relhomeprotabledir} ${folder}/Public/Publish/html

        running debug setup_make_relative_link "${homeprotabledir}" "${folder}/Public"              "Public/$folder"
        running debug setup_make_relative_link "${homeprotabledir}" "${folder}/Public/Publish"      "Public/Publish/$folder"
        running debug setup_make_relative_link "${homeprotabledir}" "${folder}/Public/Publish/html" "Public/Publish/html/$folder"


        running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/Public/$folder"
        running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/Public/Publish/$folder"
        running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/Public/Publish/html/$folder"
    done

    echo '*' > "${LOCALDIRS_DIR}/${relhomeprotabledir}/tmp/.gitignore"
    running debug setup_add_to_version_control ${HOME}/.fa/localdirs "${relhomeprotabledir}/tmp/.gitignore"

    # private
    # Music Videos Pictures
    collection=private
    for folder in Music Videos Pictures
    do
        running debug setup_make_relative_link     "${RESOURCEPATH}"  "data/multimedia/orgs/$collection/media/collection/$folder" "${USERORGMAIN}/readwrite/public/user/localdirs/org/home.d/portable.d/$folder/$collection"
        running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/$folder/$collection"
    done

}

function setup_org_home_portable_dirs()
{
    local USERDIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user
    local LOCALDIRS_DIR="${USERDIR}/localdirs"
    local rel_homeprotabledir="org/home.d/portable.d"

    running debug setup_vc_mkdirpath_ensure    "${LOCALDIRS_DIR}"            ""                   "${rel_homeprotabledir}"
    running debug setup_make_relative_link     "${LOCALDIRS_DIR}/org/home.d" "portable.d"         "default"
    running debug setup_add_to_version_control "${LOCALDIRS_DIR}"            "org/home.d/default"

    cat <<'EOF' > "${LOCALDIRS_DIR}/org/home.d/portable.d/README"
portable.d is for required dir trees while

local.d is to rearrange according to space needs
EOF

    running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/README"


    echo 'add in script' > "${LOCALDIRS_DIR}/org/home.d/portable.d/TODO"
    running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "org/home.d/portable.d/TODO"

    running debug setup_make_relative_link "${USERDIR}" "doc" "localdirs/${rel_homeprotabledir}/Documents"

    running debug setup_make_relative_link ${HOME}/"${RESOURCEPATH}/${USERORGMAIN}/readwrite/" "private/user/noenc/Private" "public/user/localdirs/${rel_homeprotabledir}/Private"

    running debug setup_make_relative_link "${LOCALDIRS_DIR}/${rel_homeprotabledir}"     "Public/Publish/html" "public_html"
    running debug setup_make_relative_link "${LOCALDIRS_DIR}/${rel_homeprotabledir}"     "Documents/Library"   "Library"

    running debug setup_recursive_links    "${LOCALDIRS_DIR}/org"                        "resource.d/control.d/class/data/storage/local/container/scratches.d" "home.d/portable.d/Scratches"
    running debug setup_recursive_links    "${LOCALDIRS_DIR}/org"                        "resource.d/model.d"                                                  "home.d/portable.d/Volumes"
    running debug setup_make_relative_link "${LOCALDIRS_DIR}/org"                        "resource.d/model.d"                                                  "home.d/portable.d/VolRes/model"
    running debug setup_make_relative_link "${LOCALDIRS_DIR}/org"                        "resource.d/control.d"                                                "home.d/portable.d/VolRes/control"
    running debug setup_make_relative_link "${LOCALDIRS_DIR}/org"                        "resource.d/view.d"                                                   "home.d/portable.d/VolRes/view"
    running debug setup_make_relative_link "${LOCALDIRS_DIR}/org"                        "resource.d/view.d/maildata/mail-and-metadata/maildir"                "home.d/portable.d/Maildir"

    # links
    for lnk in org/home.d/portable.d/{Documents,Private,Library,public_html,Maildir}
    do
        running debug setup_add_to_version_control ${HOME}/.fa/localdirs "$lnk"
    done

    running debug setup_org_home_portable_public_dirs
    running debug setup_org_home_portable_local_dirs
} # function setup_org_home_portable_dirs()

# org/misc
function setup_org_misc_dirs()
{
    local USERDIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user
    local LOCALDIRS_DIR="${USERDIR}/localdirs"
    # TODO?
    # org/misc.d% ls -1l
    # total 4.0K
    # lrwxrwxrwx 1 s s 72 Dec  4 03:37 offlineimap -> ../../resource.d/view.d/maildata/mail-and-metadata/offlineimap
    :

    running debug setup_vc_mkdirpath_ensure "${LOCALDIRS_DIR}" "org" "misc.d"

    running debug setup_make_relative_link  "${LOCALDIRS_DIR}/org" "resource.d/view.d/maildata/mail-and-metadata/offlineimap" "misc.d/offlineimap"
    running debug setup_make_relative_link  "${LOCALDIRS_DIR}/org" "resource.d/view.d/preserved/mailattachments"              "misc.d/mailattachments"

    # links
    for lnk in org/misc.d/{offlineimap,mailattachments}
    do
        running debug setup_add_to_version_control ${HOME}/.fa/localdirs "$lnk"
    done

} # function setup_org_misc_dirs()

# org/rc
function setup_org_rc_dirs()
{
    local USERDIR="${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user"
    local LOCALDIRS_DIR="${USERDIR}/localdirs"

    running debug setup_vc_mkdirpath_ensure "${LOCALDIRS_DIR}" "org/rc.d"

    running debug setup_make_relative_link "${LOCALDIRS_DIR}/org" "deps.d/view.d/home" "rc.d/HOME"

    # sharad ?? fixed
    running debug setup_make_relative_link ${HOME}/.repos "" "git/main/resource/${USERORGMAIN}/readwrite/public/user/localdirs/org/rc.d/repos"


    running debug setup_make_relative_link "${LOCALDIRS_DIR}/org/rc.d" "repos/git/main/resource/userorg/main/readwrite/public/user/opt"       "opt"
    running debug setup_make_relative_link "${LOCALDIRS_DIR}/org/rc.d" "repos/git/main/resource/userorg/main/readwrite/public/user/localdirs" "localdirs"
    running debug setup_make_relative_link "${LOCALDIRS_DIR}/org/rc.d" "repos/git/main/resource/userorg/main/readwrite/public/user/osetup"    "osetup"
    running debug setup_make_relative_link "${LOCALDIRS_DIR}/org/rc.d" "repos/git/main/resource/userorg/main/readwrite/public/user/rc"        "setup"

    for lnk in org/rc.d/{repos,opt,localdirs,osetup,setup,HOME}
    do
        running debug setup_add_to_version_control ${HOME}/.fa/localdirs "$lnk"
    done
} # function setup_org_rc_dirs()

# org
function setup_org_dirs()
{
    running debug setup_org_resource_dirs
    running debug setup_org_home_portable_local_dirs
    running debug setup_org_home_portable_dirs
    running debug setup_org_misc_dirs
    running debug setup_org_rc_dirs
}                               # function setup_org_dirs()


# manual
function setup_manual_dirs()
{
    local USERDIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user
    local LOCALDIRS_DIR="${USERDIR}/localdirs"

    running debug setup_vc_mkdirpath_ensure "${LOCALDIRS_DIR}" "manual.d"

    # debug SHARAD TEST
    running debug setup_make_relative_link "${LOCALDIRS_DIR}" "org/deps.d/control.d/machine.d/default/volumes.d/model.d"   "manual.d/model"
    running debug setup_make_relative_link "${LOCALDIRS_DIR}" "org/deps.d/control.d/machine.d/default/volumes.d/control.d" "manual.d/control"
    running debug setup_make_relative_link "${LOCALDIRS_DIR}" "org/deps.d/control.d/machine.d/default/volumes.d/view.d"    "manual.d/view"

    running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "manual.d/model"
    running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "manual.d/control"
    running debug setup_add_to_version_control "${LOCALDIRS_DIR}" "manual.d/view"

}


# osetup

function setup_osetup_org_resource_dirs()
{
    local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs

    # TODO: add support for git add
    running debug setup_recursive_links ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user "localdirs/org/resource.d" "osetup/dirs.d/org/resource.d"
    running debug setup_add_to_version_control_recursive_links ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user "localdirs/org/resource.d" "osetup" "dirs.d/org/resource.d"
}

function setup_osetup_org_home_dirs()
{
    local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs

    for folder_link in "Desktop" "Documents" "Downloads" "Library" "Maildir" "Music" "Pictures" "Private" "Public" "public_html" "Scratches" "Sink" "Templates" "tmp" "Videos" "Volumes" "VolRes"
    do
        running debug setup_make_relative_link ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user "localdirs/org/home.d/portable.d/${folder_link}" "osetup/dirs.d/org/home.d/${folder_link}"
        running debug setup_add_to_version_control ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/osetup "dirs.d/org/home.d/${folder_link}"
    done
}

function setup_osetup_org_misc_dirs()
{
    local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs

    for folder_link in "offlineimap" "mailattachments"
    do
        running debug setup_make_relative_link ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user "localdirs/org/misc.d/${folder_link}" "osetup/dirs.d/org/misc.d/${folder_link}"
        running debug setup_add_to_version_control ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/osetup "dirs.d/org/misc.d/${folder_link}"
    done
}

function setup_osetup_org_rc_dirs()
{
    local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs
    # local osetupdir=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/osetup/dirs.d/
    # local resourcedir=${LOCALDIRS_DIR}/org/resource.d

    for folder_link in "HOME" "localdirs" "opt" "osetup" "repos" "setup"
    do
        running debug setup_make_relative_link ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user "localdirs/org/rc.d/${folder_link}" "osetup/dirs.d/org/rc.d/${folder_link}"
        running debug setup_add_to_version_control ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/osetup "dirs.d/org/rc.d/${folder_link}"
    done
}

function setup_osetup_org_dirs()
{
    running debug setup_osetup_org_resource_dirs
    running debug setup_osetup_org_home_dirs
    running debug setup_osetup_org_misc_dirs
    running debug setup_osetup_org_rc_dirs
}

function setup_osetup_cache_dirs()
{
    # ls -l /home/s/hell/.repos/git/main/resource/userorg/main/readwrite/public/user/osetup/dirs.d/control.d/cache.d/
    # mkdir -p /home/s/hell/.repos/git/main/resource/userorg/main/readwrite/public/user/osetup/dirs.d/model.d/volume.d/*/cache.d
    :
}

function setup_osetup_dirs()
{
    running debug setup_osetup_org_dirs
    running debug setup_osetup_cache_dirs
}

function setup_rc_org_home_dirs()
{
    local public_path=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public
    local rcdir_rel_path="user/rc"
    local rcdirpath=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/rc
    local rcorghomedir_rel_path=".config/dirs.d/org/home.d"

    running debug setup_make_relative_link "${public_path}/${rcdir_rel_path}" "_bin" "${rcorghomedir_rel_path}/bin"
    running debug setup_add_to_version_control "${rcdirpath}" "${rcorghomedir_rel_path}/bin"
    running debug setup_make_relative_link "${public_path}" "system/system/config/bin" "user/rc/${rcorghomedir_rel_path}/sbin"
    running debug setup_add_to_version_control "${rcdirpath}" "${rcorghomedir_rel_path}/sbin"
}

function setup_rc_org_dirs()
{
    local LOCALDIRS_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/localdirs
    local osetupdir=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user/osetup/dirs.d/
    local resourcedir="${LOCALDIRS_DIR}/org/resource.d"

    # TODO: add support for git add
    running debug setup_recursive_links ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user "osetup/dirs.d/org" "rc/.config/dirs.d/org"
    running debug setup_add_to_version_control_recursive_links ${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/user "osetup/dirs.d/org" "rc" ".config/dirs.d/org"

    running debug setup_rc_org_home_dirs

    running debug setup_add_to_version_control ${HOME}/.fa/rc ".config/dirs.d/org"
}

function setup_dirs()
{

    running debug setup_machine_dir

    if true
    then
        # TODO
        # do it for all basename /srv/volumes/*
        # below /srv/volumes/ for all mounted paths


        # ~% df --output=target | grep  '^/srv/volumes'
        # /srv/volumes/local/vg01/lv01
        # /srv/volumes/local/vgres01/lvres01

        for mntpnt in $(df --output=target | grep  '^/srv/volumes/' | cut -d/ -f4- | rev | cut -d/ -f3-  | rev | sort -u)
        do
            running debug setup_deps_dirs "$mntpnt"
        done

        # running debug setup_deps_dirs "local"

        # running debug setup_deps_dirs "externdisk/mywd5hgb"
        # running debug setup_deps_dirs "network/office"
        # running debug setup_deps_dirs "network/cloud/droplet"
        # running debug setup_deps_dirs "network/cloud/s3"



        running debug setup_org_dirs
        running debug setup_manual_dirs

        running debug setup_osetup_dirs

        running debug setup_rc_org_dirs

        running debug setup_Documentation
        running debug setup_public_html
        running debug setup_mail_and_metadata
    fi
}

function setup_dirs_safely()
{
    running debug sudo systemctl stop  postfix.service
    running debug sudo systemctl stop  postfix.service

    running debug setup_dirs

    if [ -e ${HOME}/.maildir -a -L ${HOME}/.maildir -a -d ${HOME}/.maildir ] &&
           [ -e ${HOME}/.maildir/dovecot.index -a -e ${HOME}/.maildir/dovecot.index.cache -a -e ${HOME}/.maildir/dovecot-uidlist -a -e ${HOME}/.maildir/dovecot-uidvalidity ]
    then
        running debug sudo systemctl start  postfix.service
        running debug sudo systemctl start  postfix.service
    else
        warn Can not start postfix and dovecot
    fi
}

function setup_spacemacs()
{
    login_env_dir=${HOME}/.rsetup/login/env.d
    mkdir -p $login_env_dir
    if [ -f $login_env_dir/$HOST ]
    then
        if ! grep spacemacs $login_env_dir/$HOST
        then
            cat <<'EOF' >> $login_env_dir/$HOST
# EMACS_DIST_DIR=.xemacs
EMACS_DIST_DIR=.emacs.d
export EMACS_DIST_DIR

# EMACS_SERVER_NAME=general
EMACS_SERVER_NAME=spacemacs
export EMACS_SERVER_NAME
EOF
        fi
    fi
}

function setup_sourcecode_pro_font()
{
    # http://programster.blogspot.in/2014/09/ubuntu-install-source-code-pro.html
    local FONT_NAME="SourceCodePro"
    local URL="https://github.com/adobe-fonts/source-code-pro/archive/1.017R.tar.gz"

    if [ ! -d /usr/share/fonts/truetype/$FONT_NAME/ ]
    then
        running debug mkdir /tmp/$FONT_NAME
        cd /tmp/$FONT_NAME
        running debug wget $URL -O "`print $FONT_NAME`.tar.gz"
        running debug tar --extract --gzip --file ${FONT_NAME}.tar.gz
        running debug sudo mkdir /usr/share/fonts/truetype/$FONT_NAME
        running debug sudo cp -rf /tmp/$FONT_NAME/. /usr/share/fonts/truetype/$FONT_NAME/.
        running debug fc-cache -f -v
    fi

    if [ -d "/run/current-system/profile" ]
    then
        for fdir in ~/.guix-profile/share/fonts/**/fonts.dir ~/.setup/guix-config/per-user/s/heavy/profiles.d/heavy/share/fonts/**/fonts.dir
        do
            fontdir=$fdir
            ls $fontdir
            xset +fp $(dirname $(readlink -f $fontdir))
        done
        fc-cache -f
    fi

}

function setup_apache_usermod()
{
    local SYSTEM_DIR=${HOME}/${RESOURCEPATH}/${USERORGMAIN}/readwrite/public/system/system

    running debug sudo a2enmod userdir

    if [ -r /etc/apache2/apache2.conf ]
    then
        if [ ! -d /usr/local/etc/apache ]
        then
            running debug mkdir -p /usr/local/etc/
            running debug cp -r ${SYSTEM_DIR}/ubuntu/usr/local/etc/apache /usr/local/etc/apache
        fi

        if ! grep /usr/local/etc/apache /etc/apache2/apache2.conf
        then
            running debug cp /etc/apache2/apache2.conf $TMP/apache2.conf
            cat <<EOF >> $TMP/apache2.conf

# Include the virtual host configurations:
Include /usr/local/etc/apache/sites-enabled/*.conf

# Include generic snippets of statements
Include /usr/local/etc/apache/conf-enabled/*.conf

EOF
            sudo cp $TMP/apache2.conf /etc/apache2/apache2.conf
        fi                      # if ! grep /usr/local/etc/apache /etc/apache2/apache2.conf
    fi                          # if [ -r /etc/apache2/apache2.conf ]
}

function setup_clib_installer()
{
    running debug sudo ${INSTALLER} ${INSTALLER_OPT} install libcurl4-gnutls-dev -qq
    if [ ! -d /usr/local/stow/clib/ ]
    then
        if running debug git -c core.sshCommand="$GIT_SSH_OPTION" clone https://github.com/clibs/clib.git $SETUP_TMPDIR/clib
        then
            cd $SETUP_TMPDIR/clib
            running debug make PREFIX=/usr/local/stow/clib/
            running debug sudo make PREFIX=/usr/local/stow/clib/ install
            cd /usr/local/stow && sudo stow clib
            cd - > /dev/null 2>&1
            running debug rm -rf $SETUP_TMPDIR/clib
        fi
    else
        verbose clib is already present. >&2
    fi
}

function install_clib_pkg()
{
    local pkgfull="$1"
    local pkg="$(basename $pkgfull)"
    if [ ! -d /usr/local/stow/$pkg ]
    then
        running debug sudo sh -c "PREFIX=/usr/local/stow/$pkg clib install $pkgfull -o /usr/local/stow/$pkg"
        cd /usr/local/stow && sudo stow $pkg
        cd - > /dev/null 2>&1
    else
        verbose $pkgfull is already present. >&2
    fi
}

function setup_clib_pkgs()
{
    :
}

function setup_bpkg_installler()
{
    running debug install_clib_pkg bpkg/bpkg
}

function install_bpkg_pkg()
{
    local pkgfull="$1"
    local pkg="$(basename $pkgfull)"
    if [ ! -d /usr/local/stow/$pkg ]
    then
        running debug sudo mkdir -p "/usr/local/stow/$pkg/bin"
        running debug sudo sh -c "PREFIX=/usr/local/stow/$pkg bpkg install -g $pkgfull"
        cd /usr/local/stow/ && sudo stow $pkg
        cd - > /dev/null 2>&1
    else
        verbose $pkgfull is already present. >&2
    fi
}

function setup_bpkg_pkgs()
{
    running debug install_bpkg_pkg sharad/gitwatch
}

function setup_fzf()
{
    if [ ! -d ${HOME}/.setup/fzf ]
    then
        running debug git clone --depth 1 https://github.com/junegunn/fzf.git ${HOME}/.setup/fzf
        running debug ${HOME}/.setup/fzf/install
    fi
}

function set_window_share()
{
    # //WIN7-SPRATAP/Users/spratap/Desktop/Desktop/Docs  /media/winshare cifs credentials=/media/.credentials,uid=nobody,iocharset=utf8,noperm 0 0
    :
}

function process_arg()
{
    warn=1
    error=1

    if ! set -- $(getopt -n $pgm -o "rnsehvdw" -- $@)
    then
        verbose Wrong command line.
    fi

    while [ $# -gt 0 ]
    do
        echo option $1
        case $1 in
            (-r) recursive=1;;
            (-s) stash=1;;
            (-n) noaction="";;
            (-d) debug=1;;
            (-v) verbose=1;;
            (-w) warn="";;
            (-e) error="";;
            (-h) help;
                 exit;;
            (--) shift; break;;
            (-*) error "$0: error - unrecognized option $1" 1>&2; help; exit 1;;
            (*)  break;;
        esac
        shift
    done
}

function running()
{
    local  notifier=$1
    local _cmd=$2
    shift
    shift


    $notifier $_cmd "$@"
    if [ ! $noaction ]
    then
        $_cmd "$@"
    fi
}

function print()
{
    echo "$*"
}

function error()
{
    notify "Error $*"  >&2
    logger "Error $*"
}

function warn()
{
    if [ $warn ] ; then
        notify "Warning: $*" >&2
    fi
    logger "Warning: $*"
}

function debug()
{
    if [ $debug ] ; then
        notify "Debug: $*" >&2
    fi
    logger "Debug: $*"
}

function verbose()
{
    if [ $verbose ] ; then
        notify "Info: $*" >&2
    fi
    logger "Info: $*"
}

function info()
{
    notify "$*" >&2
    : logger "$*"
}

function notify()
{
    print "${pgm}:" "$*"

    if [ ! -t 1 ]
    then
        notify-send "${pgm}:" "$*"
    fi
}

function logger()
{
    #creating prolem
    command logger -p local1.notice -t ${pgm} -i - $USER : "$*"
}



#verbose=1

pgm="$(basename $0)"
main "$@"
exit
