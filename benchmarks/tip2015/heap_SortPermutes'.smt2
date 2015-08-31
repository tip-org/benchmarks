; Skew heaps
;
; The sort function permutes the input list, version 2.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Heap (Node (Node_0 Heap) (Node_1 Nat) (Node_2 Heap)) (Nil))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S n) (S (plus n y)))))
(define-fun
  (par (a)
    (null
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z) false)))))
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
  merge
    ((x Heap) (y Heap)) Heap
    (match x
      (case (Node z x2 x3)
        (match y
          (case (Node x4 x5 x6)
            (ite
              (le x2 x5) (Node (merge x3 y) x2 z) (Node (merge x x6) x5 x4)))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  toList
    ((x Nat) (y Heap)) (list Nat)
    (match x
      (case Z (as nil (list Nat)))
      (case (S z)
        (match y
          (case (Node x2 x3 x4) (cons x3 (toList z (merge x2 x4))))
          (case Nil (as nil (list Nat)))))))
(define-fun
  insert2 ((x Nat) (y Heap)) Heap (merge (Node Nil x Nil) y))
(define-fun-rec
  toHeap
    ((x (list Nat))) Heap
    (match x
      (case nil Nil)
      (case (cons y xs) (insert2 y (toHeap xs)))))
(define-fun-rec
  heapSize
    ((x Heap)) Nat
    (match x
      (case (Node l y r) (S (plus (heapSize l) (heapSize r))))
      (case Nil Z)))
(define-fun toList2 ((x Heap)) (list Nat) (toList (heapSize x) x))
(define-fun hsort ((x (list Nat))) (list Nat) (toList2 (toHeap x)))
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
(assert-not (forall ((x (list Nat))) (isPermutation (hsort x) x)))
(check-sat)
