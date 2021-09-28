; Top-down merge sort, using division by two on natural numbers
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((zero) (succ (p Nat))))
(define-fun-rec
  take
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    ((zero (_ nil a))
     ((succ z)
      (match y
        ((nil (_ nil a))
         ((cons z2 xs) (cons z2 (take z xs)))))))))
(define-fun-rec
  plus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero y)
     ((succ z) (succ (plus z y))))))
(define-fun-rec
  minus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero zero)
     ((succ z)
      (match y
        (((succ y2) (minus z y2))
         (zero zero)))))))
(define-fun-rec
  nmsorttd-half1
  ((x Nat)) Nat
  (match x
    ((zero zero)
     ((succ y)
      (ite
        (= y zero) zero
        (plus (succ zero)
          (nmsorttd-half1 (minus x (succ (succ zero))))))))))
(define-fun-rec
  leq
  ((x Nat) (y Nat)) Bool
  (match x
    ((zero true)
     ((succ z)
      (match y
        ((zero false)
         ((succ x2) (leq z x2))))))))
(define-fun-rec
  lmerge
  ((x (list Nat)) (y (list Nat))) (list Nat)
  (match x
    ((nil y)
     ((cons z x2)
      (match y
        ((nil x)
         ((cons x3 x4)
          (ite
            (leq z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))))
(define-fun-rec
  length
  (par (a) (((x (list a))) Nat))
  (match x
    ((nil zero)
     ((cons y l) (plus (succ zero) (length l))))))
(define-fun-rec
  drop
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    ((zero y)
     ((succ z)
      (match y
        ((nil (_ nil a))
         ((cons z2 xs1) (drop z xs1))))))))
(define-fun-rec
  nmsorttd
  ((x (list Nat))) (list Nat)
  (match x
    ((nil (_ nil Nat))
     ((cons y z)
      (match z
        ((nil (cons y (_ nil Nat)))
         ((cons x2 x3)
          (let ((k (nmsorttd-half1 (length x))))
            (lmerge (nmsorttd (take k x)) (nmsorttd (drop k x)))))))))))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Nat))
  (match y
    ((nil zero)
     ((cons z ys)
      (ite (= x z) (plus (succ zero) (count x ys)) (count x ys))))))
(prove
  (forall ((x Nat) (xs (list Nat)))
    (= (count x (nmsorttd xs)) (count x xs))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
