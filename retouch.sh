#!/bin/bash -ue

function mtime()
{
  eval $(stat -s $file)
  echo $(date -r $st_atime "+%Y%m%d%H%M.%S") $(date -r $st_mtime "+%Y%m%d%H%M.%S")
}

#where am i?
DIR=$(cd $(dirname $BASH_SOURCE);pwd)

#loop over all files under current dir
find $DIR -type f -print0 | while read -d $'\0' file
do
  #stat -s <file> spits out a string ready to be eval'ed, something like:
  #st_dev=16777220 st_ino=80201143 st_mode=0100644 st_nlink=1 st_uid=503 st_gid=20 st_rdev=0 st_size=260 st_atime=1489856881 st_mtime=1489856881 st_ctime=1489856881 st_birthtime=1489856628 st_blksize=4096 st_blocks=8 st_flags=0
  CURR_TIME=($(mtime "$file")) || exit $?
  touch $file || exit $?
  touch -a -t ${CURR_TIME[0]} $file || exit $?
  touch -m -t ${CURR_TIME[1]} $file || exit $?
done
