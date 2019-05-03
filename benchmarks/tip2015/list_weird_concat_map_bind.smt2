; List monad laws
;
; Here, weird_concat is a somewhat sensible concatenation function,
; and has a somewhat strange recursion pattern.
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  weird_concat
  (par (a) (((x (list (list a)))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xss)
      (match y
        ((nil (weird_concat xss))
         ((cons z xs) (cons z (weird_concat (cons xs xss))))))))))
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
(prove
  (par (a b)
    (forall ((f (=> a (list b))) (xs (list a)))
      (= (weird_concat (map f xs)) (>>= xs f)))))
