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
  (par (b)
    (pairs
       ((x (list b))) (list (pair b b))
       (match x
         (case nil (_ nil (pair b b)))
         (case (cons y z)
           (match z
             (case nil (_ nil (pair b b)))
             (case (cons y2 xs) (cons (pair2 y y2) (pairs xs)))))))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero zero)
      (case (succ z) (match y (case (succ y2) (minus z y2))))))
(define-fun-rec
  (par (a b)
    (map
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (_ nil b))
         (case (cons y xs) (cons (@ f y) (map f xs)))))))
(define-fun-rec
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case zero false)
      (case (succ z)
        (match x
          (case zero true)
          (case (succ n) (lt n z))))))
(define-fun-rec
  leq
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil zero)
         (case (cons y l) (plus (succ zero) (length l)))))))
(define-fun-rec
  imod ((x Nat) (y Nat)) Nat (ite (lt x y) x (imod (minus x y) y)))
(define-funs-rec
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil (_ nil a))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (_ nil a))
     (case (cons y xs) (evens xs)))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (let
        ((eta (length xs))
         (md (imod eta (succ (succ zero)))))
        (=>
          (=
            (ite
              (and
                (=
                  (match eta
                    (case zero zero)
                    (case (succ x)
                      (ite
                        (leq eta zero) (match zero (case (succ y) (p zero))) (succ zero))))
                  (ite
                    (leq (succ (succ zero)) zero)
                    (match zero (case (succ z) (minus zero (p zero))))
                    (match zero (case (succ x2) (p zero)))))
                (distinct md zero))
              (minus md (succ (succ zero))) md)
            zero)
          (=
            (map (lambda ((x3 (pair a a))) (match x3 (case (pair2 y2 z2) y2)))
              (pairs xs))
            (evens xs)))))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
