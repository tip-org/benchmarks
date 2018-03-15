; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  (par (a b)
    (map :source Definitions.map
       ((x (=> a b)) (y (list a))) (list b)
       (match y
         (case nil (_ nil b))
         (case (cons z xs) (cons (@ x z) (map x xs)))))))
(define-fun-rec
  (par (a)
    (drop :source Definitions.drop
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z y)
         (case (S z)
           (match y
             (case nil (_ nil a))
             (case (cons x2 x3) (drop z x3))))))))
(prove
  :source Properties.prop_12
  (par (a b)
    (forall ((n Nat) (f (=> a b)) (xs (list a)))
      (= (drop n (map f xs)) (map f (drop n xs))))))
