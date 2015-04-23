#!/bin/bash

VERSION=0.1
ROOT=$(pwd)

create1() {
    PROP=$1
    FILE=$2
    DEST=$3
    COMMENT="$4"
    shift; shift; shift; shift
    for I in $*; do
        RES=$ROOT/benchmarks/${DEST}_$I.smt2
        WHY=$ROOT/benchmarks-why3/${DEST}_$I.mlw
        CVC4=$ROOT/benchmarks-cvc4/${DEST}_$I.smt2
        TMP=/tmp/$I-tmp
        ERR0=/tmp/$I-out0
        ERR1=/tmp/$I-out1
        ERR2=/tmp/$I-out2
        echo tip-ghc $FILE $PROP$I
        (echo "; $COMMENT"; tip-ghc $FILE $PROP$I) > $RES

        tip-parser $RES cvc4 >$CVC4 2>$ERR0
        ST0=$?
        (echo "; $COMMENT"; cat $CVC4) > $TMP
        cat $TMP > $CVC4

        tip-parser $RES why3 >$WHY 2>$ERR1
        ST1=$?
        (echo "(* $COMMENT *)"; cat $WHY) > $TMP
        cat $TMP > $WHY

        why3 prove $WHY >/dev/null 2>$ERR2
        ST2=$?

        echo "$RES: ($ST0, $ST1, $ST2)"
        [ $ST0 -eq 0 ] || cat $ERR0
        [ $ST1 -eq 0 ] || cat $ERR1
        [ $ST2 -eq 0 ] || cat $ERR2
    done
}

create() {
    PROP=$1
    KIND=$2
    FILE=$3
    DEST=$KIND/$4
    COMMENT=$5

    mkdir -p $ROOT/benchmarks/$KIND
    mkdir -p $ROOT/benchmarks-why3/$KIND
    mkdir -p $ROOT/benchmarks-cvc4/$KIND

    (
    cd original/$KIND
    PROPS=$(grep "^$PROP[^ ]* [^:]" $FILE|sed "s/^$PROP\([^ ]*\) .*/\\1/")
    create1 $PROP $FILE $DEST "$COMMENT" $PROPS
    )
}

create prop_  tip2015    ModRotate.hs             rotate  "Property about rotate and mod"
create prop_  tip2015    StructuralModRotate.hs   rotate  "Property about rotate and mod, written structurally recursive"
create prop_  tip2015    SnocRotate.hs            rotate  "Rotate expressed using a snoc instead of append"
create prop_  tip2015    Rotate.hs                rotate  "Another (simple) property about rotate"

create prop_  tip2015    Escape.hs        escape    "Escaping and unescaping"
create prop_  tip2015    Sort_TreeSort.hs tree_sort "Tree sort"
create prop_  tip2015    Sort_HeapSort.hs heap      "Skew heaps"

create prop_  tip2015    Integers.hs      int           "Integers implemented using natural numbers (from Agda standard library)"
create prop_  tip2015    BinLists.hs      bin           "Binary natural numbers"
create prop_  tip2015    Nichomachus.hs   nicomachus    "Nicomachus's theorem"
create prop_  tip2015    RegExp.hs        regexp        "Regular expressions"
create prop_  tip2015    ListMonad.hs     list          "List monad laws"
create prop_  tip2015    RelaxedPrefix.hs relaxedprefix "Relaxed prefix from VerifyThis: etaps2015.verifythis.org"

create prop_T prod       Properties.hs    prop "Source: Productive use of failure"
create prop_  isaplanner Properties.hs    prop "Source: IsaPlanner test suite"

create prop_  grammars   SimpleExpr1.hs   simp_expr  "Simple expression unambiguity"
create prop_  grammars   SimpleExpr2.hs   simp_expr  "Simple expression unambiguity"
create prop_  grammars   SimpleExpr3.hs   simp_expr  "Simple expression unambiguity"
create prop_  grammars   SimpleExpr4.hs   simp_expr  "Simple expression unambiguity"
create prop_  grammars   SimpleExpr5.hs   simp_expr  "Simple expression unambiguity"
create prop_  grammars   Packrat.hs       packrat    "An example from Packrat Parsing (ICFP 2002)"

tar vczf tip-benchmarks-${VERSION}.tar.gz benchmarks/**/*.smt2
tar vczf tip-benchmarks-${VERSION}-why3.tar.gz benchmarks-why3/**/*.mlw
tar vczf tip-benchmarks-${VERSION}-cvc4.tar.gz benchmarks-cvc4/**/*.smt2

