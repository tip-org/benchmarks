; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((equal
      ((x3 Nat) (x4 Nat)) bool
      (match x3
        (case
          Z
          (match x4
            (case Z true)
            (case (S ipv) false)))
        (case
          (S ds)
          (match x4
            (case Z false)
            (case (S y2) (equal ds y2))))))))
(define-funs-rec
  ((count
      ((x Nat) (x2 (list Nat))) Nat
      (match x2
        (case nil Z)
        (case
          (cons y ys) (ite (equal x y) (S (count x ys)) (count x ys)))))))
(assert
  (not
    (forall
      ((n Nat) (x5 Nat) (xs (list Nat)))
      (=> (= n x5) (= (S (count n xs)) (count n (cons x5 xs)))))))
(check-sat)
