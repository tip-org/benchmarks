; An example from Packrat Parsing (ICFP 2002)
(declare-datatypes
  (a) ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (X) (Y) (Z))))
(declare-datatypes () ((B2 (SB (SB_ B2)) (ZB))))
(declare-datatypes () ((A2 (SA (SA_ A2)) (ZA))))
(declare-datatypes () ((S (A (A_ A2)) (B (B_ B2)))))
(define-funs-rec
  ((par (a3) (append ((x4 (list a3)) (x5 (list a3))) (list a3))))
  ((match x4
     (case nil x5)
     (case (cons x6 xs) (cons x6 (as (append xs x5) (list a3)))))))
(define-funs-rec
  ((linA ((x3 A2)) (list Tok)))
  ((match x3
     (case
       (SA a4)
       (append
         (append (cons X (as nil (list Tok))) (linA a4))
         (cons Y (as nil (list Tok)))))
     (case ZA (cons X (cons Z (cons Y (as nil (list Tok)))))))))
(define-funs-rec
  ((linB ((x2 B2)) (list Tok)))
  ((match x2
     (case
       (SB b2)
       (append
         (append (cons X (as nil (list Tok))) (linB b2))
         (cons Y (cons Y (as nil (list Tok))))))
     (case
       ZB (cons X (cons Z (cons Y (cons Y (as nil (list Tok))))))))))
(define-funs-rec
  ((linS ((x S)) (list Tok)))
  ((match x
     (case (A a2) (linA a2))
     (case (B b) (linB b)))))
(assert
  (not (forall ((u S) (v S)) (=> (= (linS u) (linS v)) (= u v)))))
(check-sat)
