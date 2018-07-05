; Show function for a simple expression language
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (C) (D) (X) (Y) (Pl))))
(declare-datatypes ()
  ((E (Plus (proj1-Plus E) (proj2-Plus E)) (EX) (EY))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-funs-rec
  ((linTerm ((x E)) (list Tok))
   (lin ((x E)) (list Tok)))
  ((match x
     (case (Plus y z)
       (++ (cons C (_ nil Tok)) (++ (lin x) (cons D (_ nil Tok)))))
     (case EX (cons X (_ nil Tok)))
     (case EY (cons Y (_ nil Tok))))
   (match x
     (case (Plus a b)
       (++ (linTerm a) (++ (cons Pl (_ nil Tok)) (linTerm b))))
     (case EX (cons X (_ nil Tok)))
     (case EY (cons Y (_ nil Tok))))))
(prove (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
