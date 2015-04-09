; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(define-funs-rec
  ((par
     (a2 b2) (zip ((x (list a2)) (x2 (list b2))) (list (Pair a2 b2)))))
  ((match x
     (case nil (as nil (list (Pair a2 b2))))
     (case
       (cons ipv ipv2)
       (match x2
         (case nil (as nil (list (Pair a2 b2))))
         (case
           (cons ipv3 ipv4)
           (cons
             (Pair2 ipv ipv3) (as (zip ipv2 ipv4) (list (Pair a2 b2))))))))))
(assert-not
  (par
    (b3 a3)
    (forall
      ((xs (list b3)))
      (= (zip (as nil (list a3)) xs) (as nil (list (Pair a3 b3)))))))
(check-sat)
