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
  insert
  ((x Int) (y (list Int))) (list Int)
  (match y
    ((nil (cons x (_ nil Int)))
     ((cons z xs) (ite (<= x z) (cons x y) (cons z (insert x xs)))))))
(define-fun-rec
  isort
  ((x (list Int))) (list Int)
  (match x
    ((nil (_ nil Int))
     ((cons y xs) (insert y (isort xs))))))
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
(prove (forall ((xs (list Int))) (= (hsort xs) (isort xs))))
