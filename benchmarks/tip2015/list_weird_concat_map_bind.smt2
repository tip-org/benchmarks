; List monad laws
;
; Here, weird_concat is a somewhat sensible concatenation function,
; and has a somewhat strange recursion pattern.
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (weird_concat
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xss)
           (match y
             (case nil (weird_concat xss))
             (case (cons z xs) (cons z (weird_concat (cons xs xss))))))))))
(define-fun-rec
  (par (a b)
    (map2
       ((x (=> a b)) (y (list a))) (list b)
       (match y
         (case nil (as nil (list b)))
         (case (cons z xs) (cons (@ x z) (map2 x xs)))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  (par (a b)
    (bind
       ((x (list a)) (y (=> a (list b)))) (list b)
       (match x
         (case nil (as nil (list b)))
         (case (cons z xs) (append (@ y z) (bind xs y)))))))
(assert-not
  (par (a b)
    (forall ((f (=> a (list b))) (xs (list a)))
      (= (weird_concat (map2 f xs)) (bind xs f)))))
(check-sat)
