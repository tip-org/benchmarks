; Heap sort (using skew heaps)
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Heap :source Sort.Heap
     (Node :source Sort.Node (proj1-Node (Heap a))
       (proj2-Node a) (proj3-Node (Heap a)))
     (Nil :source Sort.Nil))))
(define-fun-rec
  (par (a)
    (toHeap :let
       ((x (list a))) (list (Heap a))
       (match x
         (case nil (as nil (list (Heap a))))
         (case (cons y z)
           (cons (Node (as Nil (Heap a)) y (as Nil (Heap a))) (toHeap z)))))))
(define-fun-rec
  (par (a)
    (hmerge :source Sort.hmerge
       ((x (Heap a)) (y (Heap a))) (Heap a)
       (match x
         (case (Node z x2 x3)
           (match y
             (case (Node x4 x5 x6)
               (ite
                 (<= x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
             (case Nil x)))
         (case Nil y)))))
(define-fun-rec
  (par (a)
    (hpairwise :source Sort.hpairwise
       ((x (list (Heap a)))) (list (Heap a))
       (match x
         (case nil (as nil (list (Heap a))))
         (case (cons p y)
           (match y
             (case nil (cons p (as nil (list (Heap a)))))
             (case (cons q qs) (cons (hmerge p q) (hpairwise qs)))))))))
(define-fun-rec
  (par (a)
    (hmerging :source Sort.hmerging
       ((x (list (Heap a)))) (Heap a)
       (match x
         (case nil (as Nil (Heap a)))
         (case (cons p y)
           (match y
             (case nil p)
             (case (cons z x2) (hmerging (hpairwise x)))))))))
(define-fun
  (par (a)
    (toHeap2 :source Sort.toHeap
       ((x (list a))) (Heap a) (hmerging (toHeap x)))))
(define-fun-rec
  (par (a)
    (toList :source Sort.toList
       ((x (Heap a))) (list a)
       (match x
         (case (Node p y q) (cons y (toList (hmerge p q))))
         (case Nil (as nil (list a)))))))
(define-fun
  (par (a)
    (hsort :source Sort.hsort
       ((x (list a))) (list a) (toList (toHeap2 x)))))
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
         (case nil (as nil (list a)))
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
  :source Sort.prop_HSortPermutes
  (forall ((x (list Int))) (isPermutation (hsort x) x)))
