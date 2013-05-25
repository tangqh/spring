#!/bin/bash

set -e
. buildbot/slave/prepare.sh $*

#########################
# Config

REMOTE_HOST=springrts.com
REMOTE_USER=buildbot
REMOTE_BASE=/home/buildbot/www
RSYNC="rsync -avz --chmod=D+rx,F+r --bwlimit 4000 --exclude=download/ --exclude=tests/"
REMOTE_RSYNC="nice -19 ionice -c3 rsync" #prevent QQ about rsync killing server


#########################
# Upload

MANPAGES="${BUILDDIR}/manpages/*.html"

umask 022

# Rsync archives to a world-visible location.
if [ ${REMOTE_HOST} = localhost ] && [ -w ${REMOTE_BASE} ]; then
	${RSYNC} ${MANPAGES} ${REMOTE_BASE}/${CONFIG}/${BRANCH}/${REV}/manpages/
else
	${RSYNC} --rsync-path="${REMOTE_RSYNC}" ${MANPAGES} ${REMOTE_USER}@${REMOTE_HOST}:${REMOTE_BASE}/${CONFIG}/${BRANCH}/${REV}/manpages/
fi
