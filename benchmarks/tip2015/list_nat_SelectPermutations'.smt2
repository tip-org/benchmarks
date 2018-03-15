(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
(define-fun-rec
  (par (a)
    (select :let
       ((x a) (y (list (pair a (list a))))) (list (pair a (list a)))
       (match y
         (case nil (_ nil (pair a (list a))))
         (case (cons z x2)
           (match z
             (case (pair2 y2 ys)
               (cons (pair2 y2 (cons x ys)) (select x x2)))))))))
(define-fun-rec
  (par (a)
    (select2 :source List.select
       ((x (list a))) (list (pair a (list a)))
       (match x
         (case nil (_ nil (pair a (list a))))
         (case (cons y xs) (cons (pair2 y xs) (select y (select2 xs))))))))
(define-fun-rec
  plus :definition :source |+|
    ((x Nat) (y Nat)) Nat
    (match x
      (case zero y)
      (case (succ z) (succ (plus z y)))))
(define-fun-rec
  (par (a)
    (formula :let
       ((x (list (pair a (list a))))) (list (list a))
       (match x
         (case nil (_ nil (list a)))
         (case (cons y z)
           (match y (case (pair2 y2 ys) (cons (cons y2 ys) (formula z)))))))))
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
    (all :let :source Prelude.all
       ((q (=> a Bool)) (x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y xs) (and (@ q y) (all q xs)))))))
(prove
  :source |List.prop_SelectPermutations'|
  (par (a)
    (forall ((xs (list a)) (z a))
      (all (lambda ((x (list a))) (= (count z xs) (count z x)))
        (formula (select2 xs))))))
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
