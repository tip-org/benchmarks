(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (t)
    (unpair :source List.unpair
       ((x (list (pair t t)))) (list t)
       (match x
         (case nil (_ nil t))
         (case (cons y xys)
           (match y (case (pair2 z y2) (cons z (cons y2 (unpair xys))))))))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  (par (t)
    (pairs :source List.pairs
       ((x (list t))) (list (pair t t))
       (match x
         (case nil (_ nil (pair t t)))
         (case (cons y z)
           (match z
             (case nil (_ nil (pair t t)))
             (case (cons y2 xs) (cons (pair2 y y2) (pairs xs)))))))))
(define-fun-rec
  minus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z Z)
      (case (S z) (match y (case (S y2) (minus z y2))))))
(define-fun-rec
  lt
    ((x Nat) (y Nat)) Bool
    (match y
      (case Z false)
      (case (S z)
        (match x
          (case Z true)
          (case (S n) (lt n z))))))
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
  imod ((x Nat) (y Nat)) Nat (ite (lt x y) x (imod (minus x y) y)))
(prove
  :source List.prop_PairUnpair
  (par (t)
    (forall ((xs (list t)))
      (=>
        (let ((eta (length xs)))
          (=
            (let ((md (imod eta (S (S Z)))))
              (ite
                (and
                  (=
                    (match eta
                      (case Z Z)
                      (case (S x) (ite (le eta Z) (match Z (case (S y) (p Z))) (S Z))))
                    (ite
                      (le (S (S Z)) Z) (match Z (case (S z) (minus Z (p Z))))
                      (match Z (case (S x2) (p Z)))))
                  (distinct md Z))
                (minus md (S (S Z))) md))
            Z))
        (= (unpair (pairs xs)) xs)))))
