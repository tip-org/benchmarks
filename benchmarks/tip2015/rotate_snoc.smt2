; Rotate expressed using a snoc instead of append
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (snoc :source SnocRotate.snoc
       ((x a) (y (list a))) (list a)
       (match y
         (case nil (cons x (_ nil a)))
         (case (cons z ys) (cons z (snoc x ys)))))))
(define-fun-rec
  (par (a)
    (rotate :source SnocRotate.rotate
       ((x Nat) (y (list a))) (list a)
       (match x
         (case Z y)
         (case (S z)
           (match y
             (case nil (_ nil a))
             (case (cons z2 xs1) (rotate z (snoc z2 xs1)))))))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  (par (a)
    (length :source Prelude.length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y l) (plus (S Z) (length l)))))))
(prove
  :source SnocRotate.prop_snoc
  (par (a) (forall ((xs (list a))) (= (rotate (length xs) xs) xs))))
