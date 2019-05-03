; List monad laws
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  map
  (par (a b) (((f (=> a b)) (x (list a))) (list b)))
  (match x
    ((nil (_ nil b))
     ((cons y xs) (cons (@ f y) (map f xs))))))
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
(define-fun-rec
  concat
  (par (a) (((x (list (list a)))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (++ y (concat xs))))))
(prove
  (par (a b)
    (forall ((f (=> a (list b))) (xs (list a)))
      (= (concat (map f xs)) (>>= xs f)))))
