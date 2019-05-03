; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
;
; One way to prove this is to first show "Nick's lemma":
; len xs = len ys ==> zip xs ys ++ zip as bs = zip (xs ++ as) (ys ++ bs)
(declare-datatype
  pair (par (a b) ((pair2 (proj1-pair a) (proj2-pair b)))))
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Nat ((Z) (S (proj1-S Nat))))
(define-fun-rec
  zip
  (par (a b) (((x (list a)) (y (list b))) (list (pair a b))))
  (match x
    ((nil (_ nil (pair a b)))
     ((cons z x2)
      (match y
        ((nil (_ nil (pair a b)))
         ((cons x3 x4) (cons (pair2 z x3) (zip x2 x4)))))))))
(define-fun-rec
  len
  (par (a) (((x (list a))) Nat))
  (match x
    ((nil Z)
     ((cons y xs) (S (len xs))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  rev
  (par (a) (((x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (++ (rev xs) (cons y (_ nil a)))))))
(prove
  (par (a b)
    (forall ((xs (list a)) (ys (list b)))
      (=> (= (len xs) (len ys))
        (= (zip (rev xs) (rev ys)) (rev (zip xs ys)))))))
