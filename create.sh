#!/bin/bash

create() {
    PROP=$1
    NUM=$2
    FILE=$3
    DEST=$4
    for I in $(seq -w 1 $NUM); do
        RES=$DEST$I.mlw
        ERR=/tmp/$I-out
        hipspec --only=$PROP$I --print-why3 --translate-only $FILE > $RES
        why3 prove $RES >/dev/null 2>$ERR
        ST=$?
        echo "$RES: ($ST)"
        [ $ST -eq 0 ] || cat $ERR
    done
}

(
  mkdir -p benchmarks/prod
  cd original/prod
  create prop_T 50 Properties.hs ../../benchmarks/prod/prop
) 
(
  mkdir -p benchmarks/isaplanner
  cd original/isaplanner
  create prop_ 85 Properties.hs ../../benchmarks/isaplanner/prop
)
(
  mkdir -p benchmarks/hipspec
  cd original/hipspec
  create prop_ 18 Integers.hs ../../benchmarks/hipspec/int
)
