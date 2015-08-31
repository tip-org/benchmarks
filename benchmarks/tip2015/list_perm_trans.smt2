(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun
  (par (a)
    (null
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
(define-fun-rec
  equal
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (equal x2 y2))))))
(define-fun-rec
  elem
    ((x Nat) (y (list Nat))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (equal x z) (elem x ys)))))
(define-fun-rec
  delete
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (as nil (list Nat)))
      (case (cons z xs) (ite (equal x z) xs (cons z (delete x xs))))))
(define-fun-rec
  isPermutation
    ((x (list Nat)) (y (list Nat))) Bool
    (match x
      (case nil (null y))
      (case (cons z xs)
        (and (elem z y) (isPermutation xs (delete z y))))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)) (zs (list Nat)))
    (=> (isPermutation xs ys)
      (=> (isPermutation ys zs) (isPermutation xs zs)))))
(check-sat)
