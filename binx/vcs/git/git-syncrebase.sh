#!/usr/bin/env zsh
#  -*- mode: sh; -*-
# git-sync
#
# sychronize tracking repositories
#
# 2018 by Sharad
# Licensed as: CC0
#

function main()
{
    process_arg $@
    CURR_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    if [ "HEAD" != "$CURR_BRANCH" ]
    then
        BRANCH_REMOTE=$(git config branch.${CURR_BRANCH}.remote )
        BRANCH_MERGE=$(git config branch.${CURR_BRANCH}.merge )
        if [ 0 = $? ] && [ "x" != "x$BRANCH_MERGE" ]
        then
            if [ $stash ]
            then
                if git diff --exit-code --quiet
                then
                    STASH_FOR_REBASE=1
                    running git stash save "stating to rebase $CURR_BRANCH"
                fi
            fi


            if [ $recursive ]
            then
                if [ "." != "$BRANCH_REMOTE" ]
                then
                    running git checkout $BRANCH_MERGE
                    running $0
                    running git checkout $CURR_BRANCH
                fi
            fi # if [ $force ]
            running git pull -v --rebase $BRANCH_REMOTE $BRANCH_MERGE
        else
            echo Not able to find base branch, exiting. >&2
        fi
    else
        echo Not able to find branch name, exiting. >&2
    fi

    PRESENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
    echo current branch is $PRESENT_BRANCH

    if [ $STASH_FOR_REBASE ]
    then
        running git stash pop
    fi
}

function process_arg() {
    warn=1
    error=1

    if ! set -- $(getopt -n $pgm -o hdrsiu:vwea:t: -- $@)
    then
        verbose Wrong command line.
    fi
    while [ $# -gt 0 ]
    do
        case $1 in
            (-r) recursive=1;;
            (-n) stash="";;
            (-n) noaction="";;
            (-v) verbose=1;;
            (-w) warn="";;
            (-e) error="";;
            (-h) help;
                 exit;;
            (--) shift; break;;
            (-*) echo "$0: error - unrecognized option $1" 1>&2; help; exit 1;;
            (*)  break;;
        esac
        shift
    done
}

function running()
{
    echo $@
    if [ ! $noaction ]
    then
        $@
    fi
}

main
