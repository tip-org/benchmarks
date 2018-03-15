; Property about rotate and mod
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
  leq :definition :source |<=|
    ((x Nat) (y Nat)) Bool
    (match x
      (case zero true)
      (case (succ z)
        (match y
          (case zero false)
          (case (succ x2) (leq z x2))))))
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
  go :source Mod.go
    ((x Nat) (y Nat) (z Nat)) Nat
    (match z
      (case zero zero)
      (case (succ x2)
        (match x
          (case zero
            (match y
              (case zero zero)
              (case (succ x5) (minus z y))))
          (case (succ x3)
            (match y
              (case zero (go x3 x2 z))
              (case (succ x4) (go x3 x4 z))))))))
(define-fun
  mod_structural :source Mod.mod_structural
    ((x Nat) (y Nat)) Nat (go x zero y))
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
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (rotate :source Rotate.rotate
       ((x Nat) (y (list a))) (list a)
       (match x
         (case zero y)
         (case (succ z)
           (match y
             (case nil (_ nil a))
             (case (cons z2 xs1) (rotate z (++ xs1 (cons z2 (_ nil a)))))))))))
(prove
  :source ModRotate.prop_structural_mod
  (par (a)
    (forall ((n Nat) (xs (list a)))
      (= (rotate n xs)
        (++ (drop (mod_structural n (length xs)) xs)
          (take (mod_structural n (length xs)) xs))))))
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
