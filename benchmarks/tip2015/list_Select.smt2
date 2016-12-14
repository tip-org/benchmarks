(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (select2
       ((x a) (y (list (pair a (list a))))) (list (pair a (list a)))
       (match y
         (case nil (as nil (list (pair a (list a)))))
         (case (cons z x2)
           (match z
             (case (pair2 y2 ys)
               (cons (pair2 y2 (cons x ys)) (select2 x x2)))))))))
(define-fun-rec
  (par (a)
    (select3
       ((x (list a))) (list (pair a (list a)))
       (match x
         (case nil (as nil (list (pair a (list a)))))
         (case (cons y xs) (cons (pair2 y xs) (select2 y (select3 xs))))))))
(define-fun-rec
  (par (a b)
    (map2
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (as nil (list b)))
         (case (cons y xs) (cons (@ f y) (map2 f xs)))))))
(assert-not
  (par (b)
    (forall ((xs (list b)))
      (=
        (map2
          (lambda ((x (pair b (list b)))) (match x (case (pair2 y z) y)))
          (select3 xs))
        xs))))
(check-sat)
