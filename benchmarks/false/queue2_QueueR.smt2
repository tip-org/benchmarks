(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Q :source Queue.Q
     (Q2 :source Queue.Q (proj1-Q (list a)) (proj2-Q (list a))))))
(declare-datatypes (a)
  ((Maybe :source Prelude.Maybe (Nothing :source Prelude.Nothing)
     (Just :source Prelude.Just (proj1-Just a)))))
(declare-datatypes (a)
  ((E :source Queue.E (Empty :source Queue.Empty)
     (EnqL :source Queue.EnqL (proj1-EnqL a) (proj2-EnqL (E a)))
     (EnqR :source Queue.EnqR (proj1-EnqR (E a)) (proj2-EnqR a))
     (DeqL :source Queue.DeqL (proj1-DeqL (E a)))
     (DeqR :source Queue.DeqR (proj1-DeqR (E a)))
     (App :source Queue.App (proj1-App (E a)) (proj2-App (E a))))))
(define-fun-rec
  (par (a)
    (take :source Prelude.take
       ((x Int) (y (list a))) (list a)
       (ite
         (<= x 0) (_ nil a)
         (match y
           (case nil (_ nil a))
           (case (cons z xs) (cons z (take (- x 1) xs))))))))
(define-fun
  (par (a)
    (tail2 :source Queue.tail
       ((x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs) xs)))))
(define-fun-rec
  (par (a)
    (length :source Prelude.length
       ((x (list a))) Int
       (match x
         (case nil 0)
         (case (cons y l) (+ 1 (length l)))))))
(define-fun-rec
  (par (a)
    (last :source Queue.last
       ((x (list a))) (Maybe a)
       (match x
         (case nil (_ Nothing a))
         (case (cons y z)
           (match z
             (case nil (Just y))
             (case (cons x2 x3) (last z))))))))
(define-fun-rec
  (par (a)
    (init :source Queue.init
       ((x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y z)
           (match z
             (case nil (_ nil a))
             (case (cons x2 x3) (cons y (init z)))))))))
(define-fun
  (par (a)
    (fstR :source Queue.fstR
       ((x (Q a))) (Maybe a)
       (match x
         (case (Q2 y z)
           (let
             ((fail
                 (match z
                   (case nil (_ Nothing a))
                   (case (cons y2 x2) (Just y2)))))
             (match y
               (case nil fail)
               (case (cons x3 x4)
                 (match x4
                   (case nil
                     (match z
                       (case nil (Just x3))
                       (case (cons x5 x6) fail)))
                   (case (cons x7 x8) fail))))))))))
(define-fun
  (par (p)
    (fromMaybe :source Queue.fromMaybe
       ((x p) (y (Maybe p))) p
       (match y
         (case Nothing x)
         (case (Just z) z)))))
(define-fun
  (par (a)
    (empty :source Queue.empty () (Q a) (Q2 (_ nil a) (_ nil a)))))
(define-fun-rec
  (par (a)
    (drop :source Prelude.drop
       ((x Int) (y (list a))) (list a)
       (ite
         (<= x 0) y
         (match y
           (case nil (_ nil a))
           (case (cons z xs1) (drop (- x 1) xs1)))))))
(define-fun
  (par (a)
    (halve :source Queue.halve
       ((x (list a))) (pair (list a) (list a))
       (let ((k (div (length x) 2))) (pair2 (take k x) (drop k x))))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (list2 :source Queue.list
       ((x (E a))) (list a)
       (match x
         (case Empty (_ nil a))
         (case (EnqL y e) (cons y (list2 e)))
         (case (EnqR e2 z) (++ (list2 e2) (cons z (_ nil a))))
         (case (DeqL e3) (tail2 (list2 e3)))
         (case (DeqR e4) (init (list2 e4)))
         (case (App a1 b2) (++ (list2 a1) (list2 b2)))))))
(define-fun-rec
  (par (a)
    (reverse :let :source Prelude.reverse
       ((x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs) (++ (reverse xs) (cons y (_ nil a))))))))
(define-fun
  (par (a)
    (enqL :source Queue.enqL
       ((x a) (y (Q a))) (Q a)
       (match y
         (case (Q2 xs ys)
           (match ys
             (case nil
               (match (halve (cons x xs))
                 (case (pair2 as1 bs) (Q2 as1 (reverse bs)))))
             (case (cons z x2) (Q2 (cons x xs) ys))))))))
(define-fun
  (par (a)
    (mkQ :source Queue.mkQ
       ((x (list a)) (y (list a))) (Q a)
       (match x
         (case nil
           (match (halve y) (case (pair2 as1 bs1) (Q2 (reverse bs1) as1))))
         (case (cons z x2)
           (match y
             (case nil
               (match (halve x) (case (pair2 as12 bs) (Q2 as12 (reverse bs)))))
             (case (cons x3 x4) (Q2 x y))))))))
(define-fun
  (par (a)
    (+++ :source Queue.+++
       ((x (Q a)) (y (Q a))) (Q a)
       (match x
         (case (Q2 xs ys)
           (match y
             (case (Q2 vs ws)
               (mkQ (++ xs (reverse ys)) (++ (reverse vs) ws)))))))))
(define-fun
  (par (a)
    (deqL :source Queue.deqL
       ((x (Q a))) (Maybe (Q a))
       (match x
         (case (Q2 y z)
           (match y
             (case nil
               (match z
                 (case nil (_ Nothing (Q a)))
                 (case (cons x2 x3)
                   (match x3
                     (case nil (Just (_ empty a)))
                     (case (cons x4 x5) (_ Nothing (Q a)))))))
             (case (cons x6 xs) (Just (mkQ xs z)))))))))
(define-fun
  (par (a)
    (deqR :source Queue.deqR
       ((x (Q a))) (Maybe (Q a))
       (match x
         (case (Q2 y z)
           (let
             ((fail
                 (match z
                   (case nil (_ Nothing (Q a)))
                   (case (cons y2 ys) (Just (mkQ y ys))))))
             (match y
               (case nil fail)
               (case (cons x2 x3)
                 (match x3
                   (case nil
                     (match z
                       (case nil (Just (_ empty a)))
                       (case (cons x4 x5) fail)))
                   (case (cons x6 x7) fail))))))))))
(define-fun
  (par (a)
    (enqR :source Queue.enqR
       ((x (Q a)) (y a)) (Q a)
       (match x (case (Q2 xs ys) (mkQ xs (cons y ys)))))))
(define-fun-rec
  (par (a)
    (queue :source Queue.queue
       ((x (E a))) (Q a)
       (match x
         (case Empty (_ empty a))
         (case (EnqL y e) (enqL y (queue e)))
         (case (EnqR e2 z) (enqR (queue e2) z))
         (case (DeqL e3) (let ((q (queue e3))) (fromMaybe q (deqL q))))
         (case (DeqR e4) (let ((r (queue e4))) (fromMaybe r (deqR r))))
         (case (App a1 b2) (+++ (queue a1) (queue b2)))))))
(prove
  :source Queue.prop_QueueR
  (par (a)
    (forall ((e (E a))) (= (fstR (queue e)) (last (list2 e))))))
