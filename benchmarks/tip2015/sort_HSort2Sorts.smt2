; Heap sort (using skew heaps, simple list-to-heap conversion)
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Heap :source Sort.Heap
     (Node :source Sort.Node (proj1-Node Heap)
       (proj2-Node Int) (proj3-Node Heap))
     (Nil :source Sort.Nil))))
(define-fun-rec
  ordered :source SortUtils.ordered
    ((x (list Int))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (<= y y2) (ordered z)))))))
(define-fun-rec
  hmerge :source Sort.hmerge
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
  toList :source Sort.toList
    ((x Heap)) (list Int)
    (match x
      (case (Node p y q) (cons y (toList (hmerge p q))))
      (case Nil (_ nil Int))))
(define-fun
  hinsert :source Sort.hinsert
    ((x Int) (y Heap)) Heap (hmerge (Node Nil x Nil) y))
(define-fun-rec
  toHeap2 :source Sort.toHeap2
    ((x (list Int))) Heap
    (match x
      (case nil Nil)
      (case (cons y xs) (hinsert y (toHeap2 xs)))))
(define-fun
  hsort2 :source Sort.hsort2
    ((x (list Int))) (list Int) (toList (toHeap2 x)))
(prove
  :source Sort.prop_HSort2Sorts
  (forall ((xs (list Int))) (ordered (hsort2 xs))))
