(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((y ((z (list (Pair2 int (list int))))) (list (list int))))
  ((match z
     (case nil (as nil (list (list int))))
     (case (cons x2 x3)
       (match x2 (case (Pair y2 ys) (cons (cons y2 ys) (y x3))))))))
(define-funs-rec
  ((par (a)
     (x ((z a) (x2 (list (Pair2 a (list a)))))
        (list (Pair2 a (list a))))))
  ((match x2
     (case nil x2)
     (case (cons x3 x4)
       (match x3
         (case (Pair y2 ys) (cons (Pair y2 (cons z ys)) (x z x4))))))))
(define-funs-rec
  ((par (a) (select ((z (list a))) (list (Pair2 a (list a))))))
  ((match z
     (case nil (as nil (list (Pair2 a (list a)))))
     (case (cons x2 xs) (cons (Pair x2 xs) (x x2 (select xs)))))))
(define-funs-rec
  ((eq ((z Nat) (x2 Nat)) bool))
  ((match z
     (case Z
       (match x2
         (case Z true)
         (case (S x3) false)))
     (case (S x4)
       (match x2
         (case Z false)
         (case (S y2) (eq x4 y2)))))))
(define-funs-rec
  ((par (b c a) (dot ((z (=> b c)) (x2 (=> a b)) (x3 a)) c)))
  ((@ z (@ x2 x3))))
(define-funs-rec
  ((count ((z int) (x2 (list int))) Nat))
  ((match x2
     (case nil Z)
     (case (cons y2 xs) (ite (= z y2) (S (count z xs)) (count z xs))))))
(define-funs-rec
  ((and2 ((z bool) (x2 bool)) bool)) ((ite z x2 false)))
(define-funs-rec
  ((par (t) (all ((z (=> t bool)) (x2 (list t))) bool)))
  ((match x2
     (case nil true)
     (case (cons x3 xs) (and2 (@ z x3) (all z xs))))))
(assert-not
  (forall ((xs (list int)) (z int))
    (all
    (lambda ((x2 (list int)))
      (dot (lambda ((x3 Nat)) (eq (count z xs) x3))
        (lambda ((x4 (list int))) (count z x4)) x2))
      (y (select xs)))))
(check-sat)
