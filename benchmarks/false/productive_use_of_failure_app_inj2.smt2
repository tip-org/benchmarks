(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat
     (S :source Definitions.S (proj1-S Nat))
     (Z :source Definitions.Z))))
(define-fun-rec
  (par (a)
    (++ :source Definitions.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(prove
  :source Definitions.prop_app_inj2
  (forall ((xs (list Nat)) (ys (list Nat)) (zs (list Nat)))
    (=> (= (++ xs ys) (++ zs ys)) (= xs zs))))
