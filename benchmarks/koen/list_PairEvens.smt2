(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (t) (pairs ((x (list t))) (list (Pair2 t t)))))
  ((match x
     (case nil (as nil (list (Pair2 t t))))
     (case (cons y z)
       (match z
         (case nil (as nil (list (Pair2 t t))))
         (case (cons y2 xs) (cons (Pair y y2) (pairs xs))))))))
(define-funs-rec
  ((par (t t2) (map2 ((f (=> t2 t)) (x (list t2))) (list t))))
  ((match x
     (case nil (as nil (list t)))
     (case (cons y z) (cons (@ f y) (map2 f z))))))
(define-funs-rec
  ((par (t) (length ((x (list t))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (length xs))))))
(define-funs-rec
  ((par (a b) (fst ((x (Pair2 a b))) a)))
  ((match x (case (Pair y z) y))))
(define-funs-rec
  ((par (a) (evens ((x (list a))) (list a)))
   (par (a) (odds ((x (list a))) (list a))))
  ((match x
     (case nil x)
     (case (cons y xs) (cons y (odds xs))))
   (match x
     (case nil x)
     (case (cons y xs) (evens xs)))))
(define-funs-rec
  ((even ((x Nat)) bool))
  ((match x
     (case Z true)
     (case (S y)
       (match y
         (case Z false)
         (case (S z) (even z)))))))
(assert-not
  (par (b)
    (forall ((xs (list b)))
      (=> (even (length xs))
        (= (map2 (lambda ((x (Pair2 b b))) (fst x)) (pairs xs))
          (evens xs))))))
(check-sat)
