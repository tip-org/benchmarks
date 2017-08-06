; List monad laws
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun
  (par (a)
    (return :source ListMonad.return
       ((x a)) (list a) (cons x (_ nil a)))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a b)
    (>>= :source ListMonad.>>=
       ((x (list a)) (y (=> a (list b)))) (list b)
       (match x
         (case nil (_ nil b))
         (case (cons z xs) (++ (@ y z) (>>= xs y)))))))
(prove
  :source ListMonad.prop_return_2
  (par (a)
    (forall ((xs (list a)))
      (= (>>= xs (lambda ((x a)) (return x))) xs))))
