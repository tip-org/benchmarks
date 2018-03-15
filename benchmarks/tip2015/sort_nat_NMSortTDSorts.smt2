; Top-down merge sort, using division by two on natural numbers
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
  minus :definition :source |-|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero zero)
      (case (succ z) (match y (case (succ y2) (minus z y2))))))
(define-fun-rec
  nmsorttd-half1 :let
    ((x Nat)) Nat
    (ite
      (= x (succ zero)) zero
      (match x
        (case zero zero)
        (case (succ y)
          (plus (succ zero)
            (nmsorttd-half1 (minus x (succ (succ zero)))))))))
(define-fun-rec
  leq :definition :source |<=|
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
(define-fun-rec
  lmerge :source Sort.lmerge
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4)
            (ite
              (leq z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))
(define-fun-rec
  ordered :source SortUtils.ordered
    ((x (list Nat))) Bool
    (match x
      (case nil true)
      (case (cons y z)
        (match z
          (case nil true)
          (case (cons y2 xs) (and (leq y y2) (ordered z)))))))
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
  (par (a)
    (drop :source Prelude.drop
       ((x Nat) (y (list a))) (list a)
       (ite
         (leq x zero) y
         (match y
           (case nil (_ nil a))
           (case (cons z xs1) (match x (case (succ x2) (drop x2 xs1)))))))))
(define-fun-rec
  nmsorttd :source Sort.nmsorttd
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons y z)
        (match z
          (case nil (cons y (_ nil Nat)))
          (case (cons x2 x3)
            (let ((k (nmsorttd-half1 (length x))))
              (lmerge (nmsorttd (take k x)) (nmsorttd (drop k x)))))))))
(prove
  :source Sort.prop_NMSortTDSorts
  (forall ((xs (list Nat))) (ordered (nmsorttd xs))))
(assert
  :axiom |associativity of +|
  (forall ((x Nat) (y Nat) (z Nat))
    (= (plus x (plus y z)) (plus (plus x y) z))))
(assert
  :axiom |commutativity of +|
  (forall ((x Nat) (y Nat)) (= (plus x y) (plus y x))))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus x zero) x)))
(assert
  :axiom |identity for +|
  (forall ((x Nat)) (= (plus zero x) x)))
