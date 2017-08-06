; Skew heaps
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Heap :source Sort_HeapSort.Heap
     (Node :source Sort_HeapSort.Node (proj1-Node Heap)
       (proj2-Node Int) (proj3-Node Heap))
     (Nil :source Sort_HeapSort.Nil))))
(define-fun-rec
  mergeLists :source Sort_HeapSort.mergeLists
    ((x (list Int)) (y (list Int))) (list Int)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4)
            (ite
              (<= z x3) (cons z (mergeLists x2 y))
              (cons x3 (mergeLists x x4))))))))
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
(define-fun-rec
  heapSize :source Sort_HeapSort.heapSize
    ((x Heap)) Int
    (match x
      (case (Node l y r) (+ (+ 1 (heapSize l)) (heapSize r)))
      (case Nil 0)))
(define-fun
  toList :source Sort_HeapSort.toList
    ((x Heap)) (list Int) (|toList'| (heapSize x) x))
(define-fun-rec
  heap1 :source Sort_HeapSort.heap1
    ((x Int) (y Heap)) Bool
    (match y
      (case (Node l z r) (and (<= x z) (and (heap1 z l) (heap1 z r))))
      (case Nil true)))
(define-fun
  heap :source Sort_HeapSort.heap
    ((x Heap)) Bool
    (match x
      (case (Node l y r) (and (heap1 y l) (heap1 y r)))
      (case Nil true)))
(prove
  :source Sort_HeapSort.prop_merge
  (forall ((x Heap) (y Heap))
    (=> (heap x)
      (=> (heap y)
        (= (toList (merge x y)) (mergeLists (toList x) (toList y)))))))
