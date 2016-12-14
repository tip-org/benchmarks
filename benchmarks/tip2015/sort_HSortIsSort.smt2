; Heap sort (using skew heaps)
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Heap
     (Node (proj1-Node (Heap a)) (proj2-Node a) (proj3-Node (Heap a)))
     (Nil))))
(define-fun-rec
  (par (a)
    (toHeap
       ((x (list a))) (list (Heap a))
       (match x
         (case nil (as nil (list (Heap a))))
         (case (cons y z)
           (cons (Node (as Nil (Heap a)) y (as Nil (Heap a))) (toHeap z)))))))
(define-fun-rec
  (par (a)
    (insert2
       ((x a) (y (list a))) (list a)
       (match y
         (case nil (cons x (as nil (list a))))
         (case (cons z xs)
           (ite (<= x z) (cons x y) (cons z (insert2 x xs))))))))
(define-fun-rec
  (par (a)
    (isort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs) (insert2 y (isort xs)))))))
(define-fun-rec
  (par (a)
    (hmerge
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
    (hpairwise
       ((x (list (Heap a)))) (list (Heap a))
       (match x
         (case nil (as nil (list (Heap a))))
         (case (cons p y)
           (match y
             (case nil (cons p (as nil (list (Heap a)))))
             (case (cons q qs) (cons (hmerge p q) (hpairwise qs)))))))))
(define-fun-rec
  (par (a)
    (hmerging
       ((x (list (Heap a)))) (Heap a)
       (match x
         (case nil (as Nil (Heap a)))
         (case (cons p y)
           (match y
             (case nil p)
             (case (cons z x2) (hmerging (hpairwise x)))))))))
(define-fun
  (par (a) (toHeap2 ((x (list a))) (Heap a) (hmerging (toHeap x)))))
(define-fun-rec
  (par (a)
    (toList
       ((x (Heap a))) (list a)
       (match x
         (case (Node p y q) (cons y (toList (hmerge p q))))
         (case Nil (as nil (list a)))))))
(define-fun
  (par (a) (hsort ((x (list a))) (list a) (toList (toHeap2 x)))))
(assert-not (forall ((x (list Int))) (= (hsort x) (isort x))))
(check-sat)
