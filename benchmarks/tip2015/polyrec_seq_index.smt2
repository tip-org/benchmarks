; Sequences with logarithmic-time lookup.
; An example of non-regular datatypes and polymorphic recursion.
(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Maybe (par (a) ((Nothing) (Just (proj1-Just a)))))
(declare-datatype
  Seq
  (par (a)
    ((Nil)
     (Cons (proj1-Cons a) (proj2-Cons (Seq (pair a (Maybe a))))))))
(define-fun-rec
  pair3
  (par (a) (((x (list a))) (list (pair a (Maybe a)))))
  (match x
    ((nil (_ nil (pair a (Maybe a))))
     ((cons y z)
      (match z
        ((nil (cons (pair2 y (_ Nothing a)) (_ nil (pair a (Maybe a)))))
         ((cons y2 xs) (cons (pair2 y (Just y2)) (pair3 xs)))))))))
(define-fun-rec
  lookup
  (par (a) (((x Int) (y (list a))) (Maybe a)))
  (match y
    ((nil (_ Nothing a))
     ((cons z x2) (ite (= x 0) (Just z) (lookup (- x 1) x2))))))
(define-fun-rec
  index
  (par (a) (((x Int) (y (Seq a))) (Maybe a)))
  (match y
    ((Nil (_ Nothing a))
     ((Cons z x2)
      (ite
        (= x 0) (Just z)
        (ite
          (= (mod x 2) 0)
          (match (index (div (- x 1) 2) x2)
            ((Nothing (_ Nothing a))
             ((Just x5) (match x5 (((pair2 x6 y3) y3))))))
          (match (index (div (- x 1) 2) x2)
            ((Nothing (_ Nothing a))
             ((Just x3) (match x3 (((pair2 x4 y2) (Just x4)))))))))))))
(define-fun-rec
  fromList
  (par (a) (((x (list a))) (Seq a)))
  (match x
    ((nil (_ Nil a))
     ((cons y xs) (Cons y (fromList (pair3 xs)))))))
(define-fun
  =<<<
  (par (a b) (((x (=> a (Maybe b))) (y (Maybe a))) (Maybe b)))
  (match y
    ((Nothing (_ Nothing b))
     ((Just z) (@ x z)))))
(define-fun
  <$$>
  (par (a b) (((x (=> a b)) (y (Maybe a))) (Maybe b)))
  (match y
    ((Nothing (_ Nothing b))
     ((Just z) (Just (@ x z))))))
(prove
  (par (a)
    (forall ((n Int) (xs (list a)))
      (=> (>= n 0) (= (lookup n xs) (index n (fromList xs)))))))
