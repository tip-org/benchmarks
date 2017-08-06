; Selection sort, using a total minimum function
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
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun-rec
  ssort-minimum1 :let
    ((x Nat) (y (list Nat))) Nat
    (match y
      (case nil x)
      (case (cons y1 ys1)
        (ite (le y1 x) (ssort-minimum1 y1 ys1) (ssort-minimum1 x ys1)))))
(define-fun-rec
  (par (a)
    (deleteBy :source Data.List.deleteBy
       ((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)
       (match z
         (case nil (_ nil a))
         (case (cons y2 ys)
           (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys))))))))
(define-fun-rec
  ssort :source Sort.ssort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons y ys)
        (let ((m (ssort-minimum1 y ys)))
          (cons m
            (ssort
              (deleteBy (lambda ((z Nat)) (lambda ((x2 Nat)) (= z x2)))
                m x)))))))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Nat
       (match y
         (case nil Z)
         (case (cons z ys)
           (ite (= x z) (plus (S Z) (count x ys)) (count x ys)))))))
(prove
  :source Sort.prop_SSortCount
  (forall ((x Nat) (xs (list Nat)))
    (= (count x (ssort xs)) (count x xs))))
