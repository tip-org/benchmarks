; Source: IsaPlanner test suite
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((equal ((x5 Nat) (x6 Nat)) bool))
  ((match x5
     (case
       Z
       (match x6
         (case Z true)
         (case (S ipv) false)))
     (case
       (S ds)
       (match x6
         (case Z false)
         (case (S y2) (equal ds y2)))))))
(define-funs-rec
  ((count ((x3 Nat) (x4 (list Nat))) Nat))
  ((match x4
     (case nil Z)
     (case
       (cons y ys) (ite (equal x3 y) (S (count x3 ys)) (count x3 ys))))))
(define-funs-rec
  ((par (a3) (append ((x7 (list a3)) (x8 (list a3))) (list a3))))
  ((match x7
     (case nil x8)
     (case (cons x9 xs2) (cons x9 (as (append xs2 x8) (list a3)))))))
(define-funs-rec
  ((par (a2) (rev ((x (list a2))) (list a2))))
  ((match x
     (case nil x)
     (case
       (cons x2 xs)
       (append (as (rev xs) (list a2)) (cons x2 (as nil (list a2))))))))
(assert
  (not
    (forall
      ((n Nat) (xs3 (list Nat))) (= (count n xs3) (count n (rev xs3))))))
(check-sat)
