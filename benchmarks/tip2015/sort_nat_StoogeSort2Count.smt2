; Stooge sort
(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
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
  times
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero zero)
     ((succ z) (plus y (times z y))))))
(define-fun-rec
  minus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero zero)
     ((succ z)
      (match y
        (((succ y2) (minus z y2))
         (zero x)))))))
(define-fun-rec
  lt
  ((x Nat) (y Nat)) Bool
  (match y
    ((zero false)
     ((succ z)
      (match x
        ((zero true)
         ((succ n) (lt n z))))))))
(define-fun-rec
  leq
  ((x Nat) (y Nat)) Bool
  (match x
    ((zero true)
     ((succ z)
      (match y
        ((zero false)
         ((succ x2) (leq z x2))))))))
(define-fun
  sort2
  ((x Nat) (y Nat)) (list Nat)
  (ite
    (leq x y) (cons x (cons y (_ nil Nat)))
    (cons y (cons x (_ nil Nat)))))
(define-fun-rec
  length
  (par (a) (((x (list a))) Nat))
  (match x
    ((nil zero)
     ((cons y l) (plus (succ zero) (length l))))))
(define-fun-rec
  idiv
  ((x Nat) (y Nat)) Nat
  (ite (lt x y) zero (succ (idiv (minus x y) y))))
(define-fun-rec
  drop
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    ((zero y)
     ((succ z)
      (match y
        ((nil (_ nil a))
         ((cons z2 xs1) (drop z xs1))))))))
(define-fun
  splitAt
  (par (a) (((x Nat) (y (list a))) (pair (list a) (list a))))
  (pair2 (take x y) (drop x y)))
(define-fun-rec
  count
  (par (a) (((x a) (y (list a))) Nat))
  (match y
    ((nil zero)
     ((cons z ys)
      (ite (= x z) (plus (succ zero) (count x ys)) (count x ys))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-funs-rec
  ((stooge2sort2
    ((x (list Nat))) (list Nat))
   (stoogesort2
    ((x (list Nat))) (list Nat))
   (stooge2sort1
    ((x (list Nat))) (list Nat)))
  ((match
     (splitAt
       (idiv (succ (times (succ (succ zero)) (length x)))
         (succ (succ (succ zero))))
       x)
     (((pair2 ys1 zs) (++ (stoogesort2 ys1) zs))))
   (match x
     ((nil (_ nil Nat))
      ((cons y z)
       (match z
         ((nil (cons y (_ nil Nat)))
          ((cons y2 x2)
           (match x2
             ((nil (sort2 y y2))
              ((cons x3 x4)
               (stooge2sort2 (stooge2sort1 (stooge2sort2 x))))))))))))
   (match (splitAt (idiv (length x) (succ (succ (succ zero)))) x)
     (((pair2 ys1 zs) (++ ys1 (stoogesort2 zs)))))))
(prove
  (forall ((x Nat) (xs (list Nat)))
    (= (count x (stoogesort2 xs)) (count x xs))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times x (times y z)) (times (times x y) z))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (times x y) (times y x))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times x (plus y z)) (plus (times x y) (times x z)))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times (plus x y) z) (plus (times x z) (times y z)))))
(assert (forall ((x Nat)) (= (times x (succ zero)) x)))
(assert (forall ((x Nat)) (= (times (succ zero) x) x)))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
(assert (forall ((x Nat)) (= (times x zero) zero)))
(assert (forall ((x Nat)) (= (times zero x) zero)))
