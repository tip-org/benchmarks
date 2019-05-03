(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((S (proj1-S Nat)) (Z)))
(define-fun-rec
  eqNat
  ((x Nat) (y Nat)) Bool
  (match x
    (((S z)
      (match y
        (((S y2) (eqNat z y2))
         (Z false))))
     (Z
      (match y
        (((S x2) false)
         (Z true)))))))
(define-fun
  barbar
  ((x Bool) (y Bool)) Bool (ite x true y))
(define-fun-rec
  elem
  ((x Nat) (y (list Nat))) Bool
  (match y
    ((nil false)
     ((cons z xs) (barbar (eqNat x z) (elem x xs))))))
(define-fun-rec
  union
  ((x (list Nat)) (y (list Nat))) (list Nat)
  (match x
    ((nil y)
     ((cons z xs)
      (ite (elem z y) (union xs y) (cons z (union xs y)))))))
(prove
  (forall ((xs (list Nat)) (ys (list Nat)))
    (= (union xs ys) (union ys xs))))
