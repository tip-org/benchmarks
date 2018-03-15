(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Nat :source Definitions.Nat
     (S :source Definitions.S (proj1-S Nat))
     (Z :source Definitions.Z))))
(define-fun
  |\|\|| :source |Definitions.\|\||
    ((x Bool) (y Bool)) Bool (ite x true y))
(define-fun-rec
  eqNat :source Definitions.eqNat
    ((x Nat) (y Nat)) Bool
    (match x
      (case (S z)
        (match y
          (case (S y2) (eqNat z y2))
          (case Z false)))
      (case Z
        (match y
          (case (S x2) false)
          (case Z true)))))
(define-fun-rec
  elem :source Definitions.elem
    ((x Nat) (y (list Nat))) Bool
    (match y
      (case nil false)
      (case (cons z xs) (|\|\|| (eqNat x z) (elem x xs)))))
(define-fun-rec
  union :source Definitions.union
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil y)
      (case (cons z xs)
        (ite (elem z y) (union xs y) (cons z (union xs y))))))
(prove
  :source Definitions.prop_union_idem
  (forall ((xs (list Nat))) (= (union xs xs) xs)))
