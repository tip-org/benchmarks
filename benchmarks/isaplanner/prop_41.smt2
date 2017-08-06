; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  (par (a)
    (take :source Definitions.take
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z (_ nil a))
         (case (S z)
           (match y
             (case nil (_ nil a))
             (case (cons x2 x3) (cons x2 (take z x3)))))))))
(define-fun-rec
  (par (a b)
    (map :source Definitions.map
       ((x (=> a b)) (y (list a))) (list b)
       (match y
         (case nil (_ nil b))
         (case (cons z xs) (cons (@ x z) (map x xs)))))))
(prove
  :source Properties.prop_41
  (par (b a)
    (forall ((n Nat) (f (=> a b)) (xs (list a)))
      (= (take n (map f xs)) (map f (take n xs))))))
