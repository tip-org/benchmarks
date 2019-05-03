; Heap sort (using skew heaps, efficient list-to-heap conversion)
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Heap
  ((Node (proj1-Node Heap) (proj2-Node Int) (proj3-Node Heap))
   (Nil)))
(define-fun-rec
  toHeap
  ((x (list Int))) (list Heap)
  (match x
    ((nil (_ nil Heap))
     ((cons y z) (cons (Node Nil y Nil) (toHeap z))))))
(define-fun-rec
  ordered
  ((x (list Int))) Bool
  (match x
    ((nil true)
     ((cons y z)
      (match z
        ((nil true)
         ((cons y2 xs) (and (<= y y2) (ordered z)))))))))
(define-fun-rec
  hmerge
  ((x Heap) (y Heap)) Heap
  (match x
    (((Node z x2 x3)
      (match y
        (((Node x4 x5 x6)
          (ite
            (<= x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
         (Nil x))))
     (Nil y))))
(define-fun-rec
  hpairwise
  ((x (list Heap))) (list Heap)
  (match x
    ((nil (_ nil Heap))
     ((cons p y)
      (match y
        ((nil (cons p (_ nil Heap)))
         ((cons q qs) (cons (hmerge p q) (hpairwise qs)))))))))
(define-fun-rec
  hmerging
  ((x (list Heap))) Heap
  (match x
    ((nil Nil)
     ((cons p y)
      (match y
        ((nil p)
         ((cons z x2) (hmerging (hpairwise x)))))))))
(define-fun
  toHeap2
  ((x (list Int))) Heap (hmerging (toHeap x)))
(define-fun-rec
  toList
  ((x Heap)) (list Int)
  (match x
    (((Node p y q) (cons y (toList (hmerge p q))))
     (Nil (_ nil Int)))))
(define-fun
  hsort
  ((x (list Int))) (list Int) (toList (toHeap2 x)))
(prove (forall ((xs (list Int))) (ordered (hsort xs))))
