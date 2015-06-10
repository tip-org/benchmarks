(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a)
     (select2
        ((x a) (y (list (Pair a (list a))))) (list (Pair a (list a))))))
  ((match y
     (case nil (as nil (list (Pair a (list a)))))
     (case (cons z x2)
       (match z
         (case (Pair2 y2 ys)
           (cons (Pair2 y2 (cons x ys)) (select2 x x2))))))))
(define-funs-rec
  ((par (a) (select ((x (list a))) (list (Pair a (list a))))))
  ((match x
     (case nil (as nil (list (Pair a (list a)))))
     (case (cons y xs) (cons (Pair2 y xs) (select2 y (select xs)))))))
(define-funs-rec
  ((prop_SelectPermutations
      ((x (list (Pair Int (list Int))))) (list (list Int))))
  ((match x
     (case nil (as nil (list (list Int))))
     (case (cons y z)
       (match y
         (case (Pair2 y2 ys)
           (cons (cons y2 ys) (prop_SelectPermutations z))))))))
(define-funs-rec
  ((eq ((x Nat) (y Nat)) Bool))
  ((match x
     (case Z
       (match y
         (case Z true)
         (case (S z) false)))
     (case (S x2)
       (match y
         (case Z false)
         (case (S y2) (eq x2 y2)))))))
(define-funs-rec
  ((count ((x Int) (y (list Int))) Nat))
  ((match y
     (case nil Z)
     (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs))))))
(define-funs-rec
  ((par (t) (all ((x (=> t Bool)) (y (list t))) Bool)))
  ((match y
     (case nil true)
     (case (cons z xs) (and (@ x z) (all x xs))))))
(assert-not
  (forall ((xs (list Int)) (z Int))
    (all (lambda ((x (list Int))) (eq (count z xs) (count z x)))
      (prop_SelectPermutations (select xs)))))
(check-sat)
