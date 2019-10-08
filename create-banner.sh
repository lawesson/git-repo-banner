#!/bin/bash

HOST=$1
NAME=$2
VERSION=$3
export TZ=${4:-Europe/Stockholm}

BLUE="\e[34m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

cd /code || exit 1

truncate() {
  echo "$1" | cut "-c1-$2"
}

HOST=$(truncate "${HOST}" 10)
SHORT_STAT=$(git diff --shortstat)
HEADINGS="Build date ($(date +'%Z'));Host;Branch;Git hash"

BRANCH=$(truncate "$(git rev-parse --abbrev-ref HEAD)" 25)

if [[ "${SHORT_STAT}" != "" ]]; then
  SHORT_STAT=";$(echo "${SHORT_STAT}" | cut -c2-)"
  HEADINGS="${HEADINGS};Local changes"
  LINE_COLOR="${RED}"
else
  LINE_COLOR="${YELLOW}"
fi

cat << EOS >/banner-data
${HEADINGS}
$(date +'%Y-%m-%d %H:%M:%S');${HOST};${BRANCH};$(git rev-parse HEAD)${SHORT_STAT}
EOS

table() {
  column -o " | " -ts \; /banner-data
}

FIGLET_TEXT="${NAME} v${VERSION}"

banner_width() {
  WIDTH=$(table|tail -1|wc -c)
  WIDTH=$((WIDTH-1))
  while [[ $(figlet -w ${WIDTH} "${FIGLET_TEXT}" | wc -l) -gt 6 ]]; do
    WIDTH=$((WIDTH+1))
  done
  echo ${WIDTH}
}


WIDTH=$(banner_width)
LINE=$(seq -s'-' 0 ${WIDTH} | tr -d '[:digit:]')
figlet -w ${WIDTH} -c -s "${FIGLET_TEXT}"
echo -e -n ${BLUE}
echo $LINE
echo -e -n ${RESET}
table | head -1
echo -e -n ${LINE_COLOR}
table | tail -1
echo -e -n ${RESET}
echo -e -n ${BLUE}
echo $LINE
echo -e -n ${RESET}
