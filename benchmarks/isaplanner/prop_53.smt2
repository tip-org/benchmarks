; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((le ((x10 Nat) (x11 Nat)) bool))
  ((match x10
     (case Z true)
     (case
       (S ipv2)
       (match x11
         (case Z false)
         (case (S ipv3) (le ipv2 ipv3)))))))
(define-funs-rec
  ((insort ((x3 Nat) (x4 (list Nat))) (list Nat)))
  ((match x4
     (case nil (cons x3 x4))
     (case
       (cons x5 xs2)
       (ite (le x3 x5) (cons x3 x4) (cons x5 (insort x3 xs2)))))))
(define-funs-rec
  ((sort ((x (list Nat))) (list Nat)))
  ((match x
     (case nil x)
     (case (cons x2 xs) (insort x2 (sort xs))))))
(define-funs-rec
  ((equal ((x8 Nat) (x9 Nat)) bool))
  ((match x8
     (case
       Z
       (match x9
         (case Z true)
         (case (S ipv) false)))
     (case
       (S ds)
       (match x9
         (case Z false)
         (case (S y2) (equal ds y2)))))))
(define-funs-rec
  ((count ((x6 Nat) (x7 (list Nat))) Nat))
  ((match x7
     (case nil Z)
     (case
       (cons y ys) (ite (equal x6 y) (S (count x6 ys)) (count x6 ys))))))
(assert
  (not
    (forall
      ((n Nat) (xs3 (list Nat)))
      (= (count n xs3) (count n (sort xs3))))))
(check-sat)
