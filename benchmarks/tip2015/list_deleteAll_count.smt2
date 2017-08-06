(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (deleteBy :source Data.List.deleteBy
       ((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)
       (match z
         (case nil (_ nil a))
         (case (cons y2 ys)
           (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys))))))))
(define-fun-rec
  (par (a)
    (deleteAll :source SortUtils.deleteAll
       ((x a) (y (list a))) (list a)
       (match y
         (case nil (_ nil a))
         (case (cons z ys)
           (ite (= x z) (deleteAll x ys) (cons z (deleteAll x ys))))))))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Int
       (match y
         (case nil 0)
         (case (cons z ys)
           (ite (= x z) (+ 1 (count x ys)) (count x ys)))))))
(prove
  :source List.prop_deleteAll_count
  (par (a)
    (forall ((x a) (xs (list a)))
      (=>
        (= (deleteAll x xs)
          (deleteBy (lambda ((y a)) (lambda ((z a)) (= y z))) x xs))
        (<= (count x xs) 1)))))
