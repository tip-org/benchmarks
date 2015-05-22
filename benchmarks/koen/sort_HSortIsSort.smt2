; Heap sort (using skew heaps)
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Heap (Node (Node_0 (Heap a)) (Node_1 a) (Node_2 (Heap a)))
     (Nil))))
(define-funs-rec
  ((toHeap2 ((x (list Int))) (list (Heap Int))))
  ((match x
     (case nil (as nil (list (Heap Int))))
     (case (cons y z)
       (cons (Node (as Nil (Heap Int)) y (as Nil (Heap Int)))
         (toHeap2 z))))))
(define-funs-rec
  ((insert2 ((x Int) (y (list Int))) (list Int)))
  ((match y
     (case nil (cons x (as nil (list Int))))
     (case (cons z xs)
       (ite (<= x z) (cons x y) (cons z (insert2 x xs)))))))
(define-funs-rec
  ((isort ((x (list Int))) (list Int)))
  ((match x
     (case nil (as nil (list Int)))
     (case (cons y xs) (insert2 y (isort xs))))))
(define-funs-rec
  ((hmerge ((x (Heap Int)) (y (Heap Int))) (Heap Int)))
  ((match x
     (case (Node z x2 x3)
       (match y
         (case (Node x4 x5 x6)
           (ite
             (<= x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
         (case Nil x)))
     (case Nil y))))
(define-funs-rec
  ((hpairwise ((x (list (Heap Int)))) (list (Heap Int))))
  ((match x
     (case nil (as nil (list (Heap Int))))
     (case (cons p y)
       (match y
         (case nil (cons p (as nil (list (Heap Int)))))
         (case (cons q qs) (cons (hmerge p q) (hpairwise qs))))))))
(define-funs-rec
  ((hmerging ((x (list (Heap Int)))) (Heap Int)))
  ((match x
     (case nil (as Nil (Heap Int)))
     (case (cons p y)
       (match y
         (case nil p)
         (case (cons z x2) (hmerging (hpairwise x))))))))
(define-funs-rec
  ((toHeap ((x (list Int))) (Heap Int))) ((hmerging (toHeap2 x))))
(define-funs-rec
  ((toList ((x (Heap Int))) (list Int)))
  ((match x
     (case (Node p y q) (cons y (toList (hmerge p q))))
     (case Nil (as nil (list Int))))))
(define-funs-rec
  ((hsort ((x (list Int))) (list Int))) ((toList (toHeap x))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(assert-not (forall ((x (list Int))) (= (hsort x) (isort x))))
(check-sat)
