; Rotate expressed using a snoc instead of append
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  snoc
  (par (a) (((x a) (y (list a))) (list a)))
  (match y
    ((nil (cons x (_ nil a)))
     ((cons z ys) (cons z (snoc x ys))))))
(define-fun-rec
  rotate
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    ((zero y)
     ((succ z)
      (match y
        ((nil (_ nil a))
         ((cons z2 xs1) (rotate z (snoc z2 xs1)))))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(prove
  (par (a)
    (forall ((n Nat) (xs (list a)))
      (= (rotate n (++ xs xs)) (++ (rotate n xs) (rotate n xs))))))
