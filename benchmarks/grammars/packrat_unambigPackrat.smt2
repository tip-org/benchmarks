; Show unambiguity of the following grammar:
(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype Tok ((X) (Y) (Z)))
(declare-datatype B2 ((SB (proj1-SB B2)) (ZB)))
(declare-datatype A2 ((SA (proj1-SA A2)) (ZA)))
(declare-datatype S ((A (proj1-A A2)) (B (proj1-B B2))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  linA
  ((x A2)) (list Tok)
  (match x
    (((SA a)
      (++ (cons X (_ nil Tok)) (++ (linA a) (cons Y (_ nil Tok)))))
     (ZA (cons X (cons Z (cons Y (_ nil Tok))))))))
(define-fun-rec
  linB
  ((x B2)) (list Tok)
  (match x
    (((SB b)
      (++ (cons X (_ nil Tok))
        (++ (linB b) (cons Y (cons Y (_ nil Tok))))))
     (ZB (cons X (cons Z (cons Y (cons Y (_ nil Tok)))))))))
(define-fun
  linS
  ((x S)) (list Tok)
  (match x
    (((A a) (linA a))
     ((B b) (linB b)))))
(prove (forall ((u S) (v S)) (=> (= (linS u) (linS v)) (= u v))))
