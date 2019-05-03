; Heap sort (using skew heaps, efficient list-to-heap conversion)
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(declare-datatype
  Heap
  ((Node (proj1-Node Heap) (proj2-Node Nat) (proj3-Node Heap))
   (Nil)))
(define-fun-rec
  toHeap
  ((x (list Nat))) (list Heap)
  (match x
    ((nil (_ nil Heap))
     ((cons y z) (cons (Node Nil y Nil) (toHeap z))))))
(define-fun-rec
  plus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero y)
     ((succ z) (succ (plus z y))))))
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
  hpairwise
  ((x (list Heap))) (list Heap)
  (match x
    ((nil (_ nil Heap))
     ((cons q y)
      (match y
        ((nil (cons q (_ nil Heap)))
         ((cons r qs) (cons (hmerge q r) (hpairwise qs)))))))))
(define-fun-rec
  hmerging
  ((x (list Heap))) Heap
  (match x
    ((nil Nil)
     ((cons q y)
      (match y
        ((nil q)
         ((cons z x2) (hmerging (hpairwise x)))))))))
(define-fun
  toHeap2
  ((x (list Nat))) Heap (hmerging (toHeap x)))
(define-fun-rec
  toList
  ((x Heap)) (list Nat)
  (match x
    (((Node q y r) (cons y (toList (hmerge q r))))
     (Nil (_ nil Nat)))))
(define-fun
  hsort
  ((x (list Nat))) (list Nat) (toList (toHeap2 x)))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Nat))
  (match y
    ((nil zero)
     ((cons z ys)
      (ite (= x z) (plus (succ zero) (count x ys)) (count x ys))))))
(prove
  (forall ((x Nat) (xs (list Nat)))
    (= (count x (hsort xs)) (count x xs))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
