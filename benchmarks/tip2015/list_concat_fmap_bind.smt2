; List monad laws
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(define-funs-rec
  ((par (a2 b) (fmap ((x (=> a2 b)) (x2 (list a2))) (list b))))
  ((match x2
     (case nil (as nil (list b)))
     (case (cons x3 xs) (cons (@ x x3) (as (fmap x xs) (list b)))))))
(define-funs-rec
  ((par (a4) (append ((x8 (list a4)) (x9 (list a4))) (list a4))))
  ((match x8
     (case nil x9)
     (case (cons x10 xs4) (cons x10 (as (append xs4 x9) (list a4)))))))
(define-funs-rec
  ((par
     (a5 b2) (bind ((x5 (list a5)) (x6 (=> a5 (list b2)))) (list b2))))
  ((match x5
     (case nil (as nil (list b2)))
     (case
       (cons x7 xs3) (append (@ x6 x7) (as (bind xs3 x6) (list b2)))))))
(define-funs-rec
  ((par (a3) (concat2 ((x4 (list (list a3)))) (list a3))))
  ((match x4
     (case nil (as nil (list a3)))
     (case (cons xs2 xss) (append xs2 (as (concat2 xss) (list a3)))))))
(assert-not
  (par
    (a6 b3)
    (forall
      ((f (=> a6 (list b3))) (xs5 (list a6)))
      (= (concat2 (fmap f xs5)) (bind xs5 f)))))
(check-sat)
