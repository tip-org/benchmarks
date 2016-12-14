(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree
     (Node (proj1-Node (Tree a)) (proj2-Node a) (proj3-Node (Tree a)))
     (Nil))))
(define-fun-rec
  (par (a)
    (flatten1
       ((x (list (Tree a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y ps)
           (match y
             (case (Node z x2 q)
               (match z
                 (case (Node x3 x4 x5)
                   (flatten1 (cons z (cons (Node (as Nil (Tree a)) x2 q) ps))))
                 (case Nil (cons x2 (flatten1 (cons q ps))))))
             (case Nil (flatten1 ps))))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a b)
    (concatMap
       ((f (=> a (list b))) (x (list a))) (list b)
       (match x
         (case nil (as nil (list b)))
         (case (cons y xs) (++ (@ f y) (concatMap f xs)))))))
(define-fun-rec
  (par (a)
    (flatten0
       ((x (Tree a))) (list a)
       (match x
         (case (Node p y q)
           (++ (flatten0 p) (++ (cons y (as nil (list a))) (flatten0 q))))
         (case Nil (as nil (list a)))))))
(assert-not
  (par (b)
    (forall ((ps (list (Tree b))))
      (= (flatten1 ps)
        (concatMap (lambda ((x (Tree b))) (flatten0 x)) ps)))))
(check-sat)
