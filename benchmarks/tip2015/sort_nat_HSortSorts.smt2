; Heap sort (using skew heaps)
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Heap :source Sort.Heap
     (Node :source Sort.Node (proj1-Node Heap)
       (proj2-Node Nat) (proj3-Node Heap))
     (Nil :source Sort.Nil))))
(define-fun-rec
  toHeap :let
    ((x (list Nat))) (list Heap)
    (match x
      (case nil (_ nil Heap))
      (case (cons y z) (cons (Node Nil y Nil) (toHeap z)))))
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
  ordered :source SortUtils.ordered
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (le y y2) (ordered z)))))))
(define-fun-rec
  hmerge :source Sort.hmerge
    ((x Heap) (y Heap)) Heap
    (match x
      (case (Node z x2 x3)
        (match y
          (case (Node x4 x5 x6)
            (ite
              (le x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
          (case Nil x)))
      (case Nil y)))
(define-fun-rec
  hpairwise :source Sort.hpairwise
    ((x (list Heap))) (list Heap)
    (match x
      (case nil (_ nil Heap))
      (case (cons q y)
        (match y
          (case nil (cons q (_ nil Heap)))
          (case (cons r qs) (cons (hmerge q r) (hpairwise qs)))))))
(define-fun-rec
  hmerging :source Sort.hmerging
    ((x (list Heap))) Heap
    (match x
      (case nil Nil)
      (case (cons q y)
        (match y
          (case nil q)
          (case (cons z x2) (hmerging (hpairwise x)))))))
(define-fun
  toHeap2 :source Sort.toHeap
    ((x (list Nat))) Heap (hmerging (toHeap x)))
(define-fun-rec
  toList :source Sort.toList
    ((x Heap)) (list Nat)
    (match x
      (case (Node q y r) (cons y (toList (hmerge q r))))
      (case Nil (_ nil Nat))))
(define-fun
  hsort :source Sort.hsort
    ((x (list Nat))) (list Nat) (toList (toHeap2 x)))
(prove
  :source Sort.prop_HSortSorts
  (forall ((xs (list Nat))) (ordered (hsort xs))))
