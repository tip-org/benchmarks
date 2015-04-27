(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(define-funs-rec
  ((par (a)
     (y ((z a) (x2 (list (Pair2 a (list a)))))
        (list (Pair2 a (list a))))))
  ((match x2
     (case nil x2)
     (case (cons x3 x4)
       (match x3
         (case (Pair y2 ys) (cons (Pair y2 (cons z ys)) (y z x4))))))))
(define-funs-rec
  ((par (t t2) (x ((f (=> t2 t)) (z (list t2))) (list t))))
  ((match z
     (case nil (as nil (list t)))
     (case (cons x2 x3) (cons (@ f x2) (x f x3))))))
(define-funs-rec
  ((par (a) (select ((z (list a))) (list (Pair2 a (list a))))))
  ((match z
     (case nil (as nil (list (Pair2 a (list a)))))
     (case (cons x2 xs) (cons (Pair x2 xs) (y x2 (select xs)))))))
(define-funs-rec
  ((par (a b) (fst ((z (Pair2 a b))) a)))
  ((match z (case (Pair x2 x3) x2))))
(assert-not
  (par (t)
    (forall ((xs (list t)))
      (= (x (lambda ((z (Pair2 t (list t)))) (fst z)) (select xs)) xs))))
(check-sat)
