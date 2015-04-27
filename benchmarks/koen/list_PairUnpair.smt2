(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair2 (Pair (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (t) (unpair ((x (list (Pair2 t t)))) (list t))))
  ((match x
     (case nil (as nil (list t)))
     (case (cons y xys)
       (match y (case (Pair z y2) (cons z (cons y2 (unpair xys)))))))))
(define-funs-rec
  ((par (t) (pairs ((x (list t))) (list (Pair2 t t)))))
  ((match x
     (case nil (as nil (list (Pair2 t t))))
     (case (cons y z)
       (match z
         (case nil (as nil (list (Pair2 t t))))
         (case (cons y2 xs) (cons (Pair y y2) (pairs xs))))))))
(define-funs-rec
  ((par (t) (length ((x (list t))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (length xs))))))
(define-funs-rec
  ((even ((x Nat)) bool))
  ((match x
     (case Z true)
     (case (S y)
       (match y
         (case Z false)
         (case (S z) (even z)))))))
(assert-not
  (par (t)
    (forall ((xs (list t)))
      (=> (even (length xs)) (= (unpair (pairs xs)) xs)))))
(check-sat)
