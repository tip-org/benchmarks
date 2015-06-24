; Sequences with logarithmic-time lookup.
; An example of non-regular datatypes and polymorphic recursion.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(declare-datatypes (a)
  ((Seq (Nil) (Cons (Cons_0 a) (Cons_1 (Seq (Pair a (Maybe a))))))))
(define-fun
  (par (a b)
    (snd ((x (Pair a b))) b (match x (case (Pair2 y z) z)))))
(define-fun-rec
  (par (a)
    (pair
       ((x (list a))) (list (Pair a (Maybe a)))
       (match x
         (case nil (as nil (list (Pair a (Maybe a)))))
         (case (cons y z)
           (match z
             (case nil
               (cons (Pair2 y (as Nothing (Maybe a)))
                 (as nil (list (Pair a (Maybe a))))))
             (case (cons y2 xs) (cons (Pair2 y (Just y2)) (pair xs)))))))))
(define-fun-rec
  (par (a)
    (lookup
       ((x Int) (y (list a))) (Maybe a)
       (match y
         (case nil (as Nothing (Maybe a)))
         (case (cons z x2) (ite (= x 0) (Just z) (lookup (- x 1) x2)))))))
(define-fun
  (par (a b)
    (fst ((x (Pair a b))) a (match x (case (Pair2 y z) y)))))
(define-fun-rec
  (par (a)
    (index
       ((x Int) (y (Seq a))) (Maybe a)
       (match y
         (case Nil (as Nothing (Maybe a)))
         (case (Cons z x2)
           (ite
             (= x 0) (Just z)
             (ite
               (= (mod x 2) 0)
               (match (index (div (- x 1) 2) x2)
                 (case Nothing (as Nothing (Maybe a)))
                 (case (Just x4) (snd x4)))
               (match (index (div (- x 1) 2) x2)
                 (case Nothing (as Nothing (Maybe a)))
                 (case (Just x3) (Just (fst x3)))))))))))
(define-fun-rec
  (par (a)
    (fromList
       ((x (list a))) (Seq a)
       (match x
         (case nil (as Nil (Seq a)))
         (case (cons y xs) (Cons y (fromList (pair xs))))))))
(assert-not
  (par (a)
    (forall ((n Int) (xs (list a)))
      (=> (>= n 0) (= (lookup n xs) (index n (fromList xs)))))))
(check-sat)
