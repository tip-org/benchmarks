; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x5 Nat) (x6 Nat)) Nat))
  ((match x5
     (case Z x6)
     (case (S x7) (S (plus x7 x6))))))
(define-funs-rec
  ((equal ((x3 Nat) (x4 Nat)) bool))
  ((match x3
     (case
       Z
       (match x4
         (case Z true)
         (case (S ipv) false)))
     (case
       (S ds)
       (match x4
         (case Z false)
         (case (S y2) (equal ds y2)))))))
(define-funs-rec
  ((count ((x Nat) (x2 (list Nat))) Nat))
  ((match x2
     (case nil Z)
     (case
       (cons y ys) (ite (equal x y) (S (count x ys)) (count x ys))))))
(assert-not
  (forall
    ((n Nat) (x8 Nat) (xs (list Nat)))
    (=
      (plus (count n (cons x8 (as nil (list Nat)))) (count n xs))
      (count n (cons x8 xs)))))
(check-sat)
