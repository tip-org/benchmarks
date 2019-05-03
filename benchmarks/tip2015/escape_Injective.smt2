; Escaping and unescaping
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Token ((A) (B) (C) (D) (ESC) (P) (Q) (R)))
(define-fun
  isSpecial
  ((x Token)) Bool
  (match x
    ((_ false)
     (ESC true)
     (P true)
     (Q true)
     (R true))))
(define-fun
  code
  ((x Token)) Token
  (match x
    ((_ x)
     (ESC ESC)
     (P A)
     (Q B)
     (R C))))
(define-fun-rec
  escape
  ((x (list Token))) (list Token)
  (match x
    ((nil (_ nil Token))
     ((cons y xs)
      (ite
        (isSpecial y) (cons ESC (cons (code y) (escape xs)))
        (cons y (escape xs)))))))
(prove
  (forall ((xs (list Token)) (ys (list Token)))
    (=> (= (escape xs) (escape ys)) (= xs ys))))
