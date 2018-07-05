; List monad laws
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun (par (a) (return ((x a)) (list a) (cons x (_ nil a)))))
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
         (case nil (_ nil b))
         (case (cons z xs) (++ (@ y z) (>>= xs y)))))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (= (>>= xs (lambda ((x a)) (return x))) xs))))
