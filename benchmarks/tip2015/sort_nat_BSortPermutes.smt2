; Bitonic sort
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun
  sort2 :source Sort.sort2
    ((x Nat) (y Nat)) (list Nat)
    (ite
      (le x y) (cons x (cons y (_ nil Nat)))
      (cons y (cons x (_ nil Nat)))))
(define-funs-rec
  ((par (a) (evens :source Sort.evens ((x (list a))) (list a)))
   (par (a) (odds :source Sort.odds ((x (list a))) (list a))))
  ((match x
     (case nil (_ nil a))
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil (_ nil a))
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
         (case nil (_ nil a))
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
  pairs :source Sort.pairs
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil y)
      (case (cons z x2)
        (match y
          (case nil x)
          (case (cons x3 x4) (++ (sort2 z x3) (pairs x2 x4)))))))
(define-fun
  stitch :source Sort.stitch
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil y)
      (case (cons z xs) (cons z (pairs xs y)))))
(define-fun-rec
  bmerge :source Sort.bmerge
    ((x (list Nat)) (y (list Nat))) (list Nat)
    (match x
      (case nil (_ nil Nat))
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
                (case (cons x7 x8) fail))))))))
(define-fun-rec
  bsort :source Sort.bsort
    ((x (list Nat))) (list Nat)
    (match x
      (case nil (_ nil Nat))
      (case (cons y z)
        (match z
          (case nil (cons y (_ nil Nat)))
          (case (cons x2 x3) (bmerge (bsort (evens x)) (bsort (odds x))))))))
(prove
  :source Sort.prop_BSortPermutes
  (forall ((xs (list Nat))) (isPermutation (bsort xs) xs)))
