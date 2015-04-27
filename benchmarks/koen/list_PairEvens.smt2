(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (t t2) (x ((f (=> t2 t)) (y (list t2))) (list t))))
  ((match y
     (case nil (as nil (list t)))
     (case (cons z x2) (cons (@ f z) (x f x2))))))
(define-funs-rec
  ((par (t) (pairs ((y (list t))) (list (Pair2 t t)))))
  ((match y
     (case nil (as nil (list (Pair2 t t))))
     (case (cons z x2)
       (match x2
         (case nil (as nil (list (Pair2 t t))))
         (case (cons y2 xs) (cons (Pair z y2) (pairs xs))))))))
(define-funs-rec
  ((par (t) (length ((y (list t))) Nat)))
  ((match y
     (case nil Z)
     (case (cons z xs) (S (length xs))))))
(define-funs-rec
  ((par (a b) (fst ((y (Pair2 a b))) a)))
  ((match y (case (Pair z x2) z))))
(define-funs-rec
  ((par (a) (evens ((y (list a))) (list a)))
   (par (a) (odds ((y (list a))) (list a))))
  ((match y
     (case nil y)
     (case (cons z xs) (cons z (odds xs))))
   (match y
     (case nil y)
     (case (cons z xs) (evens xs)))))
(define-funs-rec
  ((even ((y Nat)) bool))
  ((match y
     (case Z true)
     (case (S z)
       (match z
         (case Z false)
         (case (S x2) (even x2)))))))
(assert-not
  (par (b)
    (forall ((xs (list b)))
      (=> (even (length xs))
        (= (x (lambda ((y (Pair2 b b))) (fst y)) (pairs xs))
          (evens xs))))))
(check-sat)
