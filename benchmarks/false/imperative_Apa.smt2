(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  E
  ((N (proj1-N Int)) (Add (proj1-Add E) (proj2-Add E))
   (Mul (proj1-Mul E) (proj2-Mul E)) (Eq (proj1-Eq E) (proj2-Eq E))
   (V (proj1-V Int))))
(declare-datatype
  P
  ((Print (proj1-Print E)) (|:=| (|proj1-:=| Int) (|proj2-:=| E))
   (While (proj1-While E) (proj2-While (list P)))
   (If (proj1-If E) (proj2-If (list P)) (proj3-If (list P)))))
(define-fun-rec
  store
  ((x (list Int)) (y Int) (z Int)) (list Int)
  (match x
    ((nil
      (ite
        (= y 0) (cons z (_ nil Int))
        (cons 0 (store (_ nil Int) (- y 1) z))))
     ((cons n st)
      (ite (= y 0) (cons z st) (cons n (store st (- y 1) z)))))))
(define-fun-rec
  fetch
  ((x (list Int)) (y Int)) Int
  (match x
    ((nil 0)
     ((cons n st) (ite (= y 0) n (fetch st (- y 1)))))))
(define-fun-rec
  eval
  ((x (list Int)) (y E)) Int
  (match y
    (((N n) n)
     ((Add a b) (+ (eval x a) (eval x b)))
     ((Mul c b2) (* (eval x c) (eval x b2)))
     ((Eq a2 b3) (ite (= (eval x a2) (eval x b3)) 1 0))
     ((V z) (fetch x z)))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun
  opti
  ((x P)) P
  (match x
    (((While e p) (While e (++ p p)))
     ((If c q r) (If c r q))
     (_ x))))
(define-fun-rec
  run
  ((x (list Int)) (y (list P))) (list Int)
  (match y
    ((nil (_ nil Int))
     ((cons z r)
      (match z
        (((Print e) (cons (eval x e) (run x r)))
         ((|:=| x2 e2) (run (store x x2 (eval x e2)) r))
         ((While e3 p)
          (run x (cons (If e3 (++ p (cons z (_ nil P))) (_ nil P)) r)))
         ((If e4 q q2)
          (ite (= (eval x e4) 0) (run x (++ q2 r)) (run x (++ q r))))))))))
(prove
  (forall ((p P))
    (= (run (_ nil Int) (cons p (_ nil P)))
      (run (_ nil Int) (cons (opti p) (_ nil P))))))
