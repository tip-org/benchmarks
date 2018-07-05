; Show unambiguity of the following grammar:
(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Tok (X) (Y) (Z))))
(declare-datatypes () ((B2 (SB (proj1-SB B2)) (ZB))))
(declare-datatypes () ((A2 (SA (proj1-SA A2)) (ZA))))
(declare-datatypes () ((S (A (proj1-A A2)) (B (proj1-B B2)))))
(define-fun-rec
  (par (a)
    (++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  linA
    ((x A2)) (list Tok)
    (match x
      (case (SA a)
        (++ (cons X (_ nil Tok)) (++ (linA a) (cons Y (_ nil Tok)))))
      (case ZA (cons X (cons Z (cons Y (_ nil Tok)))))))
(define-fun-rec
  linB
    ((x B2)) (list Tok)
    (match x
      (case (SB b)
        (++ (cons X (_ nil Tok))
          (++ (linB b) (cons Y (cons Y (_ nil Tok))))))
      (case ZB (cons X (cons Z (cons Y (cons Y (_ nil Tok))))))))
(define-fun
  linS
    ((x S)) (list Tok)
    (match x
      (case (A a) (linA a))
      (case (B b) (linB b))))
(prove (forall ((u S) (v S)) (=> (= (linS u) (linS v)) (= u v))))
