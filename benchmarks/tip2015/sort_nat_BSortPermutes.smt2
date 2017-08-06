; Bitonic sort
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun
  (par (a)
    (sort2 :source Sort.sort2
       ((x a) (y a)) (list a)
       (ite
         (<= x y) (cons x (cons y (as nil (list a))))
         (cons y (cons x (as nil (list a))))))))
(define-funs-rec
  ((par (a) (evens :source Sort.evens ((x (list a))) (list a)))
   (par (a) (odds :source Sort.odds ((x (list a))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (as nil (list a)))
     (case (cons y xs) (evens xs)))))
(define-fun-rec
  (par (a)
    (elem :let :source Prelude.elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (deleteBy :source Data.List.deleteBy
       ((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)
       (match z
         (case nil (as nil (list a)))
         (case (cons y2 ys)
           (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys))))))))
(define-fun-rec
  (par (a)
    (isPermutation :source SortUtils.isPermutation
       ((x (list a)) (y (list a))) Bool
       (match x
         (case nil
           (match y
             (case nil true)
             (case (cons z x2) false)))
         (case (cons x3 xs)
           (and (elem x3 y)
             (isPermutation xs
               (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5)))
                 x3 y))))))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (pairs :source Sort.pairs
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z x2)
           (match y
             (case nil x)
             (case (cons x3 x4) (++ (sort2 z x3) (pairs x2 x4)))))))))
(define-fun
  (par (a)
    (stitch :source Sort.stitch
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (pairs xs y)))))))
(define-fun-rec
  (par (a)
    (bmerge :source Sort.bmerge
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons z x2)
           (match y
             (case nil x)
             (case (cons x3 x4)
               (let
                 ((fail
                     (stitch (bmerge (evens x) (evens y)) (bmerge (odds x) (odds y)))))
                 (match x2
                   (case nil
                     (match x4
                       (case nil (sort2 z x3))
                       (case (cons x5 x6) fail)))
                   (case (cons x7 x8) fail))))))))))
(define-fun-rec
  (par (a)
    (bsort :source Sort.bsort
       ((x (list a))) (list a)
       (match x
         (case nil (as nil (list a)))
         (case (cons y z)
           (match z
             (case nil (cons y (as nil (list a))))
             (case (cons x2 x3)
               (bmerge (bsort (evens x)) (bsort (odds x))))))))))
(prove
  :source Sort.prop_BSortPermutes
  (forall ((x (list Nat))) (isPermutation (bsort x) x)))
