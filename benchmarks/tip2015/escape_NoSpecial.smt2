; Escaping and unescaping
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Token (A) (B) (C) (D) (ESC) (P) (Q) (R))))
(define-funs-rec
  ((isSpecial ((x Token)) Bool))
  ((match x
     (case default false)
     (case ESC true)
     (case P true)
     (case Q true)
     (case R true))))
(define-funs-rec
  ((isEsc ((x Token)) Bool))
  ((match x
     (case default false)
     (case ESC true))))
(define-funs-rec
  ((ok ((x Token)) Bool)) ((or (not (isSpecial x)) (isEsc x))))
(define-funs-rec
  ((code ((x Token)) Token))
  ((match x
     (case default x)
     (case ESC ESC)
     (case P A)
     (case Q B)
     (case R C))))
(define-funs-rec
  ((escape ((x (list Token))) (list Token)))
  ((match x
     (case nil (as nil (list Token)))
     (case (cons y xs)
       (ite
         (isSpecial y) (cons ESC (cons (code y) (escape xs)))
         (cons y (escape xs)))))))
(define-funs-rec
  ((par (a) (all ((x (=> a Bool)) (y (list a))) Bool)))
  ((match y
     (case nil true)
     (case (cons z xs) (and (@ x z) (all x xs))))))
(assert-not
  (forall ((xs (list Token)))
    (all (lambda ((x Token)) (ok x)) (escape xs))))
(check-sat)
