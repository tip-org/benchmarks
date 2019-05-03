(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  deleteBy
  (par (a) (((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)))
  (match z
    ((nil (_ nil a))
     ((cons y2 ys)
      (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys)))))))
(define-fun-rec
  deleteAll
  (par (a) (((x a) (y (list a))) (list a)))
  (match y
    ((nil (_ nil a))
     ((cons z ys)
      (ite (= x z) (deleteAll x ys) (cons z (deleteAll x ys)))))))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Int))
  (match y
    ((nil 0)
     ((cons z ys) (ite (= x z) (+ 1 (count x ys)) (count x ys))))))
(prove
  (par (a)
    (forall ((x a) (xs (list a)))
      (=>
        (= (deleteAll x xs)
          (deleteBy (lambda ((y a)) (lambda ((z a)) (= y z))) x xs))
        (<= (count x xs) 1)))))
