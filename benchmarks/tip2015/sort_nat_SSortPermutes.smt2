; Selection sort, using a total minimum function
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
  ssort-minimum1 :let
    ((x Nat) (y (list Nat))) Nat
    (match y
      (case nil x)
      (case (cons y1 ys1)
        (ite (leq y1 x) (ssort-minimum1 y1 ys1) (ssort-minimum1 x ys1)))))
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
(prove
  :source Sort.prop_SSortPermutes
  (forall ((xs (list Nat))) (isPermutation (ssort xs) xs)))
