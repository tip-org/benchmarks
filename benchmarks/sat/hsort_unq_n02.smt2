(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes (a)
  ((Heap (Node (Node_0 (Heap a)) (Node_1 a) (Node_2 (Heap a)))
     (Nil))))
(define-fun-rec
  toHeap2
    ((x (list Nat))) (list (Heap Nat))
    (match x
      (case nil (as nil (list (Heap Nat))))
      (case (cons y z)
        (cons (Node (as Nil (Heap Nat)) y (as Nil (Heap Nat)))
          (toHeap2 z)))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun-rec
  hmerge
    ((x (Heap Nat)) (y (Heap Nat))) (Heap Nat)
    (match x
      (case (Node z x2 x3)
        (match y
          (case (Node x4 x5 x6)
            (ite
              (le x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  hpairwise
    ((x (list (Heap Nat)))) (list (Heap Nat))
    (match x
      (case nil (as nil (list (Heap Nat))))
      (case (cons q y)
        (match y
          (case nil (cons q (as nil (list (Heap Nat)))))
          (case (cons q2 qs) (cons (hmerge q q2) (hpairwise qs)))))))
(define-fun-rec
  hmerging
    ((x (list (Heap Nat)))) (Heap Nat)
    (match x
      (case nil (as Nil (Heap Nat)))
      (case (cons q y)
        (match y
          (case nil q)
          (case (cons z x2) (hmerging (hpairwise x)))))))
(define-fun
  toHeap ((x (list Nat))) (Heap Nat) (hmerging (toHeap2 x)))
(define-fun-rec
  toList
    ((x (Heap Nat))) (list Nat)
    (match x
      (case (Node q y q2) (cons y (toList (hmerge q q2))))
      (case Nil (as nil (list Nat)))))
(define-fun hsort ((x (list Nat))) (list Nat) (toList (toHeap x)))
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
  unique
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y xs) (and (not (elem y xs)) (unique xs)))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (or (distinct (hsort xs) (hsort ys))
      (or (= xs ys)
        (or (not (unique xs)) (distinct (length xs) (S (S Z))))))))
(check-sat)
