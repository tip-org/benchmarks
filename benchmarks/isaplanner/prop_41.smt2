; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  (par (a)
    (take
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z (_ nil a))
         (case (S z)
           (match y
             (case nil (_ nil a))
             (case (cons x2 x3) (cons x2 (take z x3)))))))))
(define-fun-rec
  (par (a b)
    (map
       ((x (=> a b)) (y (list a))) (list b)
       (match y
         (case nil (_ nil b))
         (case (cons z xs) (cons (@ x z) (map x xs)))))))
(prove
  (par (a b)
    (forall ((n Nat) (f (=> a b)) (xs (list a)))
      (= (take n (map f xs)) (map f (take n xs))))))
