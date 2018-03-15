(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat
     (S :source Definitions.S (proj1-S Nat))
     (Z :source Definitions.Z))))
(define-fun-rec
  (par (a)
    (drop :source Definitions.drop
       ((x Nat) (y (list a))) (list a)
       (match x
         (case (S z)
           (match y
             (case nil (_ nil a))
             (case (cons x2 x3) (drop z x3))))
         (case Z y)))))
(prove
  :source Definitions.prop_drop_idem
  (forall ((n Nat) (xs (list Nat)))
    (= (drop n (drop n xs)) (drop n xs))))
