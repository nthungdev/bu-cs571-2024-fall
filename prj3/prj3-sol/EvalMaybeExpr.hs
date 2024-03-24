module EvalMaybeExpr ( evalMaybeExpr, testEvalMaybeExpr ) where

import Test.QuickCheck
import Data.List (lookup)

data MaybeExpr =
  Id String |
  Leaf Int |
  Add MaybeExpr MaybeExpr |
  Sub MaybeExpr MaybeExpr |
  Mul MaybeExpr MaybeExpr |
  Uminus MaybeExpr
  deriving (Eq, Show)

type Assoc a = [ (String, a) ]

-- return a Maybe wrapping the results of evaluating expr, looking up
-- id's in assoc.  If an id is not found in assoc, then the function
-- should return Nothing. Hint: use Data.List.assoc imported above
-- and do notation.
evalMaybeExpr :: MaybeExpr -> Assoc Int -> Maybe Int
evalMaybeExpr _ _ = error "TODO"


testEvalMaybeExpr = do 
  print "*** test evalMaybeExpr"
  -- unit tests
  quickCheck $ counterexample "Leaf" $ evalMaybeExpr (Leaf 42) [] == Just 42
  quickCheck $ counterexample "Add" $
    evalMaybeExpr (Add (Leaf 33) (Leaf 22)) [] == Just 55
  quickCheck $ counterexample "Sub" $
    evalMaybeExpr (Sub (Leaf 33) (Leaf 22)) [] == Just 11
  quickCheck $ counterexample "Mul" $
    evalMaybeExpr (Mul (Leaf 31) (Leaf 4)) [] == Just 124
  quickCheck $ counterexample "Uminus" $
    evalMaybeExpr (Uminus (Leaf 33)) [] == Just (-33)
  quickCheck $ counterexample "Complex" $
    evalMaybeExpr (Mul (Leaf 4)
                 (Sub (Add (Leaf 3) (Uminus (Leaf 33)))
                   (Leaf 20))) [] == Just (-200)

  -- id unit tests
  quickCheck $ counterexample "ok id lookup" $
    evalMaybeExpr (Id "a") [("a", 42)] == Just 42
  quickCheck $ counterexample "fail id lookup" $
    evalMaybeExpr (Id "a") [("b", 42)] == Nothing
  quickCheck $ counterexample "id lookup: a: ok, b: fail" $
    evalMaybeExpr (Add (Id "a") (Id "b")) [("a", 42)] == Nothing
  quickCheck $ counterexample "id lookup: a: ok, b: ok" $
    evalMaybeExpr (Add (Id "a") (Id "b")) [("a", 42), ("b", 22)] == Just 64
  quickCheck $ counterexample "complex id lookup" $
    evalMaybeExpr (Mul (Id "a")
                 (Sub (Add (Id "b") (Uminus (Id "c")))
                   (Id "d")))
               [("a", 4), ("b", 3), ("c", 33), ("d", 20)] == Just (-200)

  -- property-based tests
  -- id lookup
  quickCheck $ counterexample "random id lookup ok" $
    (\ id1 val1 -> evalMaybeExpr (Id id1) [(id1, val1)] == Just val1)
  quickCheck $ counterexample "random id lookup fail" $
    (\ id1 val1 -> evalMaybeExpr (Id id1) [(id1 ++ "x", val1)] == Nothing)
  
  -- property-based tests
  -- commutativity
  quickCheck $ counterexample "e1 + e2 == e2 + e1" $
    (\ e1 e2 -> 
        evalMaybeExpr (Add (Leaf e1) (Leaf e2)) [] ==
        evalMaybeExpr (Add (Leaf e2) (Leaf e1)) [])
  quickCheck $ counterexample "e1 * e2 == e2 * e1" $
    (\ e1 e2 -> 
        evalMaybeExpr (Mul (Leaf e1) (Leaf e2)) [] ==
        evalMaybeExpr (Mul (Leaf e2) (Leaf e1)) [])
  -- associativity
  quickCheck $ counterexample "(e1 + e2) + e3 == e1 + (e2 + e3)" $
    (\ e1 e2 e3 -> 
        evalMaybeExpr (Add (Add (Leaf e1) (Leaf e2)) (Leaf e3)) [] ==
        evalMaybeExpr (Add (Leaf e1) (Add (Leaf e2) (Leaf e3))) [])
  quickCheck $ counterexample "(e1 * e2) * e3 == e1 * (e2 * e3)" $
    (\ e1 e2 e3 ->
        evalMaybeExpr (Mul (Mul (Leaf e1) (Leaf e2)) (Leaf e3)) [] ==
        evalMaybeExpr (Mul (Leaf e1) (Mul (Leaf e2) (Leaf e3))) [])

  -- subtraction
  quickCheck $ counterexample "e1 - e2 = -1*(e2 - e1)" $
    (\ e1 e2 ->
        evalMaybeExpr (Sub (Leaf e1) (Leaf e2)) [] ==
        evalMaybeExpr (Mul (Leaf (-1)) (Sub (Leaf e2) (Leaf e1))) [])

  -- distributivity
  quickCheck $ counterexample "e1 * (e2 + e3) == e1*e2 + e1*e3" $
    (\ e1 e2 e3 -> 
        evalMaybeExpr (Mul (Leaf e1) (Add (Leaf e2) (Leaf e3))) [] ==
        evalMaybeExpr (Add (Mul (Leaf e1) (Leaf e2)) 
                     (Mul (Leaf e1) (Leaf e3))) [])
  quickCheck $ counterexample "e1 * (e2 - e3) == e1*e2 - e1*e3" $
    (\ e1 e2 e3 -> 
        evalMaybeExpr (Mul (Leaf e1) (Sub (Leaf e2) (Leaf e3))) [] ==
        evalMaybeExpr (Sub (Mul (Leaf e1) (Leaf e2))  
                      (Mul (Leaf e1) (Leaf e3))) [])
