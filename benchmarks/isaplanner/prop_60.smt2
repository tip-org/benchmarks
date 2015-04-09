; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par
     (a2)
     (null
        ((x (list a2))) bool
        (match x
          (case nil true)
          (case (cons ipv ipv2) false))))))
(define-funs-rec
  ((last
      ((x2 (list Nat))) Nat
      (match x2
        (case nil Z)
        (case
          (cons x3 ds)
          (match ds
            (case nil x3)
            (case (cons ipv3 ipv4) (last ds))))))))
(define-funs-rec
  ((par
     (a3)
     (append
        ((x4 (list a3)) (x5 (list a3))) (list a3)
        (match x4
          (case nil x5)
          (case (cons x6 xs) (cons x6 (as (append xs x5) (list a3)))))))))
(assert
  (not
    (forall
      ((xs2 (list Nat)) (ys (list Nat)))
      (=> (not (null ys)) (= (last (append xs2 ys)) (last ys))))))
(check-sat)
