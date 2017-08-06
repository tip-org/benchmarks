; Relaxed prefix in VerifyThis 2015: etaps2015.verifythis.org
; Challenge 1, submitted by Thomas Genet
;
; A way to specify the relaxed prefix function
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((It :source RelaxedPrefix.It (A :source RelaxedPrefix.A)
     (B :source RelaxedPrefix.B) (C :source RelaxedPrefix.C))))
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
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(prove
  :source RelaxedPrefix.prop_is_prefix_3
  (forall ((x It) (xs (list It)) (ys (list It)))
    (isRelaxedPrefix (++ xs (cons x (as nil (list It)))) (++ xs ys))))
