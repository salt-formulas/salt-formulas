#!/bin/bash

# Prints commands to create user .yml with linux/openssh pillar
# $1 - csv file with full name; email; id; ssh pub key

awk -F';' '\
  { fname=$1;gsub(/\s+/,_,$1); sname=tolower(substr($1,1,1)substr($1,index(fname," "))); split($4, key ," "); }
  { print "FNAME=\\\""fname"\\\"", "SNAME=\\\""sname"\\\"", "KEY=\\\""key[1]" "key[2]"\\\"","EMAIL="$2" envsubst < team.template > "tolower($1)".yml" }'\
  < $1 | xargs -n11 echo
