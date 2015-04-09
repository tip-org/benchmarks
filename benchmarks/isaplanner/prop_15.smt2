; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((lt
      ((x5 Nat) (x6 Nat)) bool
      (match x6
        (case Z false)
        (case
          (S ipv)
          (match x5
            (case Z true)
            (case (S x7) (lt x7 ipv))))))))
(define-funs-rec
  ((par
     (a2)
     (len
        ((x (list a2))) Nat
        (match x
          (case nil Z)
          (case (cons ds xs) (S (as (len xs) Nat))))))))
(define-funs-rec
  ((ins
      ((x2 Nat) (x3 (list Nat))) (list Nat)
      (match x3
        (case nil (cons x2 x3))
        (case
          (cons x4 xs2)
          (ite (lt x2 x4) (cons x2 x3) (cons x4 (ins x2 xs2))))))))
(assert
  (not
    (forall
      ((x8 Nat) (xs3 (list Nat))) (= (len (ins x8 xs3)) (S (len xs3))))))
(check-sat)
