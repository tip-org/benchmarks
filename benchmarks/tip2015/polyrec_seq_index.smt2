; Sequences with logarithmic-time lookup.
; An example of non-regular datatypes and polymorphic recursion.
(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (proj1-Just a)))))
(declare-datatypes (a)
  ((Seq (Nil)
     (Cons (proj1-Cons a) (proj2-Cons (Seq (pair a (Maybe a))))))))
(define-fun-rec
  (par (a)
    (pair3
       ((x (list a))) (list (pair a (Maybe a)))
       (match x
         (case nil (as nil (list (pair a (Maybe a)))))
         (case (cons y z)
           (match z
             (case nil
               (cons (pair2 y (as Nothing (Maybe a)))
                 (as nil (list (pair a (Maybe a))))))
             (case (cons y2 xs) (cons (pair2 y (Just y2)) (pair3 xs)))))))))
(define-fun-rec
  (par (a)
    (lookup
       ((x Int) (y (list a))) (Maybe a)
       (match y
         (case nil (as Nothing (Maybe a)))
         (case (cons z x2) (ite (= x 0) (Just z) (lookup (- x 1) x2)))))))
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
                 (case (Just x5) (match x5 (case (pair2 x6 y3) y3))))
               (match (index (div (- x 1) 2) x2)
                 (case Nothing (as Nothing (Maybe a)))
                 (case (Just x3) (match x3 (case (pair2 x4 y2) (Just x4))))))))))))
(define-fun-rec
  (par (a)
    (fromList
       ((x (list a))) (Seq a)
       (match x
         (case nil (as Nil (Seq a)))
         (case (cons y xs) (Cons y (fromList (pair3 xs))))))))
(define-fun
  (par (a b)
    (=<<<
       ((x (=> a (Maybe b))) (y (Maybe a))) (Maybe b)
       (match y
         (case Nothing (as Nothing (Maybe b)))
         (case (Just z) (@ x z))))))
(define-fun
  (par (a b)
    (<$$>
       ((x (=> a b)) (y (Maybe a))) (Maybe b)
       (match y
         (case Nothing (as Nothing (Maybe b)))
         (case (Just z) (Just (@ x z)))))))
(assert-not
  (par (a)
    (forall ((n Int) (xs (list a)))
      (=> (>= n 0) (= (lookup n xs) (index n (fromList xs)))))))
(check-sat)
