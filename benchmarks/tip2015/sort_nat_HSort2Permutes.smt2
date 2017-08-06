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
    (elem :let :source Prelude.elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (deleteBy :source Data.List.deleteBy
       ((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)
       (match z
         (case nil (_ nil a))
         (case (cons y2 ys)
           (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys))))))))
(define-fun-rec
  (par (a)
    (isPermutation :source SortUtils.isPermutation
       ((x (list a)) (y (list a))) Bool
       (match x
         (case nil
           (match y
             (case nil true)
             (case (cons z x2) false)))
         (case (cons x3 xs)
           (and (elem x3 y)
             (isPermutation xs
               (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5)))
                 x3 y))))))))
(prove
  :source Sort.prop_HSort2Permutes
  (forall ((xs (list Nat))) (isPermutation (hsort2 xs) xs)))
