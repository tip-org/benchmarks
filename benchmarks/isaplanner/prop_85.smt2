; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
;
; One way to prove this is to first show "Nick's lemma":
; len xs = len ys ==> zip xs ys ++ zip as bs = zip (xs ++ as) (ys ++ bs)
(declare-datatypes (a b)
  ((pair (pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (proj1-S Nat)))))
(define-fun-rec
  (par (a b)
    (zip
       ((x (list a)) (y (list b))) (list (pair a b))
       (match x
         (case nil (_ nil (pair a b)))
         (case (cons z x2)
           (match y
             (case nil (_ nil (pair a b)))
             (case (cons x3 x4) (cons (pair2 z x3) (zip x2 x4)))))))))
(define-fun-rec
  (par (a)
    (len
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (len xs)))))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  (par (a)
    (rev
       ((x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs) (++ (rev xs) (cons y (_ nil a))))))))
(prove
  (par (a b)
    (forall ((xs (list a)) (ys (list b)))
      (=> (= (len xs) (len ys))
        (= (zip (rev xs) (rev ys)) (rev (zip xs ys)))))))
