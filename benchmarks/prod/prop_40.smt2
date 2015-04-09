; Source: Productive use of failure
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((equal ((x10 Nat) (x11 Nat)) bool))
  ((match x10
     (case
       Z
       (match x11
         (case Z true)
         (case (S ipv) false)))
     (case
       (S ds)
       (match x11
         (case Z false)
         (case (S y) (equal ds y)))))))
(define-funs-rec
  ((elem ((x7 Nat) (x8 (list Nat))) bool))
  ((match x8
     (case nil false)
     (case
       (cons x9 xs3) (ite (equal x7 x9) (equal x7 x9) (elem x7 xs3))))))
(define-funs-rec
  ((subset ((x4 (list Nat)) (x5 (list Nat))) bool))
  ((match x4
     (case nil true)
     (case
       (cons x6 xs2) (ite (elem x6 x5) (subset xs2 x5) (elem x6 x5))))))
(define-funs-rec
  ((union ((x (list Nat)) (x2 (list Nat))) (list Nat)))
  ((match x
     (case nil x2)
     (case
       (cons x3 xs)
       (ite (elem x3 x2) (union xs x2) (cons x3 (union xs x2)))))))
(assert
  (not
    (forall
      ((x12 (list Nat)) (y2 (list Nat)))
      (=> (subset x12 y2) (= (union x12 y2) y2)))))
(check-sat)
