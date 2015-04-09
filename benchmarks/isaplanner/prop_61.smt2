; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((last ((x3 (list Nat))) Nat))
  ((match x3
     (case nil Z)
     (case
       (cons x4 ds)
       (match ds
         (case nil x4)
         (case (cons ipv3 ipv4) (last ds)))))))
(define-funs-rec
  ((lastOfTwo ((x (list Nat)) (x2 (list Nat))) Nat))
  ((match x2
     (case nil (last x))
     (case (cons ipv ipv2) (last x2)))))
(define-funs-rec
  ((par (a2) (append ((x5 (list a2)) (x6 (list a2))) (list a2))))
  ((match x5
     (case nil x6)
     (case (cons x7 xs) (cons x7 (as (append xs x6) (list a2)))))))
(assert
  (not
    (forall
      ((xs2 (list Nat)) (ys (list Nat)))
      (= (last (append xs2 ys)) (lastOfTwo xs2 ys)))))
(check-sat)
