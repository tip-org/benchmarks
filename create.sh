#!/bin/bash

create1() {
    PROP=$1
    FILE=$2
    DEST=$3
    COMMENT="$4"
    shift; shift; shift; shift
    for I in $*; do
        RES=${DEST}_$I.mlw
        ERR=/tmp/$I-out
        (echo "(* $COMMENT *)"; hipspec --only=$PROP$I --print-why3 --translate-only $FILE) > $RES
        why3 prove $RES >/dev/null 2>$ERR
        ST=$?
        echo "$RES: ($ST)"
        [ $ST -eq 0 ] || cat $ERR
    done
}

create() {
    PROP=$1
    KIND=$2
    FILE=$3
    DEST=benchmarks/$KIND/$4
    COMMENT=$5

    mkdir -p benchmarks/$KIND

    (
    cd original/$KIND
    PROPS=$(grep "^$PROP[^ ]* [^:]" $FILE|sed "s/^$PROP\([^ ]*\) .*/\\1/")
    create1 $PROP $FILE ../../$DEST "$COMMENT" $PROPS
    )
}

create prop_T prod       Properties.hs prop "Source: Productive use of failure"
create prop_  isaplanner Properties.hs prop "Source: IsaPlanner test suite"
create prop_  hipspec    Integers.hs   int  "Integers implemented using natural numbers"
create prop_  hipspec    BinLists.hs   bin  "Binary natural numbers"
create prop_  hipspec   Nichomachus.hs   nicomachus "Nicomachus's theorem"
create prop_  hipspec    DifficultRotate.hs   difficult  "Difficult examples about rotate"
create prop_  hipspec    SnocRotate.hs   snoc_rotate  "Rotate expressed using snoc"
create prop_ hipspec RegExp.hs regexp "Regular expressions"
