; Heap sort (using skew heaps, simple list-to-heap conversion)
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Heap
  ((Node (proj1-Node Heap) (proj2-Node Int) (proj3-Node Heap))
   (Nil)))
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
(prove (forall ((xs (list Int))) (= (hsort2 xs) (isort xs))))
