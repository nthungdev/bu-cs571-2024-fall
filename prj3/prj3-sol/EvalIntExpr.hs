module EvalIntExpr ( evalIntExpr, testEvalIntExpr, IntExpr(..) ) where

import Test.QuickCheck

-- an IntExpr is an expression-tree over integers
data IntExpr =
  Leaf Int |
  Add IntExpr IntExpr |
  Sub IntExpr IntExpr |
  Mul IntExpr IntExpr |
  Uminus IntExpr
  deriving (Eq, Show)

-- evalIntExpr returns the Int result of evaluating the IntExpr
-- expression-tree given by its argument.
evalIntExpr :: IntExpr -> Int
evalIntExpr _ = error "TODO"


testEvalIntExpr = do
  print "******* test evalIntExpr"

  quickCheck $ counterexample "Leaf" $ evalIntExpr (Leaf 42) == 42
  quickCheck $ counterexample "Add" $
    evalIntExpr (Add (Leaf 33) (Leaf 22)) == 55
  quickCheck $ counterexample "Sub" $
    evalIntExpr (Sub (Leaf 33) (Leaf 22)) == 11
  quickCheck $ counterexample "Mul" $
    evalIntExpr (Mul (Leaf 31) (Leaf 4)) == 124
  quickCheck $ counterexample "Uminus" $
    evalIntExpr (Uminus (Leaf 33)) == (-33)
  quickCheck $ counterexample "Complex" $
    evalIntExpr (Mul (Leaf 4)
                  (Sub (Add (Leaf 3) (Uminus (Leaf 33)))
                    (Leaf 20))) == (-200)

  -- property-based tests
  -- commutativity
  quickCheck $ counterexample "e1 + e2 == e2 + e1" $
    (\ e1 e2 -> 
        evalIntExpr (Add (Leaf e1) (Leaf e2)) ==
        evalIntExpr (Add (Leaf e2) (Leaf e1)))
  quickCheck $ counterexample "e1 * e2 == e2 * e1" $
    (\ e1 e2 -> 
        evalIntExpr (Mul (Leaf e1) (Leaf e2)) ==
        evalIntExpr (Mul (Leaf e2) (Leaf e1)))
  -- associativity
  quickCheck $ counterexample "(e1 + e2) + e3 == e1 + (e2 + e3)" $
    (\ e1 e2 e3 -> 
        evalIntExpr (Add (Add (Leaf e1) (Leaf e2)) (Leaf e3)) ==
        evalIntExpr (Add (Leaf e1) (Add (Leaf e2) (Leaf e3))))
  quickCheck $ counterexample "(e1 * e2) * e3 == e1 * (e2 * e3)" $
    (\ e1 e2 e3 ->
        evalIntExpr (Mul (Mul (Leaf e1) (Leaf e2)) (Leaf e3)) ==
        evalIntExpr (Mul (Leaf e1) (Mul (Leaf e2) (Leaf e3))))

  -- subtraction
  quickCheck $ counterexample "e1 - e2 = -1*(e2 - e1)" $
    (\ e1 e2 ->
        evalIntExpr (Sub (Leaf e1) (Leaf e2)) ==
        evalIntExpr (Mul (Leaf (-1)) (Sub (Leaf e2) (Leaf e1))))

  -- distributivity
  quickCheck $ counterexample "e1 * (e2 + e3) == e1*e2 + e1*e3" $
    (\ e1 e2 e3 -> 
        evalIntExpr (Mul (Leaf e1) (Add (Leaf e2) (Leaf e3))) ==
        evalIntExpr (Add (Mul (Leaf e1) (Leaf e2)) 
                      (Mul (Leaf e1) (Leaf e3))))
  quickCheck $ counterexample "e1 * (e2 - e3) == e1*e2 - e1*e3" $
    (\ e1 e2 e3 -> 
        evalIntExpr (Mul (Leaf e1) (Sub (Leaf e2) (Leaf e3))) ==
        evalIntExpr (Sub (Mul (Leaf e1) (Leaf e2)) 
                      (Mul (Leaf e1) (Leaf e3))))
  


  
