#!/bin/bash

VERSION=0.1
ROOT=$(pwd)

make

create1() {
    PROP=$1
    FILE=$2
    DEST=$3
    shift; shift; shift
    for I in $*; do
        RES=$ROOT/benchmarks/${DEST}_$I.smt2
        WHY=$ROOT/benchmarks-why3/${DEST}_$I.mlw
        CVC4=$ROOT/benchmarks-cvc4/${DEST}_$I.smt2
        TMP=/tmp/$I-tmp
        ERR0=/tmp/$I-out0
        ERR1=/tmp/$I-out1
        ERR2=/tmp/$I-out2
        echo tip-ghc $FILE $PROP$I
        ($ROOT/Commentify $FILE $PROP$I "; " "; " ""; tip-ghc $FILE $PROP$I) > $RES

        tip-parser $RES cvc4 >$CVC4 2>$ERR0
        ST0=$?
        ($ROOT/Commentify $FILE $PROP$I "; " "; " ""; cat $CVC4) > $TMP
        cat $TMP > $CVC4

        tip-parser $RES why3 >$WHY 2>$ERR1
        ST1=$?
        ($ROOT/Commentify $FILE $PROP$I "(* " " * " " *)"; cat $WHY) > $TMP
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

    mkdir -p $ROOT/benchmarks/$KIND
    mkdir -p $ROOT/benchmarks-why3/$KIND
    mkdir -p $ROOT/benchmarks-cvc4/$KIND

    (
    cd original/$KIND
    PROPS=$(grep "^$PROP[^ ]* [^:]" $FILE|sed "s/^$PROP\([^ ]*\) .*/\\1/")
    create1 $PROP $FILE $DEST $PROPS
    )
}

create prop_  tip2015    Nat.hs                   nat
create prop_  tip2015    WeirdNat.hs              weird_nat
create prop_  tip2015    Fermat.hs                fermat

create prop_  tip2015    ModRotate.hs             rotate
create prop_  tip2015    StructuralModRotate.hs   rotate
create prop_  tip2015    SnocRotate.hs            rotate
create prop_  tip2015    Rotate.hs                rotate

create prop_  tip2015    Escape.hs        escape
create prop_  tip2015    Sort_TreeSort.hs tree_sort
create prop_  tip2015    Sort_HeapSort.hs heap

create prop_  tip2015    Integers.hs      int
create prop_  tip2015    BinLists.hs      bin
create prop_  tip2015    Nicomachus.hs    nicomachus
create prop_  tip2015    RegExp.hs        regexp
create prop_  tip2015    ListMonad.hs     list
create prop_  tip2015    RelaxedPrefix.hs relaxedprefix
create prop_  tip2015    Seq.hs           polyrec_seq

create prop_T prod       Properties.hs    prop
create prop_  isaplanner Properties.hs    prop

create prop_  grammars   SimpleExpr1.hs   simp_expr
create prop_  grammars   SimpleExpr2.hs   simp_expr
create prop_  grammars   SimpleExpr3.hs   simp_expr
create prop_  grammars   SimpleExpr4.hs   simp_expr
create prop_  grammars   SimpleExpr5.hs   simp_expr
create prop_  grammars   Packrat.hs       packrat

create prop_  koen   List.hs          list
create prop_  koen   McCarthy91.hs    mccarthy91
create prop_  koen   Propositional.hs propositional
create prop_  koen   Sort.hs          sort
create prop_  koen   Subst.hs         subst
create prop_  koen   Tree.hs          tree

tar vczf tip-benchmarks-${VERSION}.tar.gz benchmarks/**/*.smt2
tar vczf tip-benchmarks-${VERSION}-why3.tar.gz benchmarks-why3/**/*.mlw
tar vczf tip-benchmarks-${VERSION}-cvc4.tar.gz benchmarks-cvc4/**/*.smt2


