; Skew heaps
;
; The sort function returns a sorted list.
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Heap :source Sort_HeapSort.Heap
     (Node :source Sort_HeapSort.Node (proj1-Node Heap)
       (proj2-Node Int) (proj3-Node Heap))
     (Nil :source Sort_HeapSort.Nil))))
(define-fun-rec
  (par (a)
    (ordered-ordered1 :let :source SortUtils.ordered
       ((x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y z)
           (match z
             (case nil true)
             (case (cons y2 xs) (and (<= y y2) (ordered-ordered1 z)))))))))
(define-fun-rec
  merge :source Sort_HeapSort.merge
    ((x Heap) (y Heap)) Heap
    (match x
      (case (Node z x2 x3)
        (match y
          (case (Node x4 x5 x6)
            (ite
              (<= x2 x5) (Node (merge x3 y) x2 z) (Node (merge x x6) x5 x4)))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  |toList'| :source |Sort_HeapSort.toList'|
    ((x Int) (y Heap)) (list Int)
    (ite
      (= x 0) (_ nil Int)
      (match y
        (case (Node p z q) (cons z (|toList'| (- x 1) (merge p q))))
        (case Nil (_ nil Int)))))
(define-fun
  insert :source Sort_HeapSort.insert
    ((x Int) (y Heap)) Heap (merge (Node Nil x Nil) y))
(define-fun-rec
  toHeap :source Sort_HeapSort.toHeap
    ((x (list Int))) Heap
    (match x
      (case nil Nil)
      (case (cons y xs) (insert y (toHeap xs)))))
(define-fun-rec
  heapSize :source Sort_HeapSort.heapSize
    ((x Heap)) Int
    (match x
      (case (Node l y r) (+ (+ 1 (heapSize l)) (heapSize r)))
      (case Nil 0)))
(define-fun
  toList :source Sort_HeapSort.toList
    ((x Heap)) (list Int) (|toList'| (heapSize x) x))
(define-fun
  hsort :source Sort_HeapSort.hsort
    ((x (list Int))) (list Int) (toList (toHeap x)))
(prove
  :source Sort_HeapSort.prop_SortSorts
  (forall ((x (list Int))) (ordered-ordered1 (hsort x))))
