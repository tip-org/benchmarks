(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(define-fun-rec
  !!
  (par (a) (((x (list a)) (y Nat)) a))
  (match x
    (((cons z x2)
      (match y
        ((zero z)
         ((succ x3) (!! x2 x3))))))))
(prove
  (par (a)
    (forall ((x a) (xs (list a)))
      (=> (elem x xs) (exists ((y Nat)) (= x (!! xs y)))))))
