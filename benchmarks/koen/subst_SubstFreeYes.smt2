(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes ()
  ((Expr (Var (Var_0 int))
     (Lam (Lam_0 int) (Lam_1 Expr)) (App (App_0 Expr) (App_1 Expr)))))
(define-funs-rec ((or2 ((x bool) (y bool)) bool)) ((ite x true y)))
(define-funs-rec
  ((new_maximum ((x int) (y (list int))) int))
  ((match y
     (case nil x)
     (case (cons z ys)
       (ite (<= x z) (new_maximum z ys) (new_maximum x ys))))))
(define-funs-rec
  ((new ((x (list int))) int)) ((+ (new_maximum 0 x) 1)))
(define-funs-rec
  ((par (t) (filter ((p (=> t bool)) (x (list t))) (list t))))
  ((match x
     (case nil x)
     (case (cons y z)
       (ite (@ p y) (cons y (filter p z)) (filter p z))))))
(define-funs-rec
  ((elem ((x int) (y (list int))) bool))
  ((match y
     (case nil false)
     (case (cons z ys) (or2 (= x z) (elem x ys))))))
(define-funs-rec
  ((par (a) (append ((x (list a)) (y (list a))) (list a))))
  ((match x
     (case nil y)
     (case (cons z xs) (cons z (append xs y))))))
(define-funs-rec
  ((free ((x Expr)) (list int)))
  ((match x
     (case (Var y) (cons y (as nil (list int))))
     (case (Lam z b)
       (filter (lambda ((x2 int)) (distinct z x2)) (free b)))
     (case (App c b2) (append (free c) (free b2))))))
(define-funs-rec
  ((subst ((x int) (y Expr) (z Expr)) Expr))
  ((match z
     (case (Var y2) (ite (= x y2) y z))
     (case (Lam y3 a)
       (ite
         (= x y3) z
         (ite
           (elem y3 (free y))
           (subst x
             y
             (Lam (new (append (free y) (free a)))
               (subst y3 (Var (new (append (free y) (free a)))) a)))
           (Lam y3 (subst x y a)))))
     (case (App c b2) (App (subst x y c) (subst x y b2))))))
(assert-not
  (forall ((x int) (e Expr) (a Expr) (y int))
    (=> (elem x (free a))
      (=
      (elem y
        (append (filter (lambda ((z int)) (distinct z x)) (free a))
          (free e)))
        (elem y (free (subst x e a)))))))
(check-sat)
