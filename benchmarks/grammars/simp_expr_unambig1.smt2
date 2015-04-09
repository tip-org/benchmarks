; Simple expression unambiguity
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (C) (D) (X) (Y) (Pl))))
(declare-datatypes () ((E (Plus (Plus_ E) (Plus_2 E)) (EX) (EY))))
(define-funs-rec
  ((par
     (a3)
     (append
        ((x2 (list a3)) (x3 (list a3))) (list a3)
        (match x2
          (case nil x3)
          (case (cons x4 xs) (cons x4 (as (append xs x3) (list a3)))))))))
(define-funs-rec
  ((lin
      ((x E)) (list Tok)
      (match x
        (case
          (Plus a2 b)
          (append
            (append
              (append
                (append (cons C (as nil (list Tok))) (lin a2))
                (cons Pl (as nil (list Tok))))
              (lin b))
            (cons D (as nil (list Tok)))))
        (case EX (cons X (as nil (list Tok))))
        (case EY (cons Y (as nil (list Tok))))))))
(assert
  (not (forall ((u E) (v E)) (=> (= (lin u) (lin v)) (= u v)))))
(check-sat)
