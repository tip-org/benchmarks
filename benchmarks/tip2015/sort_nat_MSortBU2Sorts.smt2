; Bottom-up merge sort, using a total risers function
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (zero) (succ (p Nat)))))
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
  mergingbu2 :source Sort.mergingbu2
    ((x (list (list Nat)))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons xs y)
        (match y
          (case nil xs)
          (case (cons z x2) (mergingbu2 (pairwise x)))))))
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
  risers :source Sort.risers
    ((x (list Nat))) (list (list Nat))
    (match x
      (case nil (_ nil (list Nat)))
      (case (cons y z)
        (match z
          (case nil (cons (cons y (_ nil Nat)) (_ nil (list Nat))))
          (case (cons y2 xs)
            (ite
              (leq y y2)
              (match (risers z)
                (case nil (_ nil (list Nat)))
                (case (cons ys yss) (cons (cons y ys) yss)))
              (cons (cons y (_ nil Nat)) (risers z))))))))
(define-fun
  msortbu2 :source Sort.msortbu2
    ((x (list Nat))) (list Nat) (mergingbu2 (risers x)))
(prove
  :source Sort.prop_MSortBU2Sorts
  (forall ((xs (list Nat))) (ordered (msortbu2 xs))))
