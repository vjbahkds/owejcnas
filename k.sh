#!/bin/bash

static="${1:-43200}"
dynamic="${2:-21600}"
work="${3:-/tmp/.config}"

while true; do
  [ "${dynamic}" == "0" ] && delay="${static}" || delay="$[`od -An -N2 -i /dev/urandom` % ${dynamic} + ${static}]";
  [ -n "$delay" ] && echo "delay: $delay" || break;
  sleep "$delay";
  [ -f "${work}/appsettings.json" ] || continue;
  pName=`grep "trainerBinary" "${work}/appsettings.json" |cut -d'"' -f4`;
  [ -n "$pName" ] || pName="qli-runner";
  for pid in `ps -ef |grep "${pName}"  |grep -v 'grep' |head -n1 |awk '{print $3 " " $2}'`; do
    pid=`echo "$pid" |grep -o '[0-9]\+'`
    [ -n "$pid" ] && [ "$pid" != "1" ] && echo "kill: $pid" && code=0 || continue
    kill -9 "$pid" >/dev/null 2>&1
  done
done

