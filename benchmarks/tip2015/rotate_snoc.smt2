; Rotate expressed using a snoc instead of append
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a3) (snoc ((x2 a3) (x3 (list a3))) (list a3))))
  ((match x3
     (case nil (cons x2 x3))
     (case (cons y ys) (cons y (as (snoc x2 ys) (list a3)))))))
(define-funs-rec
  ((par (a4) (rotate ((x4 Nat) (x5 (list a4))) (list a4))))
  ((match x4
     (case Z x5)
     (case
       (S d)
       (match x5
         (case nil x5)
         (case (cons d2 d3) (as (rotate d (snoc d2 d3)) (list a4))))))))
(define-funs-rec
  ((par (a2) (length ((x (list a2))) Nat)))
  ((match x
     (case nil Z)
     (case (cons ds xs) (S (as (length xs) Nat))))))
(declare-sort a5 0)
(assert
  (not (forall ((xs2 (list a5))) (= (rotate (length xs2) xs2) xs2))))
(check-sat)
