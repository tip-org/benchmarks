; Simple expression unambiguity
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (C) (D) (X) (Y) (Pl))))
(declare-datatypes () ((E (Plus (Plus_0 E) (Plus_1 E)) (EX) (EY))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (as (append xs y) (list a)))))))
(define-funs-rec
  ((lin ((x E)) (list Tok)))
  ((match x
     (case (Plus a b)
       (append
       (append (append (cons C (as nil (list Tok))) (lin a))
         (cons D (cons Pl (as nil (list Tok)))))
         (lin b)))
     (case EX (cons X (as nil (list Tok))))
     (case EY (cons Y (as nil (list Tok)))))))
(assert-not
  (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
(check-sat)
