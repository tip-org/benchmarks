; Heap sort (using skew heaps, simple list-to-heap conversion)
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Heap
  ((Node (proj1-Node Heap) (proj2-Node Int) (proj3-Node Heap))
   (Nil)))
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
  toList
  ((x Heap)) (list Int)
  (match x
    (((Node p y q) (cons y (toList (hmerge p q))))
     (Nil (_ nil Int)))))
(define-fun
  hinsert
  ((x Int) (y Heap)) Heap (hmerge (Node Nil x Nil) y))
(define-fun-rec
  toHeap2
  ((x (list Int))) Heap
  (match x
    ((nil Nil)
     ((cons y xs) (hinsert y (toHeap2 xs))))))
(define-fun
  hsort2
  ((x (list Int))) (list Int) (toList (toHeap2 x)))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Int))
  (match y
    ((nil 0)
     ((cons z ys) (ite (= x z) (+ 1 (count x ys)) (count x ys))))))
(prove
  (forall ((x Int) (xs (list Int)))
    (= (count x (hsort2 xs)) (count x xs))))
