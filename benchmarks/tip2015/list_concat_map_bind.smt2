; List monad laws
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a b)
    (map2
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (as nil (list b)))
         (case (cons y xs) (cons (@ f y) (map2 f xs)))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a b)
    (>>=
       ((x (list a)) (y (=> a (list b)))) (list b)
       (match x
         (case nil (as nil (list b)))
         (case (cons z xs) (++ (@ y z) (>>= xs y)))))))
(define-fun-rec
  (par (a)
    (concat2
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs) (++ y (concat2 xs)))))))
(assert-not
  (par (a b)
    (forall ((f (=> a (list b))) (xs (list a)))
      (= (concat2 (map2 f xs)) (>>= xs f)))))
(check-sat)
