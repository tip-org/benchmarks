; Source: Productive use of failure
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((plus ((x Nat) (y Nat)) Nat))
  ((match x
     (case Z y)
     (case (S z) (S (plus z y))))))
(define-funs-rec
  ((par (a) (length ((x (list a))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (as (length xs) Nat))))))
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
  (par (a)
    (forall ((x (list a)) (y (list a)))
      (= (length (rev (append x y))) (plus (length x) (length y))))))
(check-sat)
