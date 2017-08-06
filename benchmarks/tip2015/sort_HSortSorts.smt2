; Heap sort (using skew heaps)
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Heap :source Sort.Heap
     (Node :source Sort.Node (proj1-Node Heap)
       (proj2-Node Int) (proj3-Node Heap))
     (Nil :source Sort.Nil))))
(define-fun-rec
  toHeap :let
    ((x (list Int))) (list Heap)
    (match x
      (case nil (_ nil Heap))
      (case (cons y z) (cons (Node Nil y Nil) (toHeap z)))))
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
  hpairwise :source Sort.hpairwise
    ((x (list Heap))) (list Heap)
    (match x
      (case nil (_ nil Heap))
      (case (cons p y)
        (match y
          (case nil (cons p (_ nil Heap)))
          (case (cons q qs) (cons (hmerge p q) (hpairwise qs)))))))
(define-fun-rec
  hmerging :source Sort.hmerging
    ((x (list Heap))) Heap
    (match x
      (case nil Nil)
      (case (cons p y)
        (match y
          (case nil p)
          (case (cons z x2) (hmerging (hpairwise x)))))))
(define-fun
  toHeap2 :source Sort.toHeap
    ((x (list Int))) Heap (hmerging (toHeap x)))
(define-fun-rec
  toList :source Sort.toList
    ((x Heap)) (list Int)
    (match x
      (case (Node p y q) (cons y (toList (hmerge p q))))
      (case Nil (_ nil Int))))
(define-fun
  hsort :source Sort.hsort
    ((x (list Int))) (list Int) (toList (toHeap2 x)))
(prove
  :source Sort.prop_HSortSorts
  (forall ((xs (list Int))) (ordered (hsort xs))))
