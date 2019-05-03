(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  select
  (par (a)
    (((x a) (y (list (pair a (list a))))) (list (pair a (list a)))))
  (match y
    ((nil (_ nil (pair a (list a))))
     ((cons z x2)
      (match z
        (((pair2 y2 ys) (cons (pair2 y2 (cons x ys)) (select x x2)))))))))
(define-fun-rec
  select2
  (par (a) (((x (list a))) (list (pair a (list a)))))
  (match x
    ((nil (_ nil (pair a (list a))))
     ((cons y xs) (cons (pair2 y xs) (select y (select2 xs)))))))
(define-fun-rec
  map
  (par (a b) (((f (=> a b)) (x (list a))) (list b)))
  (match x
    ((nil (_ nil b))
     ((cons y xs) (cons (@ f y) (map f xs))))))
(prove
  (par (b)
    (forall ((xs (list b)))
      (=
        (map (lambda ((x (pair b (list b)))) (match x (((pair2 y z) y))))
          (select2 xs))
        xs))))
