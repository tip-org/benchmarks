(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  interleave
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (interleave y xs))))))
(define-funs-rec
  ((evens
    (par (a) (((x (list a))) (list a))))
   (odds
    (par (a) (((x (list a))) (list a)))))
  ((match x
     ((nil (_ nil a))
      ((cons y xs) (cons y (odds xs)))))
   (match x
     ((nil (_ nil a))
      ((cons y xs) (evens xs))))))
(prove
  (par (a)
    (forall ((xs (list a))) (= (interleave (evens xs) (odds xs)) xs))))
