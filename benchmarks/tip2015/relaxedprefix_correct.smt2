; Relaxed prefix in VerifyThis 2015: etaps2015.verifythis.org
; Challenge 1, submitted by Thomas Genet
;
; Relaxed prefix conforms to its specification
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((It (A) (B) (C))))
(define-funs-rec
  ((y ((z It) (x2 (list (list It)))) (list (list It))))
  ((match x2
     (case nil x2)
     (case (cons x3 x4) (cons (cons z x3) (y z x4))))))
(define-funs-rec
  ((removeOne ((z (list It))) (list (list It))))
  ((match z
     (case nil (as nil (list (list It))))
     (case (cons x2 xs) (cons xs (y x2 (removeOne xs)))))))
(define-funs-rec
  ((or2 ((z (list bool))) bool))
  ((match z
     (case nil false)
     (case (cons x2 x3) (ite x2 true (or2 x3))))))
(define-funs-rec
  ((eq ((z It) (x2 It)) bool))
  ((match z
     (case A
       (match x2
         (case default false)
         (case A true)))
     (case B
       (match x2
         (case default false)
         (case B true)))
     (case C
       (match x2
         (case default false)
         (case C true))))))
(define-funs-rec
  ((isPrefix ((z (list It)) (x2 (list It))) bool))
  ((match z
     (case nil true)
     (case (cons x3 x4)
       (match x2
         (case nil false)
         (case (cons x5 x6) (ite (eq x3 x5) (isPrefix x4 x6) false)))))))
(define-funs-rec
  ((x ((ys (list It)) (z (list (list It)))) (list bool)))
  ((match z
     (case nil (as nil (list bool)))
     (case (cons x2 x3) (cons (isPrefix x2 ys) (x ys x3))))))
(define-funs-rec
  ((spec ((z (list It)) (x2 (list It))) bool))
  ((or2 (x x2 (cons z (removeOne z))))))
(define-funs-rec
  ((isRelaxedPrefix ((z (list It)) (x2 (list It))) bool))
  ((match z
     (case nil true)
     (case (cons x3 x4)
       (match x4
         (case nil true)
         (case (cons x5 x6)
           (match x2
             (case nil false)
             (case (cons x7 x8)
               (ite (eq x3 x7) (isRelaxedPrefix x4 x8) (isPrefix x4 x2))))))))))
(assert-not
  (forall ((xs (list It)) (ys (list It)))
    (= (isRelaxedPrefix xs ys) (spec xs ys))))
(check-sat)
