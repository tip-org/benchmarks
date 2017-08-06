(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (select :let
       ((x a) (y (list (pair a (list a))))) (list (pair a (list a)))
       (match y
         (case nil (as nil (list (pair a (list a)))))
         (case (cons z x2)
           (match z
             (case (pair2 y2 ys)
               (cons (pair2 y2 (cons x ys)) (select x x2)))))))))
(define-fun-rec
  (par (a)
    (select2 :source List.select
       ((x (list a))) (list (pair a (list a)))
       (match x
         (case nil (as nil (list (pair a (list a)))))
         (case (cons y xs) (cons (pair2 y xs) (select y (select2 xs))))))))
(define-fun-rec
  (par (a b)
    (map :let :source Prelude.map
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (as nil (list b)))
         (case (cons y xs) (cons (@ f y) (map f xs)))))))
(prove
  :source List.prop_Select
  (par (b)
    (forall ((xs (list b)))
      (=
        (map
          (lambda ((x (pair b (list b)))) (match x (case (pair2 y z) y)))
          (select2 xs))
        xs))))
