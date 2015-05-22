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
(assert-not
  (forall ((xs (list Token)) (ys (list Token)))
    (=> (= (escape xs) (escape ys)) (= xs ys))))
(check-sat)
