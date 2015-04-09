; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le
      ((x5 Nat) (x6 Nat)) bool
      (match x5
        (case Z true)
        (case
          (S ipv2)
          (match x6
            (case Z false)
            (case (S ipv3) (le ipv2 ipv3))))))))
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
        ((x7 (list a2)) (x8 (list a2))) (list a2)
        (match x7
          (case nil x8)
          (case (cons x9 xs) (cons x9 (as (append xs x8) (list a2)))))))))
(assert
  (not
    (forall
      ((n Nat) (xs2 (list Nat)) (ys2 (list Nat)))
      (le (count n xs2) (count n (append xs2 ys2))))))
(check-sat)
