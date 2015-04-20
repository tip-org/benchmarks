; Source: IsaPlanner test suite
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a b) (zip ((x (list a)) (y (list b))) (list (Pair2 a b)))))
  ((match x
     (case nil (as nil (list (Pair2 a b))))
     (case (cons z x2)
       (match y
         (case nil (as nil (list (Pair2 a b))))
         (case (cons x3 x4)
           (cons (Pair z x3) (as (zip x2 x4) (list (Pair2 a b))))))))))
(define-funs-rec
  ((par (a) (len ((x (list a))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (as (len xs) Nat))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (as (append xs y) (list a)))))))
(define-funs-rec
  ((par (a) (rev ((x (list a))) (list a))))
  ((match x
     (case nil x)
     (case (cons y xs)
       (append (as (rev xs) (list a)) (cons y (as nil (list a))))))))
(assert-not
  (par (a b)
    (forall ((xs (list a)) (ys (list b)))
      (=> (= (len xs) (len ys))
        (= (zip (rev xs) (rev ys)) (rev (zip xs ys)))))))
(check-sat)
