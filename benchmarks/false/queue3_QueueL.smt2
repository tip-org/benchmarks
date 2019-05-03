(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Q (par (a) ((Q2 (proj1-Q (list a)) (proj2-Q (list a))))))
(declare-datatype
  Maybe (par (a) ((Nothing) (Just (proj1-Just a)))))
(declare-datatype
  E
  (par (a)
    ((Empty) (EnqL (proj1-EnqL a) (proj2-EnqL (E a)))
     (EnqR (proj1-EnqR (E a)) (proj2-EnqR a)) (DeqL (proj1-DeqL (E a)))
     (DeqR (proj1-DeqR (E a)))
     (App (proj1-App (E a)) (proj2-App (E a))))))
(define-fun-rec
  take
  (par (a) (((x Int) (y (list a))) (list a)))
  (ite
    (<= x 0) (_ nil a)
    (match y
      ((nil (_ nil a))
       ((cons z xs) (cons z (take (- x 1) xs)))))))
(define-fun
  tail2
  (par (a) (((x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) xs))))
(define-fun-rec
  length
  (par (a) (((x (list a))) Int))
  (match x
    ((nil 0)
     ((cons y l) (+ 1 (length l))))))
(define-fun-rec
  init
  (par (a) (((x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y z)
      (match z
        ((nil (_ nil a))
         ((cons x2 x3) (cons y (init z)))))))))
(define-fun
  fstL
  (par (a) (((x (Q a))) (Maybe a)))
  (match x
    (((Q2 y z)
      (match y
        ((nil
          (match z
            ((nil (_ Nothing a))
             ((cons y2 x2)
              (match x2
                ((nil (Just y2))
                 ((cons x3 x4) (_ Nothing a))))))))
         ((cons x5 x6) (Just x5))))))))
(define-fun
  fromMaybe
  (par (p) (((x p) (y (Maybe p))) p))
  (match y
    ((Nothing x)
     ((Just z) z))))
(define-fun
  empty
  (par (a) (() (Q a))) (Q2 (_ nil a) (_ nil a)))
(define-fun-rec
  drop
  (par (a) (((x Int) (y (list a))) (list a)))
  (ite
    (<= x 0) y
    (match y
      ((nil (_ nil a))
       ((cons z xs1) (drop (- x 1) xs1))))))
(define-fun
  halve
  (par (a) (((x (list a))) (pair (list a) (list a))))
  (let ((k (div (length x) 2))) (pair2 (take k x) (drop k x))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  list2
  (par (a) (((x (E a))) (list a)))
  (match x
    ((Empty (_ nil a))
     ((EnqL y e) (cons y (list2 e)))
     ((EnqR e2 z) (++ (list2 e2) (cons z (_ nil a))))
     ((DeqL e3) (tail2 (list2 e3)))
     ((DeqR e4) (init (list2 e4)))
     ((App a1 b2) (++ (list2 a1) (list2 b2))))))
(define-fun-rec
  reverse
  (par (a) (((x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (++ (reverse xs) (cons y (_ nil a)))))))
(define-fun
  +++
  (par (a) (((x (Q a)) (y (Q a))) (Q a)))
  (match x
    (((Q2 xs ys)
      (match y
        (((Q2 vs ws) (Q2 (++ xs (reverse ys)) (++ ws (reverse vs))))))))))
(define-fun
  enqL
  (par (a) (((x a) (y (Q a))) (Q a)))
  (match y
    (((Q2 xs ys)
      (match ys
        ((nil
          (match (halve (cons x xs))
            (((pair2 as1 bs) (Q2 as1 (reverse bs))))))
         ((cons z x2) (Q2 (cons x xs) ys))))))))
(define-fun
  mkQ
  (par (a) (((x (list a)) (y (list a))) (Q a)))
  (match x
    ((nil (match (halve y) (((pair2 as1 bs1) (Q2 (reverse bs1) as1)))))
     ((cons z x2)
      (match y
        ((nil (match (halve x) (((pair2 as12 bs) (Q2 as12 (reverse bs))))))
         ((cons x3 x4) (Q2 x y))))))))
(define-fun
  deqL
  (par (a) (((x (Q a))) (Maybe (Q a))))
  (match x
    (((Q2 y z)
      (match y
        ((nil
          (match z
            ((nil (_ Nothing (Q a)))
             ((cons x2 x3)
              (match x3
                ((nil (Just (_ empty a)))
                 ((cons x4 x5) (_ Nothing (Q a)))))))))
         ((cons x6 xs) (Just (mkQ xs z)))))))))
(define-fun
  deqR
  (par (a) (((x (Q a))) (Maybe (Q a))))
  (match x
    (((Q2 y z)
      (let
        ((fail
            (match z
              ((nil (_ Nothing (Q a)))
               ((cons y2 ys) (Just (mkQ y ys)))))))
        (match y
          ((nil fail)
           ((cons x2 x3)
            (match x3
              ((nil
                (match z
                  ((nil (Just (_ empty a)))
                   ((cons x4 x5) fail))))
               ((cons x6 x7) fail)))))))))))
(define-fun
  enqR
  (par (a) (((x (Q a)) (y a)) (Q a)))
  (match x (((Q2 xs ys) (mkQ xs (cons y ys))))))
(define-fun-rec
  queue
  (par (a) (((x (E a))) (Q a)))
  (match x
    ((Empty (_ empty a))
     ((EnqL y e) (enqL y (queue e)))
     ((EnqR e2 z) (enqR (queue e2) z))
     ((DeqL e3) (let ((q (queue e3))) (fromMaybe q (deqL q))))
     ((DeqR e4) (let ((r (queue e4))) (fromMaybe r (deqR r))))
     ((App a1 b2) (+++ (queue a1) (queue b2))))))
(prove
  (par (a)
    (forall ((e (E a)))
      (= (fstL (queue e))
        (match (list2 e)
          ((nil (_ Nothing a))
           ((cons x y) (Just x))))))))
