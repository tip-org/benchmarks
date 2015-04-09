; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((equal
      ((x6 Nat) (x7 Nat)) bool
      (match x6
        (case
          Z
          (match x7
            (case Z true)
            (case (S ipv4) false)))
        (case
          (S ds)
          (match x7
            (case Z false)
            (case (S y) (equal ds y))))))))
(define-funs-rec
  ((elem
      ((x Nat) (x2 (list Nat))) bool
      (match x2
        (case nil false)
        (case (cons x3 xs) (ite (equal x x3) (equal x x3) (elem x xs)))))))
(define-funs-rec
  ((par
     (a2)
     (drop
        ((x4 Nat) (x5 (list a2))) (list a2)
        (match x4
          (case Z x5)
          (case
            (S ipv)
            (match x5
              (case nil x5)
              (case (cons ipv2 ipv3) (as (drop ipv ipv3) (list a2))))))))))
(assert
  (not
    (forall
      ((x8 Nat) (y2 Nat) (z (list Nat)))
      (=> (elem x8 (drop y2 z)) (elem x8 z)))))
(check-sat)
