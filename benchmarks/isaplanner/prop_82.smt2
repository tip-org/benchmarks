; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  (par (a b)
    (zip
       ((x (list a)) (y (list b))) (list (pair a b))
       (match x
         (case nil (_ nil (pair a b)))
         (case (cons z x2)
           (match y
             (case nil (_ nil (pair a b)))
             (case (cons x3 x4) (cons (pair2 z x3) (zip x2 x4)))))))))
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
(prove
  (par (a b)
    (forall ((n Nat) (xs (list a)) (ys (list b)))
      (= (take n (zip xs ys)) (zip (take n xs) (take n ys))))))
