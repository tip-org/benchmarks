; Property about rotate and mod
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (match y (case (S y2) (minus z y2))))))
(define-fun-rec
  (par (a)
    (length :source Prelude.length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y l) (plus (S Z) (length l)))))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun-rec
  (par (a)
    (take :source Prelude.take
       ((x Nat) (y (list a))) (list a)
       (ite
         (le x Z) (_ nil a)
         (match y
           (case nil (_ nil a))
           (case (cons z xs)
             (match x (case (S x2) (cons z (take x2 xs))))))))))
(define-fun-rec
  go :source Mod.go
    ((x Nat) (y Nat) (z Nat)) Nat
    (match z
      (case Z Z)
      (case (S x2)
        (match x
          (case Z
            (match y
              (case Z Z)
              (case (S x5) (minus z y))))
          (case (S x3)
            (match y
              (case Z (go x3 x2 z))
              (case (S x4) (go x3 x4 z))))))))
(define-fun
  mod_structural :source Mod.mod_structural
    ((x Nat) (y Nat)) Nat (go x Z y))
(define-fun-rec
  (par (a)
    (drop :source Prelude.drop
       ((x Nat) (y (list a))) (list a)
       (ite
         (le x Z) y
         (match y
           (case nil (_ nil a))
           (case (cons z xs1) (match x (case (S x2) (drop x2 xs1)))))))))
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
         (case Z y)
         (case (S z)
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
