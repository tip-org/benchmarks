(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes ()
  ((Expr (Var (Var_0 Int))
     (Lam (Lam_0 Int) (Lam_1 Expr)) (App (App_0 Expr) (App_1 Expr)))))
(define-fun-rec
  zelem
    ((x Int) (y (list Int))) Bool
    (match y
      (case nil false)
      (case (cons z ys) (or (= x z) (zelem x ys)))))
(define-fun-rec
  new_maximum
    ((x Int) (y (list Int))) Int
    (match y
      (case nil x)
      (case (cons z ys)
        (ite (<= x z) (new_maximum z ys) (new_maximum x ys)))))
(define-fun new ((x (list Int))) Int (+ (new_maximum 0 x) 1))
(define-fun-rec
  (par (a)
    (filter
       ((x (=> a Bool)) (y (list a))) (list a)
       (match y
         (case nil (as nil (list a)))
         (case (cons z xs)
           (ite (@ x z) (cons z (filter x xs)) (filter x xs)))))))
(define-fun-rec
  (par (a)
    (append
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (append xs y)))))))
(define-fun-rec
  free
    ((x Expr)) (list Int)
    (match x
      (case (Var y) (cons y (as nil (list Int))))
      (case (Lam z b)
        (filter (lambda ((x2 Int)) (distinct z x2)) (free b)))
      (case (App a2 b2) (append (free a2) (free b2)))))
(define-fun-rec
  subst
    ((x Int) (y Expr) (z Expr)) Expr
    (match z
      (case (Var y2) (ite (= x y2) y z))
      (case (Lam y3 a)
        (let ((z2 (new (append (free y) (free a)))))
          (ite
            (= x y3) z
            (ite
              (zelem y3 (free y)) (subst x y (Lam z2 (subst y3 (Var z2) a)))
              (Lam y3 (subst x y a))))))
      (case (App c b2) (App (subst x y c) (subst x y b2)))))
(assert-not
  (forall ((x Int) (e Expr) (a Expr) (y Int))
    (=> (zelem x (free a))
      (=
        (zelem y
          (append (filter (lambda ((z Int)) (distinct z x)) (free a))
            (free e)))
        (zelem y (free (subst x e a)))))))
(check-sat)
