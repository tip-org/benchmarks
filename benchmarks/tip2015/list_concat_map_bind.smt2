; List monad laws
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a b)
    (map :let :source Prelude.map
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (as nil (list b)))
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
         (case nil (as nil (list b)))
         (case (cons z xs) (++ (@ y z) (>>= xs y)))))))
(define-fun-rec
  (par (a)
    (concat :let :source Prelude.concat
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y xs) (++ y (concat xs)))))))
(prove
  :source ListMonad.prop_concat_map_bind
  (par (a b)
    (forall ((f (=> a (list b))) (xs (list a)))
      (= (concat (map f xs)) (>>= xs f)))))
