; List monad laws
;
; Here, weird_concat is a somewhat sensible concatenation function,
; and has a somewhat strange recursion pattern.
(declare-sort Any 0)
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
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (concat2
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs) (++ y (concat2 xs)))))))
(assert-not
  (par (a)
    (forall ((x (list (list Any)))) (= (concat2 x) (weird_concat x)))))
(check-sat)
