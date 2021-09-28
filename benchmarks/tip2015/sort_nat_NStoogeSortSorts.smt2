; Stooge sort defined using reverse and thirds on natural numbers
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
  minus
  ((x Nat) (y Nat)) Nat
  (match x
    ((zero zero)
     ((succ z)
      (match y
        (((succ y2) (minus z y2))
         (zero zero)))))))
(define-fun-rec
  third
  ((x Nat)) Nat
  (match x
    ((zero zero)
     ((succ y)
      (match y
        ((zero zero)
         ((succ z)
          (match z
            ((zero zero)
             ((succ x2)
              (plus (succ zero)
                (third (minus x (succ (succ (succ zero))))))))))))))))
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
  ordered
  ((x (list Nat))) Bool
  (match x
    ((nil true)
     ((cons y z)
      (match z
        ((nil true)
         ((cons y2 xs) (and (leq y y2) (ordered z)))))))))
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
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  reverse
  (par (a) (((x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (++ (reverse xs) (cons y (_ nil a)))))))
(define-funs-rec
  ((nstooge1sort2
    ((x (list Nat))) (list Nat))
   (nstoogesort
    ((x (list Nat))) (list Nat))
   (nstooge1sort1
    ((x (list Nat))) (list Nat)))
  ((match (splitAt (third (length x)) (reverse x))
     (((pair2 ys1 zs1) (++ (nstoogesort zs1) (reverse ys1)))))
   (match x
     ((nil (_ nil Nat))
      ((cons y z)
       (match z
         ((nil (cons y (_ nil Nat)))
          ((cons y2 x2)
           (match x2
             ((nil (sort2 y y2))
              ((cons x3 x4)
               (nstooge1sort2 (nstooge1sort1 (nstooge1sort2 x))))))))))))
   (match (splitAt (third (length x)) x)
     (((pair2 ys1 zs) (++ ys1 (nstoogesort zs)))))))
(prove (forall ((xs (list Nat))) (ordered (nstoogesort xs))))
(assert
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert (forall ((x Nat)) (= (plus x zero) x)))
(assert (forall ((x Nat)) (= (plus zero x) x)))
