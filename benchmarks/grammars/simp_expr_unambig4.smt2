; Simple expression unambiguity
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (C) (D) (X) (Y) (Pl))))
(declare-datatypes () ((E (Plus (Plus_ E) (Plus_2 E)) (EX) (EY))))
(define-funs-rec
  ((par (a2) (append ((x3 (list a2)) (x4 (list a2))) (list a2))))
  ((match x3
     (case nil x4)
     (case (cons x5 xs) (cons x5 (as (append xs x4) (list a2)))))))
(define-funs-rec
  ((linTerm ((x E)) (list Tok))
   (lin ((x2 E)) (list Tok)))
  ((match x
     (case
       (Plus ds ds2)
       (append
         (append (cons C (as nil (list Tok))) (lin x))
         (cons D (as nil (list Tok)))))
     (case EX (cons X (as nil (list Tok))))
     (case EY (cons Y (as nil (list Tok)))))
   (match x2
     (case
       (Plus a3 b)
       (append
         (append (linTerm a3) (cons Pl (as nil (list Tok)))) (linTerm b)))
     (case EX (cons X (as nil (list Tok))))
     (case EY (cons Y (as nil (list Tok)))))))
(assert-not
  (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
(check-sat)
