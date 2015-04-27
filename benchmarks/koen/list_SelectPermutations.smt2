(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(define-funs-rec
  ((y ((z (list (Pair2 int (list int))))) (list (list int))))
  ((match z
     (case nil (as nil (list (list int))))
     (case (cons x2 x3)
       (match x2 (case (Pair y2 ys) (cons (cons y2 ys) (y x3))))))))
(define-funs-rec
  ((par (a)
     (x ((z a) (x2 (list (Pair2 a (list a)))))
        (list (Pair2 a (list a))))))
  ((match x2
     (case nil x2)
     (case (cons x3 x4)
       (match x3
         (case (Pair y2 ys) (cons (Pair y2 (cons z ys)) (x z x4))))))))
(define-funs-rec
  ((par (a) (select ((z (list a))) (list (Pair2 a (list a))))))
  ((match z
     (case nil (as nil (list (Pair2 a (list a)))))
     (case (cons x2 xs) (cons (Pair x2 xs) (x x2 (select xs)))))))
(define-funs-rec
  ((or2 ((z bool) (x2 bool)) bool)) ((ite z true x2)))
(define-funs-rec
  ((par (t) (null ((z (list t))) bool)))
  ((match z
     (case nil true)
     (case (cons x2 x3) false))))
(define-funs-rec
  ((elem ((z int) (x2 (list int))) bool))
  ((match x2
     (case nil false)
     (case (cons y2 ys) (or2 (= z y2) (elem z ys))))))
(define-funs-rec
  ((delete ((z int) (x2 (list int))) (list int)))
  ((match x2
     (case nil x2)
     (case (cons y2 ys) (ite (= z y2) ys (cons y2 (delete z ys)))))))
(define-funs-rec
  ((and2 ((z bool) (x2 bool)) bool)) ((ite z x2 false)))
(define-funs-rec
  ((isPermutation ((z (list int)) (x2 (list int))) bool))
  ((match z
     (case nil (null x2))
     (case (cons x3 xs)
       (and2 (elem x3 x2) (isPermutation xs (delete x3 x2)))))))
(define-funs-rec
  ((par (t) (all ((z (=> t bool)) (x2 (list t))) bool)))
  ((match x2
     (case nil true)
     (case (cons x3 xs) (and2 (@ z x3) (all z xs))))))
(assert-not
  (forall ((xs (list int)))
    (all (lambda ((z (list int))) (isPermutation z xs))
      (y (select xs)))))
(check-sat)
