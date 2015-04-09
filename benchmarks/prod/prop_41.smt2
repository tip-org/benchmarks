; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((equal
      ((x10 Nat) (x11 Nat)) bool
      (match x10
        (case
          Z
          (match x11
            (case Z true)
            (case (S ipv) false)))
        (case
          (S ds)
          (match x11
            (case Z false)
            (case (S y) (equal ds y))))))))
(define-funs-rec
  ((elem
      ((x7 Nat) (x8 (list Nat))) bool
      (match x8
        (case nil false)
        (case
          (cons x9 xs3) (ite (equal x7 x9) (equal x7 x9) (elem x7 xs3)))))))
(define-funs-rec
  ((intersect
      ((x4 (list Nat)) (x5 (list Nat))) (list Nat)
      (match x4
        (case nil x4)
        (case
          (cons x6 xs2)
          (ite
            (elem x6 x5) (cons x6 (intersect xs2 x5)) (intersect xs2 x5)))))))
(define-funs-rec
  ((subset
      ((x (list Nat)) (x2 (list Nat))) bool
      (match x
        (case nil true)
        (case
          (cons x3 xs) (ite (elem x3 x2) (subset xs x2) (elem x3 x2)))))))
(assert
  (not
    (forall
      ((x12 (list Nat)) (y2 (list Nat)))
      (=> (subset x12 y2) (= (intersect x12 y2) x12)))))
(check-sat)
