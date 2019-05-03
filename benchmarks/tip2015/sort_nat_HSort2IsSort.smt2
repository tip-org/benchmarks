; Heap sort (using skew heaps, simple list-to-heap conversion)
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(declare-datatype
  Heap
  ((Node (proj1-Node Heap) (proj2-Node Nat) (proj3-Node Heap))
   (Nil)))
(define-fun-rec
  leq
  ((x Nat) (y Nat)) Bool
  (match x
    ((zero true)
     ((succ z)
      (match y
        ((zero false)
         ((succ x2) (leq z x2))))))))
(define-fun-rec
  insert
  ((x Nat) (y (list Nat))) (list Nat)
  (match y
    ((nil (cons x (_ nil Nat)))
     ((cons z xs) (ite (leq x z) (cons x y) (cons z (insert x xs)))))))
(define-fun-rec
  isort
  ((x (list Nat))) (list Nat)
  (match x
    ((nil (_ nil Nat))
     ((cons y xs) (insert y (isort xs))))))
(define-fun-rec
  hmerge
  ((x Heap) (y Heap)) Heap
  (match x
    (((Node z x2 x3)
      (match y
        (((Node x4 x5 x6)
          (ite
            (leq x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
         (Nil x))))
     (Nil y))))
(define-fun-rec
  toList
  ((x Heap)) (list Nat)
  (match x
    (((Node q y r) (cons y (toList (hmerge q r))))
     (Nil (_ nil Nat)))))
(define-fun
  hinsert
  ((x Nat) (y Heap)) Heap (hmerge (Node Nil x Nil) y))
(define-fun-rec
  toHeap2
  ((x (list Nat))) Heap
  (match x
    ((nil Nil)
     ((cons y xs) (hinsert y (toHeap2 xs))))))
(define-fun
  hsort2
  ((x (list Nat))) (list Nat) (toList (toHeap2 x)))
(prove (forall ((xs (list Nat))) (= (hsort2 xs) (isort xs))))
