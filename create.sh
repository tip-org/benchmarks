#!/bin/bash

create1() {
    PROP=$1
    FILE=$2
    DEST=$3
    COMMENT="$4"
    shift; shift; shift; shift
    for I in $*; do
        RES=${DEST}_$I.smt2
        WHY=${DEST}_$I.mlw
        ERR1=/tmp/$I-out1
        ERR2=/tmp/$I-out2
        (echo "; $COMMENT"; tip-ghc $FILE $PROP$I) > $RES
        # cat $RES
        tip-parser $RES why3 >$WHY 2>$ERR1
        ST1=$?
        why3 prove $WHY >/dev/null 2>$ERR2
        ST2=$?
        echo "$RES: ($ST1, $ST2)"
        [ $ST1 -eq 0 ] || cat $ERR1
        [ $ST2 -eq 0 ] || cat $ERR2
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

create prop_  tip2015    Escape.hs              escape           "Escaping"
create prop_  tip2015    Sort_TreeSort.hs       tree_sort        "Tree sort"

create prop_T prod       Properties.hs prop "Source: Productive use of failure"
create prop_  isaplanner Properties.hs prop "Source: IsaPlanner test suite"
create prop_  tip2015    Integers.hs   int  "Integers implemented using natural numbers"
create prop_  tip2015    BinLists.hs   bin  "Binary natural numbers"
create prop_  tip2015   Nichomachus.hs   nicomachus "Nicomachus's theorem"
create prop_  tip2015    DifficultRotate.hs   difficult  "Difficult examples about rotate"
create prop_  tip2015    SnocRotate.hs   snoc_rotate  "Rotate expressed using snoc"
create prop_ tip2015 RegExp.hs regexp "Regular expressions"
create prop_  grammars    SimpleExpr1.hs   simp_expr  "Simple expression unambiguity"
create prop_  grammars    SimpleExpr2.hs   simp_expr  "Simple expression unambiguity"
create prop_  grammars    SimpleExpr3.hs   simp_expr  "Simple expression unambiguity"
create prop_  grammars    SimpleExpr4.hs   simp_expr  "Simple expression unambiguity"
create prop_  grammars    SimpleExpr5.hs   simp_expr  "Simple expression unambiguity"
create prop_  grammars    Packrat.hs       packrat  "An example from Packrat Parsing (ICFP 2002)"
create prop_  tip2015    ListMonad.hs       list        "List monad laws"
create prop_  tip2015    Sort_HeapSort.hs       heap        "Skew heaps"
