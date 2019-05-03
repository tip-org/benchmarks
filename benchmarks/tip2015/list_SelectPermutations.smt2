(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(define-fun-rec
  select
  (par (a)
    (((x a) (y (list (pair a (list a))))) (list (pair a (list a)))))
  (match y
    ((nil (_ nil (pair a (list a))))
     ((cons z x2)
      (match z
        (((pair2 y2 ys) (cons (pair2 y2 (cons x ys)) (select x x2)))))))))
(define-fun-rec
  select2
  (par (a) (((x (list a))) (list (pair a (list a)))))
  (match x
    ((nil (_ nil (pair a (list a))))
     ((cons y xs) (cons (pair2 y xs) (select y (select2 xs)))))))
(define-fun-rec
  formula
  (par (a) (((x (list (pair a (list a))))) (list (list a))))
  (match x
    ((nil (_ nil (list a)))
     ((cons y z)
      (match y (((pair2 y2 ys) (cons (cons y2 ys) (formula z)))))))))
(define-fun-rec
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(define-fun-rec
  deleteBy
  (par (a) (((x (=> a (=> a Bool))) (y a) (z (list a))) (list a)))
  (match z
    ((nil (_ nil a))
     ((cons y2 ys)
      (ite (@ (@ x y) y2) ys (cons y2 (deleteBy x y ys)))))))
(define-fun-rec
  isPermutation
  (par (a) (((x (list a)) (y (list a))) Bool))
  (match x
    ((nil
      (match y
        ((nil true)
         ((cons z x2) false))))
     ((cons x3 xs)
      (and (elem x3 y)
        (isPermutation xs
          (deleteBy (lambda ((x4 a)) (lambda ((x5 a)) (= x4 x5))) x3 y)))))))
(define-fun-rec
  all
  (par (a) (((p (=> a Bool)) (x (list a))) Bool))
  (match x
    ((nil true)
     ((cons y xs) (and (@ p y) (all p xs))))))
(prove
  (par (a)
    (forall ((xs (list a)))
      (all (lambda ((x (list a))) (isPermutation x xs))
        (formula (select2 xs))))))
