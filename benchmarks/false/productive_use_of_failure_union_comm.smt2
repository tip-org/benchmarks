(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (S (proj1-S Nat)) (Z))))
(define-fun |\|\|| ((x Bool) (y Bool)) Bool (ite x true y))
(define-fun-rec
  eqNat
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
  elem
    ((x Nat) (y (list Nat))) Bool
    (match y
      (case nil false)
      (case (cons z xs) (|\|\|| (eqNat x z) (elem x xs)))))
(define-fun-rec
  union
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil y)
      (case (cons z xs)
        (ite (elem z y) (union xs y) (cons z (union xs y))))))
(prove
  (forall ((xs (list Nat)) (ys (list Nat)))
    (= (union xs ys) (union ys xs))))
