(declare-datatypes (a b)
  ((pair :source |Prelude.(,)|
     (pair2 :source |Prelude.(,)| (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(define-fun-rec
  (par (a)
    (select :let
       ((x a) (y (list (pair a (list a))))) (list (pair a (list a)))
       (match y
         (case nil (as nil (list (pair a (list a)))))
         (case (cons z x2)
           (match z
             (case (pair2 y2 ys)
               (cons (pair2 y2 (cons x ys)) (select x x2)))))))))
(define-fun-rec
  (par (a)
    (select2 :source List.select
       ((x (list a))) (list (pair a (list a)))
       (match x
         (case nil (as nil (list (pair a (list a)))))
         (case (cons y xs) (cons (pair2 y xs) (select y (select2 xs))))))))
(define-fun-rec
  (par (a)
    (formula :let
       ((x (list (pair a (list a))))) (list (list a))
       (match x
         (case nil (as nil (list (list a))))
         (case (cons y z)
           (match y (case (pair2 y2 ys) (cons (cons y2 ys) (formula z)))))))))
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
    (all :let :source Prelude.all
       ((p (=> a Bool)) (x (list a))) Bool
       (match x
         (case nil true)
         (case (cons y xs) (and (@ p y) (all p xs)))))))
(prove
  :source List.prop_SelectPermutations
  (par (a)
    (forall ((xs (list a)))
      (all (lambda ((x (list a))) (isPermutation x xs))
        (formula (select2 xs))))))
