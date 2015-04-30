; Heap sort (using skew heaps)
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Heap (Node (Node_0 (Heap a)) (Node_1 a) (Node_2 (Heap a)))
     (Nil))))
(define-funs-rec
  ((toHeap2 ((x (list int))) (list (Heap int))))
  ((match x
     (case nil (as nil (list (Heap int))))
     (case (cons y z)
       (cons (Node (as Nil (Heap int)) y (as Nil (Heap int)))
         (toHeap2 z))))))
(define-funs-rec ((or2 ((x bool) (y bool)) bool)) ((ite x true y)))
(define-funs-rec
  ((par (t) (null ((x (list t))) bool)))
  ((match x
     (case nil true)
     (case (cons y z) false))))
(define-funs-rec
  ((hmerge ((x (Heap int)) (y (Heap int))) (Heap int)))
  ((match x
     (case (Node z x2 x3)
       (match y
         (case (Node x4 x5 x6)
           (ite
             (<= x2 x5) (Node (hmerge x3 y) x2 z) (Node (hmerge x x6) x5 x4)))
         (case Nil x)))
     (case Nil y))))
(define-funs-rec
  ((hpairwise ((x (list (Heap int)))) (list (Heap int))))
  ((match x
     (case nil x)
     (case (cons p y)
       (match y
         (case nil x)
         (case (cons q qs) (cons (hmerge p q) (hpairwise qs))))))))
(define-funs-rec
  ((hmerging ((x (list (Heap int)))) (Heap int)))
  ((match x
     (case nil (as Nil (Heap int)))
     (case (cons p y)
       (match y
         (case nil p)
         (case (cons z x2) (hmerging (hpairwise x))))))))
(define-funs-rec
  ((toHeap ((x (list int))) (Heap int))) ((hmerging (toHeap2 x))))
(define-funs-rec
  ((toList ((x (Heap int))) (list int)))
  ((match x
     (case (Node p y q) (cons y (toList (hmerge p q))))
     (case Nil (as nil (list int))))))
(define-funs-rec
  ((elem ((x int) (y (list int))) bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (= x z) (elem x ys))))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((hsort ((x (list int))) (list int)))
  ((dot (lambda ((y (Heap int))) (toList y))
     (lambda ((z (list int))) (toHeap z)) x)))
(define-funs-rec
  ((delete ((x int) (y (list int))) (list int)))
  ((match y
     (case nil y)
     (case (cons z ys) (ite (= x z) ys (cons z (delete x ys)))))))
(define-funs-rec
  ((and2 ((x bool) (y bool)) bool)) ((ite x y false)))
(define-funs-rec
  ((isPermutation ((x (list int)) (y (list int))) bool))
  ((match x
     (case nil (null y))
     (case (cons z xs)
       (and2 (elem z y) (isPermutation xs (delete z y)))))))
(assert-not (forall ((x (list int))) (isPermutation (hsort x) x)))
(check-sat)
