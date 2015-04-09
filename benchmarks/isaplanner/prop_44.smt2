; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-funs-rec
  ((par
     (a3 b3) (zip ((x4 (list a3)) (x5 (list b3))) (list (Pair a3 b3)))))
  ((match x4
     (case nil (as nil (list (Pair a3 b3))))
     (case
       (cons ipv ipv2)
       (match x5
         (case nil (as nil (list (Pair a3 b3))))
         (case
           (cons ipv3 ipv4)
           (cons
             (Pair2 ipv ipv3) (as (zip ipv2 ipv4) (list (Pair a3 b3))))))))))
(define-funs-rec
  ((par
     (a2 b2)
     (zipConcat
        ((x a2) (x2 (list a2)) (x3 (list b2))) (list (Pair a2 b2)))))
  ((match x3
     (case nil (as nil (list (Pair a2 b2))))
     (case (cons y ys) (cons (Pair2 x y) (zip x2 ys))))))
(assert-not
  (par
    (a4 b4)
    (forall
      ((x6 a4) (xs (list a4)) (ys2 (list b4)))
      (= (zip (cons x6 xs) ys2) (zipConcat x6 xs ys2)))))
(check-sat)
