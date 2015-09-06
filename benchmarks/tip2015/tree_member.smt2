(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (B (B_0 (Tree a)) (B_1 a) (B_2 (Tree a))) (E))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S n) (lt n z))))))
(define-fun-rec
  uniqsorted
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (lt y y2) (uniqsorted z)))))))
(define-fun-rec
  gt
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z false)
      (case (S z)
        (match y
          (case Z true)
          (case (S x2) (gt z x2))))))
(define-fun-rec
  member2
    ((x Nat) (y (Tree Nat))) Bool
    (match y
      (case (B l z r)
        (ite (lt x z) (member2 x l) (=> (gt x z) (member2 x r))))
      (case E false)))
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
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  (par (a)
    (flatten
       ((x (Tree a))) (list a)
       (match x
         (case (B t1 y t2)
           (append (append (flatten t1) (cons y (as nil (list a))))
             (flatten t2)))
         (case E (as nil (list a)))))))
(define-fun ordered ((x (Tree Nat))) Bool (uniqsorted (flatten x)))
(assert-not
  (forall ((x Nat) (t (Tree Nat)))
    (=> (ordered t) (= (elem x (flatten t)) (member2 x t)))))
(check-sat)
