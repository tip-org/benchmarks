; Relaxed prefix in VerifyThis 2015: etaps2015.verifythis.org
; Challenge 1, submitted by Thomas Genet
;
; Relaxed prefix conforms to its specification
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((It (A) (B) (C))))
(define-funs-rec
  ((removeOne2 ((x It) (y (list (list It)))) (list (list It))))
  ((match y
     (case nil (as nil (list (list It))))
     (case (cons z x2) (cons (cons x z) (removeOne2 x x2))))))
(define-funs-rec
  ((removeOne ((x (list It))) (list (list It))))
  ((match x
     (case nil (as nil (list (list It))))
     (case (cons y xs) (cons xs (removeOne2 y (removeOne xs)))))))
(define-funs-rec
  ((or2 ((x (list Bool))) Bool))
  ((match x
     (case nil false)
     (case (cons y z) (or y (or2 z))))))
(define-funs-rec
  ((eq ((x It) (y It)) Bool))
  ((match x
     (case A
       (match y
         (case default false)
         (case A true)))
     (case B
       (match y
         (case default false)
         (case B true)))
     (case C
       (match y
         (case default false)
         (case C true))))))
(define-funs-rec
  ((isPrefix ((x (list It)) (y (list It))) Bool))
  ((match x
     (case nil true)
     (case (cons z x2)
       (match y
         (case nil false)
         (case (cons x3 x4) (and (eq z x3) (isPrefix x2 x4))))))))
(define-funs-rec
  ((spec2 ((ys (list It)) (x (list (list It)))) (list Bool)))
  ((match x
     (case nil (as nil (list Bool)))
     (case (cons y z) (cons (isPrefix y ys) (spec2 ys z))))))
(define-funs-rec
  ((spec ((x (list It)) (y (list It))) Bool))
  ((or2 (spec2 y (cons x (removeOne x))))))
(define-funs-rec
  ((isRelaxedPrefix ((x (list It)) (y (list It))) Bool))
  ((match x
     (case nil true)
     (case (cons z x2)
       (match x2
         (case nil true)
         (case (cons x3 x4)
           (match y
             (case nil false)
             (case (cons x5 x6)
               (ite (eq z x5) (isRelaxedPrefix x2 x6) (isPrefix x2 y))))))))))
(assert-not
  (forall ((xs (list It)) (ys (list It)))
    (= (isRelaxedPrefix xs ys) (spec xs ys))))
(check-sat)
