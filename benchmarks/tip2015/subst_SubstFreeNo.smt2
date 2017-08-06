(declare-datatypes (a)
  ((list :source |Prelude.[]| (nil :source |Prelude.[]|)
     (cons :source |Prelude.:| (head a) (tail (list a))))))
(declare-datatypes ()
  ((Expr :source Subst.Expr (Var :source Subst.Var (proj1-Var Int))
     (Lam :source Subst.Lam (proj1-Lam Int) (proj2-Lam Expr))
     (App :source Subst.App (proj1-App Expr) (proj2-App Expr)))))
(define-fun-rec
  new-maximum :let
    ((x Int) (y (list Int))) Int
    (match y
      (case nil x)
      (case (cons z ys)
        (ite (<= x z) (new-maximum z ys) (new-maximum x ys)))))
(define-fun
  new :source Subst.new ((x (list Int))) Int (+ (new-maximum 0 x) 1))
(define-fun-rec
  (par (a)
    (filter :let :source Prelude.filter
       ((p (=> a Bool)) (x (list a))) (list a)
       (match x
         (case nil (_ nil a))
         (case (cons y xs)
           (ite (@ p y) (cons y (filter p xs)) (filter p xs)))))))
(define-fun-rec
  (par (a)
    (elem :let :source Prelude.elem
       ((x a) (y (list a))) Bool
       (match y
         (case nil false)
         (case (cons z xs) (or (= z x) (elem x xs)))))))
(define-fun-rec
  (par (a)
    (++ :source Prelude.++
       ((x (list a)) (y (list a))) (list a)
       (match x
         (case nil y)
         (case (cons z xs) (cons z (++ xs y)))))))
(define-fun-rec
  free :source Subst.free
    ((x Expr)) (list Int)
    (match x
      (case (Var y) (cons y (_ nil Int)))
      (case (Lam z b)
        (filter (lambda ((x2 Int)) (distinct z x2)) (free b)))
      (case (App a2 b2) (++ (free a2) (free b2)))))
(define-fun-rec
  subst :source Subst.subst
    ((x Int) (y Expr) (z Expr)) Expr
    (match z
      (case (Var y2) (ite (= x y2) y z))
      (case (Lam y3 a)
        (let ((z2 (new (++ (free y) (free a)))))
          (ite
            (= x y3) z
            (ite
              (elem y3 (free y)) (subst x y (Lam z2 (subst y3 (Var z2) a)))
              (Lam y3 (subst x y a))))))
      (case (App a2 b2) (App (subst x y a2) (subst x y b2)))))
(prove
  :source Subst.prop_SubstFreeNo
  (forall ((x Int) (e Expr) (a Expr) (y Int))
    (=> (not (elem x (free a)))
      (= (elem y (free a)) (elem y (free (subst x e a)))))))
