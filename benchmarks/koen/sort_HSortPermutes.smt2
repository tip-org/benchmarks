; Heap sort (using skew heaps)
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
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
     (case (cons q y)
       (match y
         (case nil x)
         (case (cons q2 qs) (cons (hmerge q q2) (hpairwise qs))))))))
(define-funs-rec
  ((hmerging ((x (list (Heap int)))) (Heap int)))
  ((match x
     (case nil (as Nil (Heap int)))
     (case (cons q y)
       (match y
         (case nil q)
         (case (cons z x2) (hmerging (hpairwise x))))))))
(define-funs-rec
  ((toHeap ((x (list int))) (Heap int))) ((hmerging (toHeap2 x))))
(define-funs-rec
  ((toList ((x (Heap int))) (list int)))
  ((match x
     (case (Node q y q2) (cons y (toList (hmerge q q2))))
     (case Nil (as nil (list int))))))
(define-funs-rec
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((hsort ((x (list int))) (list int)))
  ((dot (lambda ((y (Heap int))) (toList y))
     (lambda ((z (list int))) (toHeap z)) x)))
(define-funs-rec
  ((count ((x int) (y (list int))) Nat))
  ((match y
     (case nil Z)
     (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs))))))
(assert-not
  (forall ((x int) (y (list int)))
    (= (count x (hsort y)) (count x y))))
(check-sat)
