; List monad laws
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
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
         (case nil (as nil (list b)))
         (case (cons z xs) (++ (@ y z) (>>= xs y)))))))
(prove
  :source ListMonad.prop_assoc
  (par (a b c)
    (forall ((m (list a)) (f (=> a (list b))) (g (=> b (list c))))
      (= (>>= (>>= m f) g) (>>= m (lambda ((x a)) (>>= (@ f x) g)))))))
