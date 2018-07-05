; Heap sort (using skew heaps, simple list-to-heap conversion)
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(declare-datatypes ()
  ((Heap (Node (proj1-Node Heap) (proj2-Node Nat) (proj3-Node Heap))
     (Nil))))
(define-fun-rec
  leq
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(define-fun-rec
  ordered
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (leq y y2) (ordered z)))))))
(define-fun-rec
  hmerge
    ((x Heap) (y Heap)) Heap
    (match x
      (case (Node z x2 x3)
        (match y
          (case (Node x4 x5 x6)
            (ite
              (leq x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  toList
    ((x Heap)) (list Nat)
    (match x
      (case (Node q y r) (cons y (toList (hmerge q r))))
      (case Nil (_ nil Nat))))
(define-fun
  hinsert ((x Nat) (y Heap)) Heap (hmerge (Node Nil x Nil) y))
(define-fun-rec
  toHeap2
    ((x (list Nat))) Heap
    (match x
      (case nil Nil)
      (case (cons y xs) (hinsert y (toHeap2 xs)))))
(define-fun
  hsort2 ((x (list Nat))) (list Nat) (toList (toHeap2 x)))
(prove (forall ((xs (list Nat))) (ordered (hsort2 xs))))
