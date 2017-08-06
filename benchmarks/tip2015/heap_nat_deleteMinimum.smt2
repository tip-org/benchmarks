; Skew heaps
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes (a)
  ((Maybe :source Prelude.Maybe (Nothing :source Prelude.Nothing)
     (Just :source Prelude.Just (proj1-Just a)))))
(declare-datatypes ()
  ((Heap :source Sort_HeapSort.Heap
     (Node :source Sort_HeapSort.Node (proj1-Node Heap)
       (proj2-Node Nat) (proj3-Node Heap))
     (Nil :source Sort_HeapSort.Nil))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun-rec
  merge :source Sort_HeapSort.merge
    ((x Heap) (y Heap)) Heap
    (match x
      (case (Node z x2 x3)
        (match y
          (case (Node x4 x5 x6)
            (ite
              (le x2 x5) (Node (merge x3 y) x2 z) (Node (merge x x6) x5 x4)))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  |toList'| :source |Sort_HeapSort.toList'|
    ((x Nat) (y Heap)) (list Nat)
    (match x
      (case Z (as nil (list Nat)))
      (case (S z)
        (match y
          (case (Node q z2 r) (cons z2 (|toList'| z (merge q r))))
          (case Nil (as nil (list Nat)))))))
(define-fun-rec
  heapSize :source Sort_HeapSort.heapSize
    ((x Heap)) Nat
    (match x
      (case (Node l y r) (plus (plus (S Z) (heapSize l)) (heapSize r)))
      (case Nil Z)))
(define-fun
  toList :source Sort_HeapSort.toList
    ((x Heap)) (list Nat) (|toList'| (heapSize x) x))
(define-fun
  maybeToList :source Sort_HeapSort.maybeToList
    ((x (Maybe Heap))) (Maybe (list Nat))
    (match x
      (case Nothing (as Nothing (Maybe (list Nat))))
      (case (Just y) (Just (toList y)))))
(define-fun-rec
  heap1 :source Sort_HeapSort.heap1
    ((x Nat) (y Heap)) Bool
    (match y
      (case (Node l z r) (and (le x z) (and (heap1 z l) (heap1 z r))))
      (case Nil true)))
(define-fun
  heap :source Sort_HeapSort.heap
    ((x Heap)) Bool
    (match x
      (case (Node l y r) (and (heap1 y l) (heap1 y r)))
      (case Nil true)))
(define-fun
  deleteMinimum :source Sort_HeapSort.deleteMinimum
    ((x Heap)) (Maybe Heap)
    (match x
      (case (Node l y r) (Just (merge l r)))
      (case Nil (as Nothing (Maybe Heap)))))
(prove
  :source Sort_HeapSort.prop_deleteMinimum
  (forall ((h Heap))
    (=> (heap h)
      (=
        (match (toList h)
          (case nil (as Nothing (Maybe (list Nat))))
          (case (cons x xs) (Just xs)))
        (maybeToList (deleteMinimum h))))))
