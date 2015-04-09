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
(define-funs-rec
  ((par
     (a2)
     (append
        ((x5 (list a2)) (x6 (list a2))) (list a2)
        (match x5
          (case nil x6)
          (case (cons x7 xs) (cons x7 (as (append xs x6) (list a2)))))))))
(assert
  (not
    (forall
      ((n Nat) (xs2 (list Nat)))
      (=
        (count n (append xs2 (cons n (as nil (list Nat)))))
        (S (count n xs2))))))
(check-sat)
