; Stooge sort
(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  plus :definition :source |+|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (succ (plus z y)))))
(define-fun-rec
  times :definition :source |*|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero zero)
      (case (succ z) (plus y (times z y)))))
(define-fun-rec
  minus :definition :source |-|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero zero)
      (case (succ z) (match y (case (succ y2) (minus z y2))))))
(define-fun-rec
  lt :definition :source |<|
    ((x Nat) (y Nat)) Bool
    (match y
      (case zero false)
      (case (succ z)
        (match x
          (case zero true)
          (case (succ n) (lt n z))))))
(define-fun-rec
  leq :definition :source |<=|
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(define-fun
  sort2 :source Sort.sort2
    ((x Nat) (y Nat)) (list Nat)
    (ite
      (leq x y) (cons x (cons y (_ nil Nat)))
      (cons y (cons x (_ nil Nat)))))
(define-fun-rec
  (par (a)
    (take :source Prelude.take
       ((x Nat) (y (list a))) (list a)
       (ite
         (leq x zero) (_ nil a)
         (match y
           (case nil (_ nil a))
           (case (cons z xs)
             (match x (case (succ x2) (cons z (take x2 xs))))))))))
(define-fun-rec
  (par (a)
    (length :source Prelude.length
       ((x (list a))) Nat
       (match x
         (case nil zero)
         (case (cons y l) (plus (succ zero) (length l)))))))
(define-fun-rec
  idiv :definition :source |div|
    ((x Nat) (y Nat)) Nat
    (ite (lt x y) zero (succ (idiv (minus x y) y))))
(define-fun-rec
  (par (a)
    (drop :source Prelude.drop
       ((x Nat) (y (list a))) (list a)
       (ite
         (leq x zero) y
         (match y
           (case nil (_ nil a))
           (case (cons z xs1) (match x (case (succ x2) (drop x2 xs1)))))))))
(define-fun
  (par (a)
    (splitAt :source Prelude.splitAt
       ((x Nat) (y (list a))) (pair (list a) (list a))
       (pair2 (take x y) (drop x y)))))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Nat
       (match y
         (case nil zero)
         (case (cons z ys)
           (ite (= x z) (plus (succ zero) (count x ys)) (count x ys)))))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-funs-rec
  ((stooge2sort2 :source Sort.stooge2sort2
      ((x (list Nat))) (list Nat))
   (stoogesort2 :source Sort.stoogesort2 ((x (list Nat))) (list Nat))
   (stooge2sort1 :source Sort.stooge2sort1
      ((x (list Nat))) (list Nat)))
  ((match
     (splitAt
       (idiv (succ (times (succ (succ zero)) (length x)))
         (succ (succ (succ zero))))
       x)
     (case (pair2 ys1 zs) (++ (stoogesort2 ys1) zs)))
   (match x
     (case nil (_ nil Nat))
     (case (cons y z)
       (match z
         (case nil (cons y (_ nil Nat)))
         (case (cons y2 x2)
           (match x2
             (case nil (sort2 y y2))
             (case (cons x3 x4)
               (stooge2sort2 (stooge2sort1 (stooge2sort2 x)))))))))
   (match (splitAt (idiv (length x) (succ (succ (succ zero)))) x)
     (case (pair2 ys1 zs) (++ ys1 (stoogesort2 zs))))))
(prove
  :source Sort.prop_StoogeSort2Count
  (forall ((x Nat) (xs (list Nat)))
    (= (count x (stoogesort2 xs)) (count x xs))))
(assert
  :axiom |associativity of *|
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times x (times y z)) (times (times x y) z))))
(assert
  :axiom |associativity of +|
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert
  :axiom |commutativity of *|
  (forall ((x Nat) (y Nat)) (= (times x y) (times y x))))
(assert
  :axiom |commutativity of +|
  (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert
  :axiom distributivity
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times x (plus y z)) (plus (times x y) (times x z)))))
(assert
  :axiom distributivity
  (forall ((x Nat) (y Nat) (z Nat))
    (= (times (plus x y) z) (plus (times x z) (times y z)))))
(assert
  :axiom |identity for *|
  (forall ((x Nat)) (= (times x (succ zero)) x)))
(assert
  :axiom |identity for *|
  (forall ((x Nat)) (= (times (succ zero) x) x)))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus x zero) x)))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus zero x) x)))
(assert
  :axiom |zero for *|
  (forall ((x Nat)) (= (times x zero) zero)))
(assert
  :axiom |zero for *|
  (forall ((x Nat)) (= (times zero x) zero)))
