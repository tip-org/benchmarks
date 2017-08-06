(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (t)
    (pairs :source List.pairs
       ((x (list t))) (list (pair t t))
       (match x
         (case nil (_ nil (pair t t)))
         (case (cons y z)
           (match z
             (case nil (_ nil (pair t t)))
             (case (cons y2 xs) (cons (pair2 y y2) (pairs xs)))))))))
(define-fun-rec
  (par (a b)
    (map :let :source Prelude.map
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (_ nil b))
         (case (cons y xs) (cons (@ f y) (map f xs)))))))
(define-funs-rec
  ((par (a) (evens :source List.evens ((x (list a))) (list a)))
   (par (a) (odds :source List.odds ((x (list a))) (list a))))
  ((match x
     (case nil (_ nil a))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (_ nil a))
     (case (cons y xs) (evens xs)))))
(prove
  :source List.prop_PairOdds
  (par (a)
    (forall ((xs (list a)))
      (=
        (map (lambda ((x (pair a a))) (match x (case (pair2 y z) z)))
          (pairs xs))
        (odds xs)))))
