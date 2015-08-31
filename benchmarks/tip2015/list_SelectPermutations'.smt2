(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  zcount
    ((x Int) (y (list Int))) Nat
    (match y
      (case nil Z)
      (case (cons z xs) (ite (= x z) (S (zcount x xs)) (zcount x xs)))))
(define-fun-rec
  (par (a)
    (select3
       ((x a) (y (list (Pair a (list a))))) (list (Pair a (list a)))
       (match y
         (case nil (as nil (list (Pair a (list a)))))
         (case (cons z x2)
           (match z
             (case (Pair2 y2 ys)
               (cons (Pair2 y2 (cons x ys)) (select3 x x2)))))))))
(define-fun-rec
  (par (a)
    (select2
       ((x (list a))) (list (Pair a (list a)))
       (match x
         (case nil (as nil (list (Pair a (list a)))))
         (case (cons y xs) (cons (Pair2 y xs) (select3 y (select2 xs))))))))
(define-fun-rec
  prop_SelectPermutations
    ((x (list (Pair Int (list Int))))) (list (list Int))
    (match x
      (case nil (as nil (list (list Int))))
      (case (cons y z)
        (match y
          (case (Pair2 y2 ys)
            (cons (cons y2 ys) (prop_SelectPermutations z)))))))
(define-fun-rec
  equal
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z
        (match y
          (case Z true)
          (case (S z) false)))
      (case (S x2)
        (match y
          (case Z false)
          (case (S y2) (equal x2 y2))))))
(define-fun-rec
  (par (a)
    (all
       ((x (=> a Bool)) (y (list a))) Bool
       (match y
         (case nil true)
         (case (cons z xs) (and (@ x z) (all x xs)))))))
(assert-not
  (forall ((xs (list Int)) (z Int))
    (all (lambda ((x (list Int))) (equal (zcount z xs) (zcount z x)))
      (prop_SelectPermutations (select2 xs)))))
(check-sat)
