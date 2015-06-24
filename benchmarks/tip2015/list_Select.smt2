(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-fun-rec
  (par (a)
    (select3
       ((x a) (y (list (Pair a (list a))))) (list (Pair a (list a)))
       (match y
         (case nil (as nil (list (Pair a (list a)))))
         (case (cons z x2)
           (match z
             (case (Pair2 y2 ys)
               (cons (Pair2 y2 (cons x ys)) (select3 x x2)))))))))
(define-fun-rec
  (par (a)
    (select2
       ((x (list a))) (list (Pair a (list a)))
       (match x
         (case nil (as nil (list (Pair a (list a)))))
         (case (cons y xs) (cons (Pair2 y xs) (select3 y (select2 xs))))))))
(define-fun-rec
  (par (t t2)
    (map2
       ((f (=> t2 t)) (x (list t2))) (list t)
       (match x
         (case nil (as nil (list t)))
         (case (cons y z) (cons (@ f y) (map2 f z)))))))
(define-fun
  (par (a b)
    (fst ((x (Pair a b))) a (match x (case (Pair2 y z) y)))))
(assert-not
  (par (t)
    (forall ((xs (list t)))
      (= (map2 (lambda ((x (Pair t (list t)))) (fst x)) (select2 xs))
        xs))))
(check-sat)
