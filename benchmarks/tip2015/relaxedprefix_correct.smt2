; Relaxed prefix in VerifyThis 2015: etaps2015.verifythis.org
; Challenge 1, submitted by Thomas Genet
;
; Relaxed prefix conforms to its specification
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((It :source RelaxedPrefix.It (A :source RelaxedPrefix.A)
     (B :source RelaxedPrefix.B) (C :source RelaxedPrefix.C))))
(define-fun-rec
  removeOne :let
    ((x It) (y (list (list It)))) (list (list It))
    (match y
      (case nil (as nil (list (list It))))
      (case (cons z x2) (cons (cons x z) (removeOne x x2)))))
(define-fun-rec
  removeOne2 :source RelaxedPrefix.removeOne
    ((x (list It))) (list (list It))
    (match x
      (case nil (as nil (list (list It))))
      (case (cons y xs) (cons xs (removeOne y (removeOne2 xs))))))
(define-fun-rec
  or2 :let :source Prelude.or
    ((x (list Bool))) Bool
    (match x
      (case nil false)
      (case (cons y xs) (or y (or2 xs)))))
(define-fun-rec
  isPrefix :source RelaxedPrefix.isPrefix
    ((x (list It)) (y (list It))) Bool
    (match x
      (case nil true)
      (case (cons z x2)
        (match y
          (case nil false)
          (case (cons x3 x4) (and (= z x3) (isPrefix x2 x4)))))))
(define-fun-rec
  isRelaxedPrefix :source RelaxedPrefix.isRelaxedPrefix
    ((x (list It)) (y (list It))) Bool
    (match x
      (case nil true)
      (case (cons z x2)
        (match x2
          (case nil true)
          (case (cons x3 x4)
            (match y
              (case nil false)
              (case (cons x5 x6)
                (ite (= z x5) (isRelaxedPrefix x2 x6) (isPrefix x2 y)))))))))
(define-fun-rec
  spec :let
    ((ys (list It)) (x (list (list It)))) (list Bool)
    (match x
      (case nil (as nil (list Bool)))
      (case (cons y z) (cons (isPrefix y ys) (spec ys z)))))
(define-fun
  spec2 :source RelaxedPrefix.spec
    ((x (list It)) (y (list It))) Bool
    (or2 (spec y (cons x (removeOne2 x)))))
(prove
  :source RelaxedPrefix.prop_correct
  (forall ((xs (list It)) (ys (list It)))
    (= (isRelaxedPrefix xs ys) (spec2 xs ys))))
