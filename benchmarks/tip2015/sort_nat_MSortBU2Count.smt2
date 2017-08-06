; Bottom-up merge sort, using a total risers function
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (risers :source Sort.risers
       ((x (list a))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons y z)
           (match z
             (case nil
               (cons (cons y (as nil (list a))) (as nil (list (list a)))))
             (case (cons y2 xs)
               (ite
                 (<= y y2)
                 (match (risers z)
                   (case nil (as nil (list (list a))))
                   (case (cons ys yss) (cons (cons y ys) yss)))
                 (cons (cons y (as nil (list a))) (risers z))))))))))
(define-fun-rec
  plus
    ((x Nat) (y Nat)) Nat
    (match x
      (case Z y)
      (case (S z) (S (plus z y)))))
(define-fun-rec
  (par (a)
    (lmerge :source Sort.lmerge
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z x2)
           (match y
             (case nil x)
             (case (cons x3 x4)
               (ite
                 (<= z x3) (cons z (lmerge x2 y)) (cons x3 (lmerge x x4))))))))))
(define-fun-rec
  (par (a)
    (pairwise-pairwise1 :let :source Sort.pairwise
       ((x (list (list a)))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons xs y)
           (match y
             (case nil (cons xs (as nil (list (list a)))))
             (case (cons ys xss)
               (cons (lmerge xs ys) (pairwise-pairwise1 xss)))))))))
(define-fun-rec
  (par (a)
    (mergingbu2 :source Sort.mergingbu2
       ((x (list (list a)))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons xs y)
           (match y
             (case nil xs)
             (case (cons z x2) (mergingbu2 (pairwise-pairwise1 x)))))))))
(define-fun
  (par (a)
    (msortbu2 :source Sort.msortbu2
       ((x (list a))) (list a) (mergingbu2 (risers x)))))
(define-fun-rec
  (par (a)
    (count :source SortUtils.count
       ((x a) (y (list a))) Nat
       (match y
         (case nil Z)
         (case (cons z ys)
           (ite (= x z) (plus (S Z) (count x ys)) (count x ys)))))))
(prove
  :source Sort.prop_MSortBU2Count
  (forall ((x Nat) (y (list Nat)))
    (= (count x (msortbu2 y)) (count x y))))
