#!/bin/bash

set -e

skip_a=${1:-00}
skip_b=$2
skip_p=

if [ -n "$skip_b" ]
then
  skip_p="schema\/$skip_a-[a-z0-9-]\+\/$skip_b-"
else
  skip_p="schema\/$skip_a-"
fi

for f in $(find ./schema -name '*.sql' | sort | sed -ne "/${skip_p}/",\$p)
do
  ./psql.sh -f "$f"
done
