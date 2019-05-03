; Property from "Case-Analysis for Rippling and Inductive Proof",
; Moa Johansson, Lucas Dixon and Alan Bundy, ITP 2010
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
  take
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    ((Z (_ nil a))
     ((S z)
      (match y
        ((nil (_ nil a))
         ((cons x2 x3) (cons x2 (take z x3)))))))))
(define-fun-rec
  len
  (par (a) (((x (list a))) Nat))
  (match x
    ((nil Z)
     ((cons y xs) (S (len xs))))))
(define-fun-rec
  drop
  (par (a) (((x Nat) (y (list a))) (list a)))
  (match x
    ((Z y)
     ((S z)
      (match y
        ((nil (_ nil a))
         ((cons x2 x3) (drop z x3))))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(prove
  (par (a b)
    (forall ((xs (list a)) (ys (list a)) (zs (list b)))
      (= (zip (++ xs ys) zs)
        (++ (zip xs (take (len xs) zs)) (zip ys (drop (len xs) zs)))))))
