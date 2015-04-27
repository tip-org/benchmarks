; Heap sort (using skew heaps)
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Heap (Node (Node_0 (Heap a)) (Node_1 a) (Node_2 (Heap a)))
     (Nil))))
(define-funs-rec
  ((x ((y (list int))) (list (Heap int))))
  ((match y
     (case nil (as nil (list (Heap int))))
     (case (cons z x2)
       (cons (Node (as Nil (Heap int)) z (as Nil (Heap int))) (x x2))))))
(define-funs-rec
  ((hmerge ((y (Heap int)) (z (Heap int))) (Heap int)))
  ((match y
     (case (Node x2 x3 x4)
       (match z
         (case (Node x5 x6 x7)
           (ite
             (<= x3 x6) (Node (hmerge x4 z) x3 x2) (Node (hmerge y x7) x6 x5)))
         (case Nil y)))
     (case Nil z))))
(define-funs-rec
  ((hpairwise ((y (list (Heap int)))) (list (Heap int))))
  ((match y
     (case nil y)
     (case (cons p z)
       (match z
         (case nil y)
         (case (cons q qs) (cons (hmerge p q) (hpairwise qs))))))))
(define-funs-rec
  ((hmerging ((y (list (Heap int)))) (Heap int)))
  ((match y
     (case nil (as Nil (Heap int)))
     (case (cons p z)
       (match z
         (case nil p)
         (case (cons x2 x3) (hmerging (hpairwise y))))))))
(define-funs-rec
  ((toHeap ((y (list int))) (Heap int))) ((hmerging (x y))))
(define-funs-rec
  ((toList ((y (Heap int))) (list int)))
  ((match y
     (case (Node p z q) (cons z (toList (hmerge p q))))
     (case Nil (as nil (list int))))))
(define-funs-rec
  ((par (b c a) (dot ((y (=> b c)) (z (=> a b)) (x2 a)) c)))
  ((@ y (@ z x2))))
(define-funs-rec
  ((hsort ((y (list int))) (list int)))
  ((dot (lambda ((z (Heap int))) (toList z))
     (lambda ((x2 (list int))) (toHeap x2)) y)))
(define-funs-rec
  ((and2 ((y bool) (z bool)) bool)) ((ite y z false)))
(define-funs-rec
  ((ordered ((y (list int))) bool))
  ((match y
     (case nil true)
     (case (cons z x2)
       (match x2
         (case nil true)
         (case (cons y2 xs) (and2 (<= z y2) (ordered x2))))))))
(assert-not (forall ((y (list int))) (ordered (hsort y))))
(check-sat)
