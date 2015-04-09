; Another (simple) property about rotate
(declare-datatypes () ((Nat (S (p Nat)) (Z))))
(declare-datatypes
  (a) ((List2 (Cons (Cons_ a) (Cons_2 (List2 a))) (Nil))))
(define-funs-rec
  ((par (a2) (append ((x (List2 a2)) (x2 (List2 a2))) (List2 a2))))
  ((match x
     (case (Cons x3 xs) (Cons x3 (as (append xs x2) (List2 a2))))
     (case Nil x2))))
(define-funs-rec
  ((par (a3) (rotate ((x4 Nat) (x5 (List2 a3))) (List2 a3))))
  ((match x4
     (case
       (S d)
       (match x5
         (case
           (Cons d2 d3)
           (as (rotate d (append d3 (Cons d2 (as Nil (List2 a3)))))
             (List2 a3)))
         (case Nil x5)))
     (case Z x5))))
(assert-not
  (par
    (a4)
    (forall
      ((n Nat) (xs2 (List2 a4)))
      (=
        (rotate n (append xs2 xs2))
        (append (rotate n xs2) (rotate n xs2))))))
(check-sat)
