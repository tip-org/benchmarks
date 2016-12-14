; Skew heaps
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (proj1-Just a)))))
(declare-datatypes ()
  ((Heap (Node (proj1-Node Heap) (proj2-Node Int) (proj3-Node Heap))
     (Nil))))
(define-fun-rec
  merge
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
  toList2
    ((x Int) (y Heap)) (list Int)
    (ite
      (= x 0) (as nil (list Int))
      (match y
        (case (Node p z q) (cons z (toList2 (- x 1) (merge p q))))
        (case Nil (as nil (list Int))))))
(define-fun-rec
  heapSize
    ((x Heap)) Int
    (match x
      (case (Node l y r) (+ (+ 1 (heapSize l)) (heapSize r)))
      (case Nil 0)))
(define-fun toList ((x Heap)) (list Int) (toList2 (heapSize x) x))
(define-fun
  maybeToList
    ((x (Maybe Heap))) (Maybe (list Int))
    (match x
      (case Nothing (as Nothing (Maybe (list Int))))
      (case (Just y) (Just (toList y)))))
(define-fun-rec
  heap1
    ((x Int) (y Heap)) Bool
    (match y
      (case (Node l z r) (and (<= x z) (and (heap1 z l) (heap1 z r))))
      (case Nil true)))
(define-fun
  heap
    ((x Heap)) Bool
    (match x
      (case (Node l y r) (and (heap1 y l) (heap1 y r)))
      (case Nil true)))
(define-fun
  deleteMinimum
    ((x Heap)) (Maybe Heap)
    (match x
      (case (Node l y r) (Just (merge l r)))
      (case Nil (as Nothing (Maybe Heap)))))
(assert-not
  (forall ((h Heap))
    (=> (heap h)
      (=
        (match (toList h)
          (case nil (as Nothing (Maybe (list Int))))
          (case (cons x xs) (Just xs)))
        (maybeToList (deleteMinimum h))))))
(check-sat)
