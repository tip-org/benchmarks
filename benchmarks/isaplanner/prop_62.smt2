; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat (Z :source Definitions.Z)
     (S :source Definitions.S (proj1-S Nat)))))
(define-fun-rec
  last :source Definitions.last
    ((x (list Nat))) Nat
    (match x
      (case nil Z)
      (case (cons y z)
        (match z
          (case nil y)
          (case (cons x2 x3) (last z))))))
(prove
  :source Properties.prop_62
  (forall ((xs (list Nat)) (x Nat))
    (=>
      (not
        (match xs
          (case nil true)
          (case (cons y z) false)))
      (= (last (cons x xs)) (last xs)))))
