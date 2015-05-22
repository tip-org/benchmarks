; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
;
; One way to prove this is to first show "Nick's lemma":
; len xs = len ys ==> zip xs ys ++ zip as bs = zip (xs ++ as) (ys ++ bs)
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a b) ((Pair (Pair2 (first a) (second b)))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-funs-rec
  ((par (a b) (zip ((x (list a)) (y (list b))) (list (Pair a b)))))
  ((match x
     (case nil (as nil (list (Pair a b))))
     (case (cons z x2)
       (match y
         (case nil (as nil (list (Pair a b))))
         (case (cons x3 x4) (cons (Pair2 z x3) (zip x2 x4))))))))
(define-funs-rec
  ((par (a) (len ((x (list a))) Nat)))
  ((match x
     (case nil Z)
     (case (cons y xs) (S (len xs))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((par (a) (rev ((x (list a))) (list a))))
  ((match x
     (case nil (as nil (list a)))
     (case (cons y xs) (append (rev xs) (cons y (as nil (list a))))))))
(assert-not
  (par (a b)
    (forall ((xs (list a)) (ys (list b)))
      (=> (= (len xs) (len ys))
        (= (zip (rev xs) (rev ys)) (rev (zip xs ys)))))))
(check-sat)
