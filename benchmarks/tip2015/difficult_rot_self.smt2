; Difficult examples about rotate
(declare-datatypes () ((Nat (S (p Nat)) (Z))))
(declare-datatypes
  (a) ((List2 (Cons (Cons_ a) (Cons_2 (List2 a))) (Nil))))
(define-funs-rec
  ((par
     (a3)
     (append
        ((x3 (List2 a3)) (x4 (List2 a3))) (List2 a3)
        (match x3
          (case (Cons x5 xs) (Cons x5 (as (append xs x4) (List2 a3))))
          (case Nil x4))))))
(define-funs-rec
  ((par
     (a2)
     (rotate
        ((x Nat) (x2 (List2 a2))) (List2 a2)
        (match x
          (case
            (S d)
            (match x2
              (case
                (Cons d2 d3)
                (as (rotate d (append d3 (Cons d2 (as Nil (List2 a2)))))
                  (List2 a2)))
              (case Nil x2)))
          (case Z x2))))))
(declare-sort a4 0)
(assert
  (not
    (forall
      ((n Nat) (xs2 (List2 a4)))
      (=
        (rotate n (append xs2 xs2))
        (append (rotate n xs2) (rotate n xs2))))))
(check-sat)
