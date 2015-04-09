; Rotate expressed using a snoc instead of append
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a2) (snoc ((x a2) (x2 (list a2))) (list a2))))
  ((match x2
     (case nil (cons x x2))
     (case (cons y ys) (cons y (as (snoc x ys) (list a2)))))))
(define-funs-rec
  ((par (a3) (rotate ((x3 Nat) (x4 (list a3))) (list a3))))
  ((match x3
     (case Z x4)
     (case
       (S d)
       (match x4
         (case nil x4)
         (case (cons d2 d3) (as (rotate d (snoc d2 d3)) (list a3))))))))
(define-funs-rec
  ((par (a4) (append ((x5 (list a4)) (x6 (list a4))) (list a4))))
  ((match x5
     (case nil x6)
     (case (cons x7 xs) (cons x7 (as (append xs x6) (list a4)))))))
(declare-sort a5 0)
(assert
  (not
    (forall
      ((n Nat) (xs2 (list a5)))
      (=
        (rotate n (append xs2 xs2))
        (append (rotate n xs2) (rotate n xs2))))))
(check-sat)
