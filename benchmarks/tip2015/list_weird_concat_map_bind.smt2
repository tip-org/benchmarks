; List monad laws
;
; Here, weird_concat is a somewhat sensible concatenation function,
; and has a somewhat strange recursion pattern.
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (weird_concat :source ListMonad.weird_concat
       ((x (list (list a)))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xss)
           (match y
             (case nil (weird_concat xss))
             (case (cons z xs) (cons z (weird_concat (cons xs xss))))))))))
(define-fun-rec
  (par (a b)
    (map :let :source Prelude.map
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (_ nil b))
         (case (cons y xs) (cons (@ f y) (map f xs)))))))
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
  :source ListMonad.prop_weird_concat_map_bind
  (par (a b)
    (forall ((f (=> a (list b))) (xs (list a)))
      (= (weird_concat (map f xs)) (>>= xs f)))))
