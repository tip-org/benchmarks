; QuickSort
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
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
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun-rec
  insert :source Sort.insert
    ((x Nat) (y (list Nat))) (list Nat)
    (match y
      (case nil (cons x (_ nil Nat)))
      (case (cons z xs)
        (ite (le x z) (cons x y) (cons z (insert x xs))))))
(define-fun-rec
  isort :source Sort.sort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons y xs) (insert y (isort xs)))))
(define-fun gt ((x Nat) (y Nat)) Bool (lt y x))
(define-fun-rec
  (par (a)
    (filter :let :source Prelude.filter
       ((q (=> a Bool)) (x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs)
           (ite (@ q y) (cons y (filter q xs)) (filter q xs)))))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  qsort :source Sort.qsort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons y xs)
        (++ (qsort (filter (lambda ((z Nat)) (le z y)) xs))
          (++ (cons y (_ nil Nat))
            (qsort (filter (lambda ((x2 Nat)) (gt x2 y)) xs)))))))
(prove
  :source Sort.prop_QSortIsSort
  (forall ((xs (list Nat))) (= (qsort xs) (isort xs))))
