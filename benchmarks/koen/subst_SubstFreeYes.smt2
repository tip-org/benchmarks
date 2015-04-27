(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes ()
  ((Expr (Var (Var_0 int))
     (Lam (Lam_0 int) (Lam_1 Expr)) (App (App_0 Expr) (App_1 Expr)))))
(define-funs-rec
  ((par (t) (x ((p (=> t bool)) (y (list t))) (list t))))
  ((match y
     (case nil y)
     (case (cons z x2) (ite (@ p z) (cons z (x p x2)) (x p x2))))))
(define-funs-rec ((or2 ((y bool) (z bool)) bool)) ((ite y true z)))
(define-funs-rec
  ((maximum ((y int) (z (list int))) int))
  ((match z
     (case nil y)
     (case (cons y2 ys)
       (ite (<= y y2) (maximum y2 ys) (maximum y ys))))))
(define-funs-rec
  ((new ((y (list int))) int)) ((+ (maximum 0 y) 1)))
(define-funs-rec
  ((elem ((y int) (z (list int))) bool))
  ((match z
     (case nil false)
     (case (cons y2 ys) (or2 (= y y2) (elem y ys))))))
(define-funs-rec
  ((par (a) (append ((y (list a)) (z (list a))) (list a))))
  ((match y
     (case nil z)
     (case (cons x2 xs) (cons x2 (append xs z))))))
(define-funs-rec
  ((free ((y Expr)) (list int)))
  ((match y
     (case (Var z) (cons z (as nil (list int))))
     (case (Lam x2 b) (x (lambda ((x3 int)) (distinct x2 x3)) (free b)))
     (case (App c b2) (append (free c) (free b2))))))
(define-funs-rec
  ((subst ((y int) (z Expr) (x2 Expr)) Expr))
  ((match x2
     (case (Var y2) (ite (= y y2) z x2))
     (case (Lam y3 a)
       (ite
         (= y y3) x2
         (ite
           (elem y3 (free z))
           (subst y
             z
             (Lam (new (append (free z) (free a)))
               (subst y3 (Var (new (append (free z) (free a)))) a)))
           (Lam y3 (subst y z a)))))
     (case (App c b2) (App (subst y z c) (subst y z b2))))))
(assert-not
  (forall ((y int) (e Expr) (a Expr) (z int))
    (=> (elem y (free a))
      (=
      (elem z
        (append (x (lambda ((x2 int)) (distinct x2 y)) (free a)) (free e)))
        (elem z (free (subst y e a)))))))
(check-sat)
