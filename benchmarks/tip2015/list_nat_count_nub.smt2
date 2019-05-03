(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  plus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero y)
     ((succ z) (succ (plus z y))))))
(define-fun-rec
  filter
  (par (a) (((q (=> a Bool)) (x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (ite (@ q y) (cons y (filter q xs)) (filter q xs))))))
(define-fun-rec
  nubBy
  (par (a) (((x (=> a (=> a Bool))) (y (list a))) (list a)))
  (match y
    ((nil (_ nil a))
     ((cons z xs)
      (cons z
        (nubBy x (filter (lambda ((y2 a)) (not (@ (@ x z) y2))) xs)))))))
(define-fun-rec
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Nat))
  (match y
    ((nil zero)
     ((cons z ys)
      (ite (= x z) (plus (succ zero) (count x ys)) (count x ys))))))
(prove
  (par (a)
    (forall ((x a) (xs (list a)))
      (=> (elem x xs)
        (= (count x (nubBy (lambda ((y a)) (lambda ((z a)) (= y z))) xs))
          (succ zero))))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
