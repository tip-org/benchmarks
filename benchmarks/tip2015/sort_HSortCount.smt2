; Heap sort (using skew heaps, efficient list-to-heap conversion)
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes ()
  ((Heap (Node (proj1-Node Heap) (proj2-Node Int) (proj3-Node Heap))
     (Nil))))
(define-fun-rec
  toHeap
    ((x (list Int))) (list Heap)
    (match x
      (case nil (_ nil Heap))
      (case (cons y z) (cons (Node Nil y Nil) (toHeap z)))))
(define-fun-rec
  hmerge
    ((x Heap) (y Heap)) Heap
    (match x
      (case (Node z x2 x3)
        (match y
          (case (Node x4 x5 x6)
            (ite
              (<= x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  hpairwise
    ((x (list Heap))) (list Heap)
    (match x
      (case nil (_ nil Heap))
      (case (cons p y)
        (match y
          (case nil (cons p (_ nil Heap)))
          (case (cons q qs) (cons (hmerge p q) (hpairwise qs)))))))
(define-fun-rec
  hmerging
    ((x (list Heap))) Heap
    (match x
      (case nil Nil)
      (case (cons p y)
        (match y
          (case nil p)
          (case (cons z x2) (hmerging (hpairwise x)))))))
(define-fun toHeap2 ((x (list Int))) Heap (hmerging (toHeap x)))
(define-fun-rec
  toList
    ((x Heap)) (list Int)
    (match x
      (case (Node p y q) (cons y (toList (hmerge p q))))
      (case Nil (_ nil Int))))
(define-fun hsort ((x (list Int))) (list Int) (toList (toHeap2 x)))
(define-fun-rec
  (par (a)
    (count
       ((x a) (y (list a))) Int
       (match y
         (case nil 0)
         (case (cons z ys)
           (ite (= x z) (+ 1 (count x ys)) (count x ys)))))))
(prove
  (forall ((x Int) (xs (list Int)))
    (= (count x (hsort xs)) (count x xs))))
