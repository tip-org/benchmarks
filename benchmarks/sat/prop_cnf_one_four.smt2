(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(declare-datatypes ()
  ((Prop (Not (Not_0 Prop))
     (Var (Var_0 Nat)) (And (And_0 Prop) (And_1 Prop))
     (Or (Or_0 Prop) (Or_1 Prop)) (Const (Const_0 Bool)))))
(declare-datatypes (a) ((Maybe (Nothing) (Just (Just_0 a)))))
(define-fun
  var
    ((x Prop)) Bool
    (match x
      (case default false)
      (case (Var y) true)))
(define-fun-rec
  (par (a)
    (index
       ((x (list a)) (y Nat)) (Maybe a)
       (match x
         (case nil (as Nothing (Maybe a)))
         (case (cons z xs)
           (match y
             (case Z (Just z))
             (case (S n) (index xs n))))))))
(define-fun-rec
  eval
    ((x (list Bool)) (y Prop)) Bool
    (match y
      (case (Not q) (not (eval x q)))
      (case (Var z)
        (match (index x z)
          (case Nothing false)
          (case (Just y2) y2)))
      (case (And p1 p2) (and (eval x p1) (eval x p2)))
      (case (Or p12 p22) (or (eval x p12) (eval x p22)))
      (case (Const c) c)))
(define-fun
  atom
    ((x Prop)) Bool
    (match x
      (case default (var x))
      (case (Not y) (var y))))
(define-fun-rec
  disj
    ((x Prop)) Bool
    (match x
      (case default (atom x))
      (case (Or y z) (and (atom y) (disj z)))))
(define-fun-rec
  cnf
    ((x Prop)) Bool
    (match x
      (case default (disj x))
      (case (And y z) (and (disj y) (cnf z)))))
(assert-not
  (forall ((e Prop))
    (or (not (cnf e))
      (or
        (eval
          (cons true
            (cons true (cons true (cons true (as nil (list Bool))))))
          e)
        (or
          (eval
            (cons true
              (cons true (cons true (cons false (as nil (list Bool))))))
            e)
          (or
            (eval
              (cons true
                (cons true (cons false (cons true (as nil (list Bool))))))
              e)
            (or
              (eval
                (cons true
                  (cons true (cons false (cons false (as nil (list Bool))))))
                e)
              (or
                (eval
                  (cons true
                    (cons false (cons true (cons true (as nil (list Bool))))))
                  e)
                (or
                  (eval
                    (cons true
                      (cons false (cons true (cons false (as nil (list Bool))))))
                    e)
                  (or
                    (eval
                      (cons true
                        (cons false (cons false (cons true (as nil (list Bool))))))
                      e)
                    (or
                      (not
                        (eval
                          (cons true
                            (cons false (cons false (cons false (as nil (list Bool))))))
                          e))
                      (or
                        (eval
                          (cons false
                            (cons true (cons true (cons true (as nil (list Bool))))))
                          e)
                        (or
                          (eval
                            (cons false
                              (cons true (cons true (cons false (as nil (list Bool))))))
                            e)
                          (or
                            (eval
                              (cons false
                                (cons true (cons false (cons true (as nil (list Bool))))))
                              e)
                            (or
                              (not
                                (eval
                                  (cons false
                                    (cons true (cons false (cons false (as nil (list Bool))))))
                                  e))
                              (or
                                (eval
                                  (cons false
                                    (cons false (cons true (cons true (as nil (list Bool))))))
                                  e)
                                (or
                                  (not
                                    (eval
                                      (cons false
                                        (cons false (cons true (cons false (as nil (list Bool))))))
                                      e))
                                  (or
                                    (not
                                      (eval
                                        (cons false
                                          (cons false
                                            (cons false (cons true (as nil (list Bool))))))
                                        e))
                                    (eval
                                      (cons false
                                        (cons false (cons false (cons false (as nil (list Bool))))))
                                      e)))))))))))))))))))
(check-sat)
