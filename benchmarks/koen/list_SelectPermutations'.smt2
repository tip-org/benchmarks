(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a)
     (select2
        ((x a) (y (list (Pair2 a (list a))))) (list (Pair2 a (list a))))))
  ((match y
     (case nil y)
     (case (cons z x2)
       (match z
         (case (Pair y2 ys)
           (cons (Pair y2 (cons x ys)) (select2 x x2))))))))
(define-funs-rec
  ((par (a) (select ((x (list a))) (list (Pair2 a (list a))))))
  ((match x
     (case nil (as nil (list (Pair2 a (list a)))))
     (case (cons y xs) (cons (Pair y xs) (select2 y (select xs)))))))
(define-funs-rec
  ((prop_SelectPermutations
      ((x (list (Pair2 int (list int))))) (list (list int))))
  ((match x
     (case nil (as nil (list (list int))))
     (case (cons y z)
       (match y
         (case (Pair y2 ys)
           (cons (cons y2 ys) (prop_SelectPermutations z))))))))
(define-funs-rec
  ((eq ((x Nat) (y Nat)) bool))
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
  ((par (b c a) (dot ((x (=> b c)) (y (=> a b)) (z a)) c)))
  ((@ x (@ y z))))
(define-funs-rec
  ((count ((x int) (y (list int))) Nat))
  ((match y
     (case nil Z)
     (case (cons z xs) (ite (= x z) (S (count x xs)) (count x xs))))))
(define-funs-rec
  ((and2 ((x bool) (y bool)) bool)) ((ite x y false)))
(define-funs-rec
  ((par (t) (all ((x (=> t bool)) (y (list t))) bool)))
  ((match y
     (case nil true)
     (case (cons z xs) (and2 (@ x z) (all x xs))))))
(assert-not
  (forall ((xs (list int)) (z int))
    (all
    (lambda ((x (list int)))
      (dot (lambda ((y Nat)) (eq (count z xs) y))
        (lambda ((x2 (list int))) (count z x2)) x))
      (prop_SelectPermutations (select xs)))))
(check-sat)
