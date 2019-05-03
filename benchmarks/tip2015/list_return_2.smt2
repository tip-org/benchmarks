; List monad laws
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun
  return
  (par (a) (((x a)) (list a))) (cons x (_ nil a)))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  >>=
  (par (a b) (((x (list a)) (y (=> a (list b)))) (list b)))
  (match x
    ((nil (_ nil b))
     ((cons z xs) (++ (@ y z) (>>= xs y))))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (= (>>= xs (lambda ((x a)) (return x))) xs))))
