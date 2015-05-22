(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (Node (Node_0 (Tree a)) (Node_1 a) (Node_2 (Tree a)))
     (Nil))))
(define-funs-rec
  ((swap ((x Int) (y Int) (z (Tree Int))) (Tree Int)))
  ((match z
     (case (Node p x2 q)
       (ite
         (= x2 x) (Node (swap x y p) y (swap x y q))
         (ite
           (= x2 y) (Node (swap x y p) x (swap x y q))
           (Node (swap x y p) x2 (swap x y q)))))
     (case Nil (as Nil (Tree Int))))))
(define-funs-rec ((or2 ((x Bool) (y Bool)) Bool)) ((ite x true y)))
(define-funs-rec
  ((elem ((x Int) (y (list Int))) Bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (= x z) (elem x ys))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((par (a) (flatten0 ((x (Tree a))) (list a))))
  ((match x
     (case (Node p y q)
       (append (append (flatten0 p) (cons y (as nil (list a))))
         (flatten0 q)))
     (case Nil (as nil (list a))))))
(assert-not
  (forall ((p (Tree Int)) (a Int) (b Int))
    (=> (elem a (flatten0 p))
      (=> (elem b (flatten0 p))
        (and (elem a (flatten0 (swap a b p)))
          (elem b (flatten0 (swap a b p))))))))
(check-sat)
