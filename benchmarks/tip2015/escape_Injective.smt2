; Escaping and unescaping
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Token (A) (B) (C) (D) (ESC) (P) (Q) (R))))
(define-funs-rec
  ((isSpecial ((x3 Token)) bool))
  ((match x3
     (case default false)
     (case ESC true)
     (case P true)
     (case Q true)
     (case R true))))
(define-funs-rec
  ((code ((x4 Token)) Token))
  ((match x4
     (case default x4)
     (case ESC x4)
     (case P A)
     (case Q B)
     (case R C))))
(define-funs-rec
  ((escape ((x (list Token))) (list Token)))
  ((match x
     (case nil x)
     (case
       (cons x2 xs)
       (ite
         (isSpecial x2) (cons ESC (cons (code x2) (escape xs)))
         (cons x2 (escape xs)))))))
(assert-not
  (forall
    ((xs2 (list Token)) (ys (list Token)))
    (=> (= (escape xs2) (escape ys)) (= xs2 ys))))
(check-sat)
