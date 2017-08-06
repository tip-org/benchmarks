; Skew heaps
;
; The sort function returns a sorted list.
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
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
      (case Z (_ nil Nat))
      (case (S z)
        (match y
          (case (Node q z2 r) (cons z2 (|toList'| z (merge q r))))
          (case Nil (_ nil Nat))))))
(define-fun
  insert :source Sort_HeapSort.insert
    ((x Nat) (y Heap)) Heap (merge (Node Nil x Nil) y))
(define-fun-rec
  toHeap :source Sort_HeapSort.toHeap
    ((x (list Nat))) Heap
    (match x
      (case nil Nil)
      (case (cons y xs) (insert y (toHeap xs)))))
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
  hsort :source Sort_HeapSort.hsort
    ((x (list Nat))) (list Nat) (toList (toHeap x)))
(prove
  :source Sort_HeapSort.prop_SortSorts
  (forall ((x (list Nat))) (ordered-ordered1 (hsort x))))
