(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(define-funs-rec
  ((par (a)
     (select2
        ((x a) (y (list (Pair2 a (list a))))) (list (Pair2 a (list a))))))
  ((match y
     (case nil y)
     (case (cons z x2)
       (match z
         (case (Pair y2 ys)
           (cons (Pair y2 (cons x ys)) (select2 x x2))))))))
(define-funs-rec
  ((par (a) (select ((x (list a))) (list (Pair2 a (list a))))))
  ((match x
     (case nil (as nil (list (Pair2 a (list a)))))
     (case (cons y xs) (cons (Pair y xs) (select2 y (select xs)))))))
(define-funs-rec
  ((par (t t2) (map2 ((f (=> t2 t)) (x (list t2))) (list t))))
  ((match x
     (case nil (as nil (list t)))
     (case (cons y z) (cons (@ f y) (map2 f z))))))
(define-funs-rec
  ((par (a b) (fst ((x (Pair2 a b))) a)))
  ((match x (case (Pair y z) y))))
(assert-not
  (par (t)
    (forall ((xs (list t)))
      (= (map2 (lambda ((x (Pair2 t (list t)))) (fst x)) (select xs))
        xs))))
(check-sat)
