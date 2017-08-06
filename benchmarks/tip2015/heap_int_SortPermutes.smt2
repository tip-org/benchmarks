; Skew heaps
;
; The sort function permutes the input list.
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Heap :source Sort_HeapSort.Heap
     (Node :source Sort_HeapSort.Node (proj1-Node Heap)
       (proj2-Node Int) (proj3-Node Heap))
     (Nil :source Sort_HeapSort.Nil))))
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
      (= x 0) (as nil (list Int))
      (match y
        (case (Node p z q) (cons z (|toList'| (- x 1) (merge p q))))
        (case Nil (as nil (list Int))))))
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
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Int
       (match y
         (case nil 0)
         (case (cons z ys)
           (ite (= x z) (+ 1 (count x ys)) (count x ys)))))))
(prove
  :source Sort_HeapSort.prop_SortPermutes
  (forall ((x Int) (y (list Int)))
    (= (count x (hsort y)) (count x y))))
