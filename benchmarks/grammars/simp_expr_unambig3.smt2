; Show function for a simple expression language
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Tok ((C) (D) (X) (Y) (Pl)))
(declare-datatype
  E ((Plus (proj1-Plus E) (proj2-Plus E)) (EX) (EY)))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  lin
  ((x E)) (list Tok)
  (match x
    (((Plus a b)
      (++ (cons C (_ nil Tok))
        (++ (lin a) (++ (cons D (cons Pl (_ nil Tok))) (lin b)))))
     (EX (cons X (_ nil Tok)))
     (EY (cons Y (_ nil Tok))))))
(prove (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v))))
