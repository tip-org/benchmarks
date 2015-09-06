(declare-datatypes (a)
  ((list (nil) (cons (head a) (tail (list a))))))
(declare-datatypes (a)
  ((Tree (TNode (TNode_0 (Tree a)) (TNode_1 a) (TNode_2 (Tree a)))
     (TNil))))
(declare-datatypes () ((Nat (Z) (S (p Nat)))))
(define-fun-rec
  (par (a)
    (length
       ((x (list a))) Nat
       (match x
         (case nil Z)
         (case (cons y xs) (S (length xs)))))))
(define-fun-rec
  le
    ((x Nat) (y Nat)) Bool
    (match x
      (case Z true)
      (case (S z)
        (match y
          (case Z false)
          (case (S x2) (le z x2))))))
(define-fun-rec
  (par (a)
    (flatten
       ((x (Tree a)) (y (list a))) (list a)
       (match x
         (case (TNode q z q2) (flatten q (cons z (flatten q2 y))))
         (case TNil y)))))
(define-fun-rec
  add
    ((x Nat) (y (Tree Nat))) (Tree Nat)
    (match y
      (case (TNode q z q2)
        (ite (le x z) (TNode (add x q) z q2) (TNode q z (add x q2))))
      (case TNil (TNode (as TNil (Tree Nat)) x (as TNil (Tree Nat))))))
(define-fun-rec
  toTree
    ((x (list Nat))) (Tree Nat)
    (match x
      (case nil (as TNil (Tree Nat)))
      (case (cons y xs) (add y (toTree xs)))))
(define-fun
  tsort
    ((x (list Nat))) (list Nat)
    (flatten (toTree x) (as nil (list Nat))))
(assert-not
  (forall ((xs (list Nat)) (ys (list Nat)))
    (or (distinct (tsort xs) (tsort ys))
      (or (= xs ys)
        (or
          (distinct (length xs)
            (S
              (S
                (S
                  (S
                    (S
                      (S
                        (S
                          (S
                            (S
                              (S
                                (S
                                  (S
                                    (S
                                      (S
                                        (S
                                          (S
                                            (S
                                              (S
                                                (S
                                                  (S
                                                    (S
                                                      (S
                                                        (S (S (S (S (S Z))))))))))))))))))))))))))))
          (distinct (length ys)
            (S
              (S
                (S
                  (S
                    (S
                      (S
                        (S
                          (S
                            (S
                              (S
                                (S
                                  (S
                                    (S
                                      (S
                                        (S
                                          (S
                                            (S
                                              (S
                                                (S
                                                  (S
                                                    (S
                                                      (S
                                                        (S
                                                          (S
                                                            (S
                                                              (S
                                                                (S
                                                                  Z)))))))))))))))))))))))))))))))))
(check-sat)
