; List monad laws
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
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
(assert-not
  (par (a b)
    (forall ((x a) (f (=> a (list b))))
      (= (>>= (cons x (as nil (list a))) f) (@ f x)))))
(check-sat)
