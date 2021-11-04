; Lemmas from "Productive Use of Failure in Inductive Proof",
; Andrew Ireland and Alan Bundy, JAR 1996
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  drop
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    ((Z y)
     ((S z)
      (match y
        ((nil (_ nil a))
         ((cons x2 x3) (drop z x3))))))))
(prove
  (par (a)
    (forall ((v Nat) (w Nat) (x a) (y a) (zs (list a)))
      (= (drop (S v) (drop (S w) (cons x (cons y zs))))
        (drop (S v) (drop w (cons x zs)))))))
