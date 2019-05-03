(declare-datatype
  list (par (a) ((nil) (cons (head a) (tail (list a))))))
(declare-datatype
  Expr
  ((Var (proj1-Var Int)) (Lam (proj1-Lam Int) (proj2-Lam Expr))
   (App (proj1-App Expr) (proj2-App Expr))))
(define-fun-rec
  new-maximum
  ((x Int) (y (list Int))) Int
  (match y
    ((nil x)
     ((cons z ys)
      (ite (<= x z) (new-maximum z ys) (new-maximum x ys))))))
(define-fun
  new
  ((x (list Int))) Int (+ (new-maximum 0 x) 1))
(define-fun-rec
  filter
  (par (a) (((p (=> a Bool)) (x (list a))) (list a)))
  (match x
    ((nil (_ nil a))
     ((cons y xs) (ite (@ p y) (cons y (filter p xs)) (filter p xs))))))
(define-fun-rec
  elem
  (par (a) (((x a) (y (list a))) Bool))
  (match y
    ((nil false)
     ((cons z xs) (or (= z x) (elem x xs))))))
(define-fun-rec
  ++
  (par (a) (((x (list a)) (y (list a))) (list a)))
  (match x
    ((nil y)
     ((cons z xs) (cons z (++ xs y))))))
(define-fun-rec
  free
  ((x Expr)) (list Int)
  (match x
    (((Var y) (cons y (_ nil Int)))
     ((Lam z b) (filter (lambda ((x2 Int)) (distinct z x2)) (free b)))
     ((App a2 b2) (++ (free a2) (free b2))))))
(define-fun-rec
  subst
  ((x Int) (y Expr) (z Expr)) Expr
  (match z
    (((Var y2) (ite (= x y2) y z))
     ((Lam y3 a)
      (let ((z2 (new (++ (free y) (free a)))))
        (ite
          (= x y3) z
          (ite
            (elem y3 (free y)) (subst x y (Lam z2 (subst y3 (Var z2) a)))
            (Lam y3 (subst x y a))))))
     ((App a2 b2) (App (subst x y a2) (subst x y b2))))))
(prove
  (forall ((x Int) (e Expr) (a Expr) (y Int))
    (=> (not (elem x (free a)))
      (= (elem y (free a)) (elem y (free (subst x e a)))))))
