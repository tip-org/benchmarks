; Heap sort (using skew heaps, simple list-to-heap conversion)
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
  toList :source Sort.toList
    ((x Heap)) (list Nat)
    (match x
      (case (Node q y r) (cons y (toList (hmerge q r))))
      (case Nil (_ nil Nat))))
(define-fun
  hinsert :source Sort.hinsert
    ((x Nat) (y Heap)) Heap (hmerge (Node Nil x Nil) y))
(define-fun-rec
  toHeap2 :source Sort.toHeap2
    ((x (list Nat))) Heap
    (match x
      (case nil Nil)
      (case (cons y xs) (hinsert y (toHeap2 xs)))))
(define-fun
  hsort2 :source Sort.hsort2
    ((x (list Nat))) (list Nat) (toList (toHeap2 x)))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Nat
       (match y
         (case nil Z)
         (case (cons z ys)
           (ite (= x z) (plus (S Z) (count x ys)) (count x ys)))))))
(prove
  :source Sort.prop_HSort2Count
  (forall ((x Nat) (xs (list Nat)))
    (= (count x (hsort2 xs)) (count x xs))))
