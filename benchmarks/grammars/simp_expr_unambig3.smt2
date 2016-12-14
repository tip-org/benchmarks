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
(define-fun-rec
  lin
    ((x E)) (list Tok)
    (match x
      (case (Plus a b)
        (++ (cons C (as nil (list Tok)))
          (++ (lin a) (++ (cons D (cons Pl (as nil (list Tok)))) (lin b)))))
      (case EX (cons X (as nil (list Tok))))
      (case EY (cons Y (as nil (list Tok))))))
(assert-not
  (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
(check-sat)
