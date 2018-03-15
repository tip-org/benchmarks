; Bottom-up merge sort
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
  (par (a b)
    (map :let :source Prelude.map
       ((f (=> a b)) (x (list a))) (list b)
       (match x
         (case nil (_ nil b))
         (case (cons y xs) (cons (@ f y) (map f xs)))))))
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
  pairwise :source Sort.pairwise
    ((x (list (list Nat)))) (list (list Nat))
    (match x
      (case nil (_ nil (list Nat)))
      (case (cons xs y)
        (match y
          (case nil (cons xs (_ nil (list Nat))))
          (case (cons ys xss) (cons (lmerge xs ys) (pairwise xss)))))))
(define-fun-rec
  mergingbu :source Sort.mergingbu
    ((x (list (list Nat)))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons xs y)
        (match y
          (case nil xs)
          (case (cons z x2) (mergingbu (pairwise x)))))))
(define-fun
  msortbu :source Sort.msortbu
    ((x (list Nat))) (list Nat)
    (mergingbu (map (lambda ((y Nat)) (cons y (_ nil Nat))) x)))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Nat
       (match y
         (case nil zero)
         (case (cons z ys)
           (ite (= x z) (plus (succ zero) (count x ys)) (count x ys)))))))
(prove
  :source Sort.prop_MSortBUCount
  (forall ((x Nat) (xs (list Nat)))
    (= (count x (msortbu xs)) (count x xs))))
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
