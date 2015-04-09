; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((equal
      ((x7 Nat) (x8 Nat)) bool
      (match x7
        (case
          Z
          (match x8
            (case Z true)
            (case (S ipv) false)))
        (case
          (S ds)
          (match x8
            (case Z false)
            (case (S y) (equal ds y))))))))
(define-funs-rec
  ((elem
      ((x4 Nat) (x5 (list Nat))) bool
      (match x5
        (case nil false)
        (case
          (cons x6 xs2) (ite (equal x4 x6) (equal x4 x6) (elem x4 xs2)))))))
(define-funs-rec
  ((union
      ((x (list Nat)) (x2 (list Nat))) (list Nat)
      (match x
        (case nil x2)
        (case
          (cons x3 xs)
          (ite (elem x3 x2) (union xs x2) (cons x3 (union xs x2))))))))
(assert
  (not
    (forall
      ((x9 Nat) (y2 (list Nat)) (z (list Nat)))
      (=> (elem x9 y2) (elem x9 (union z y2))))))
(check-sat)
