; Bottom-up merge sort
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a b)
    (map2
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (as nil (list b)))
         (case (cons y xs) (cons (@ f y) (map2 f xs)))))))
(define-fun-rec
  (par (a)
    (lmerge
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z x2)
           (match y
             (case nil x)
             (case (cons x3 x4)
               (ite
                 (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))))
(define-fun-rec
  (par (a)
    (pairwise-pairwise1
       ((x (list (list a)))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons xs y)
           (match y
             (case nil (cons xs (as nil (list (list a)))))
             (case (cons ys xss)
               (cons (lmerge xs ys) (pairwise-pairwise1 xss)))))))))
(define-fun-rec
  (par (a)
    (mergingbu
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons xs y)
           (match y
             (case nil xs)
             (case (cons z x2) (mergingbu (pairwise-pairwise1 x)))))))))
(define-fun
  (par (a)
    (msortbu
       ((x (list a))) (list a)
       (mergingbu (map2 (lambda ((y a)) (cons y (as nil (list a)))) x)))))
(define-fun-rec
  (par (a)
    (insert2
       ((x a) (y (list a))) (list a)
       (match y
         (case nil (cons x (as nil (list a))))
         (case (cons z xs)
           (ite (<= x z) (cons x y) (cons z (insert2 x xs))))))))
(define-fun-rec
  (par (a)
    (isort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs) (insert2 y (isort xs)))))))
(assert-not (forall ((x (list Nat))) (= (msortbu x) (isort x))))
(check-sat)
