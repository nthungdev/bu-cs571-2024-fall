module PostfixExpr ( postfixExpr, testPostfixExpr, PostfixExpr(..) ) where

import Test.QuickCheck

-- a PostFixExpr is an expression tree over integers
data PostfixExpr =
  Leaf Int |
  Add PostfixExpr PostfixExpr |
  Sub PostfixExpr PostfixExpr |
  Mul PostfixExpr PostfixExpr |
  Uminus PostfixExpr
  deriving (Eq, Show)

-- Given a string postfix containing a postfix expression involving
-- integers, the usual binary arithmetic operators "+", "-", "*" as
-- well as "uminus", return the corresponding PostfixExpr.  You may
-- disregard errors.
--
-- Hints:
--
--   + Use the Haskell function (words postfix) to split the
--     postfix string into String tokens.
--
--   + Iterate through the tokens using a [PostfixExpr] stack to track
--     the currently unprocessed PostfixExpr's.
--
--   + At each step of the iteration, look at the first
--     unprocessed token:
--
--       + If it is a string representing an operator, then replace
--         its operands from the head of the stack with the
--         PostfixExpr corresponding to the operator combined with its
--         operands from the stack.
--
--       + If the current unprocessed token is not an operator, assume
--         it is an Int and use (read token) to build it into a
--         Leaf.
--
--    + Use pattern matching to match different types of tokens and to
--      extract PostfixExpr operands from the head of the stack.
--
--    + Use a local auxiliary function to perform each step of the
--      iteration.
--
--    + You can use a recursive implementation of the top-level
--      function.  But what is recommended is to set up your auxiliary
--      function so that you can use it to foldl the token list into
--      an accumulator representing the stack of unprocessed
--      PostfixExpr's.
--
--    + When there are no unprocessed tokens, the stack should contain
--      a single PostfixExpr containing the value to be returned.
postfixExpr :: String -> PostfixExpr
postfixExpr _ = error "TODO"

testPostfixExpr = do
  print "******* test postfixExpr"

  quickCheck $ counterexample "Leaf" $ postfixExpr "42" == (Leaf 42)
  quickCheck $ counterexample "Add" $
    postfixExpr "33 22 +" == (Add (Leaf 33) (Leaf 22))
  quickCheck $ counterexample "Sub" $
    postfixExpr "33 22 -" == (Sub (Leaf 33) (Leaf 22))
  quickCheck $ counterexample "Mul" $
    postfixExpr "31 4 *" == (Mul (Leaf 31) (Leaf 4))
  quickCheck $ counterexample "Uminus" $
    postfixExpr "33 uminus" == (Uminus (Leaf 33))
  quickCheck $ counterexample "Complex" $
    postfixExpr "4 3 33 uminus + 20 - *" ==
    (Mul
     (Leaf 4)
     (Sub (Add (Leaf 3) (Uminus (Leaf 33))) (Leaf 20)))
  


  
