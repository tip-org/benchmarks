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
  (par (a b)
    (map2
       ((x (=> a b)) (y (list a))) (list b)
       (match y
         (case nil (as nil (list b)))
         (case (cons z xs) (cons (@ x z) (map2 x xs)))))))
(define-fun
  (par (a b)
    (fst ((x (Pair a b))) a (match x (case (Pair2 y z) y)))))
(assert-not
  (par (b)
    (forall ((xs (list b)))
      (= (map2 (lambda ((x (Pair b (list b)))) (fst x)) (select2 xs))
        xs))))
(check-sat)
