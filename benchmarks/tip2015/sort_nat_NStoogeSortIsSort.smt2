; Stooge sort defined using reverse and thirds on natural numbers
(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (succ (plus z y)))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero zero)
      (case (succ z) (match y (case (succ y2) (minus z y2))))))
(define-fun-rec
  third
    ((x Nat)) Nat
    (ite
      (= x (succ (succ zero))) zero
      (ite
        (= x (succ zero)) zero
        (match x
          (case zero zero)
          (case (succ y)
            (plus (succ zero) (third (minus x (succ (succ (succ zero)))))))))))
(define-fun-rec
  leq
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(define-fun
  sort2
    ((x Nat) (y Nat)) (list Nat)
    (ite
      (leq x y) (cons x (cons y (_ nil Nat)))
      (cons y (cons x (_ nil Nat)))))
(define-fun-rec
  (par (a)
    (take
       ((x Nat) (y (list a))) (list a)
       (ite
         (leq x zero) (_ nil a)
         (match y
           (case nil (_ nil a))
           (case (cons z xs)
             (match x (case (succ x2) (cons z (take x2 xs))))))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil zero)
         (case (cons y l) (plus (succ zero) (length l)))))))
(define-fun-rec
  insert
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (cons x (_ nil Nat)))
      (case (cons z xs)
        (ite (leq x z) (cons x y) (cons z (insert x xs))))))
(define-fun-rec
  isort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons y xs) (insert y (isort xs)))))
(define-fun-rec
  (par (a)
    (drop
       ((x Nat) (y (list a))) (list a)
       (ite
         (leq x zero) y
         (match y
           (case nil (_ nil a))
           (case (cons z xs1) (match x (case (succ x2) (drop x2 xs1)))))))))
(define-fun
  (par (a)
    (splitAt
       ((x Nat) (y (list a))) (pair (list a) (list a))
       (pair2 (take x y) (drop x y)))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (reverse
       ((x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs) (++ (reverse xs) (cons y (_ nil a))))))))
(define-funs-rec
  ((nstooge1sort2 ((x (list Nat))) (list Nat))
   (nstoogesort ((x (list Nat))) (list Nat))
   (nstooge1sort1 ((x (list Nat))) (list Nat)))
  ((match (splitAt (third (length x)) (reverse x))
     (case (pair2 ys1 zs1) (++ (nstoogesort zs1) (reverse ys1))))
   (match x
     (case nil (_ nil Nat))
     (case (cons y z)
       (match z
         (case nil (cons y (_ nil Nat)))
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (nstooge1sort2 (nstooge1sort1 (nstooge1sort2 x)))))))))
   (match (splitAt (third (length x)) x)
     (case (pair2 ys1 zs) (++ ys1 (nstoogesort zs))))))
(prove (forall ((xs (list Nat))) (= (nstoogesort xs) (isort xs))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
