module Main (main) where

import TestUtils
import EvalIntExpr (testEvalIntExpr)
import EvalIdExpr (testEvalIdExpr)
import EvalMaybeExpr (testEvalMaybeExpr)
import PostfixExpr (testPostfixExpr)

import Test.QuickCheck

---------------------------- toSingletonLists ---------------------------
-- #1: 5-points
-- Use the map function to transform a list of elements e into
-- a list of singleton lists [e].  *Must use map*.
-- Hint: use map with a section.
toSingletonLists :: [e] -> [[e]]
toSingletonLists _ = error "TODO"

testToSingletonLists = do
  print "******* toSingletonLists"
  quickCheck $ counterexample "ints" $
    toSingletonLists [ 5, 7, 2 ] == [ [5], [7], [2] ]
  quickCheck $ counterexample "chars" $
    toSingletonLists [ 'a', 'x', 'd' ] == [ "a", "x", "d" ]
  quickCheck $ counterexample "empty" $
    toSingletonLists [] == ([] :: [[Int]])

--------------------------------- listMap -------------------------------
-- #2: 5-points
-- Return a list containing f a b for each element b in list.
-- Hint: use the map function or a list comprehension
listMap :: (a -> b -> c) -> a -> [b] -> [c]
listMap _ _ _ = error "TODO"

testListMap = do
  print "******* listMap"
  quickCheck $ counterexample "add" $ listMap (+) 5 [1, 2, 3] == [6, 7, 8]
  quickCheck $ counterexample "sub" $ listMap (-) 5 [1, 2, 3] == [4, 3, 2]
  quickCheck $ counterexample "mul" $ listMap (*) 5 [1, 2, 3] == [5, 10, 15]
  quickCheck $ counterexample "empty" $ listMap (-) 5 [] == []

---------------------------------- member -------------------------------
-- #3: 10-points
-- Use foldl to implement member e list which returns True iff
-- e is a member of list.  *Must use foldl*, cannot use elem
-- Hint: define folding function using a lambda or local let/where definition;
-- also see definition of member in slides.
member :: Eq e => e -> [e] -> Bool
member _ _ = error "TODO"

testMember = do
  print "******* member"
  quickCheck $ counterexample "ints first" $  member 5 [ 5, 7, 2 ] == True
  quickCheck $ counterexample "ints last" $  member 2 [ 5, 7, 2 ] == True
  quickCheck $ counterexample "ints mid" $  member 7 [ 5, 7, 2 ] == True
  quickCheck $ counterexample "ints fail" $  member 4 [ 5, 7, 2 ] == False
  quickCheck $ counterexample "empty" $  member 4 [] == False

------------------------------- selectNApart ----------------------------
-- #4: 10-points
-- Given an Int n and a list of elements e, return a list
-- containing the elements of the list at index 0, n, 2n, 3n, 4n, ...
-- Hint: use drop
selectNApart :: Int -> [e] -> [e]
selectNApart _ _ = error "TODO"


testSelectNApart = do
  print "******* selectNApart"
  quickCheck $ counterexample "2-apart" $
    selectNApart 2 [0..10] == [0, 2, 4, 6, 8, 10]
  quickCheck $ counterexample "2-apart chars" $
    selectNApart 2 ['a'..'z'] == "acegikmoqsuwy"
  quickCheck $ counterexample "3-apart" $
    selectNApart 3 [0..20] == [0, 3, 6, 9, 12, 15, 18]
  quickCheck $ counterexample "5-apart" $
    selectNApart 5 [0..21] == [0, 5, 10, 15, 20]
  quickCheck $ counterexample "empty" $ selectNApart 5 ([]::[Int]) == []

------------------------ Functions in Separate Files --------------------

-- #5: 15-points
-- implement the specified function in EvalIntExpr.hs

-- #6: 15-points
-- implement the specified function in EvalIdExpr.hs

-- #7: 20-points
-- implement the specified function in EvalMaybeExpr.hs

-- #8: 20-points
-- implement the specified function in PostfixExpr.hs

--------------------------------- Tests ---------------------------------

-- Can mark test suites with following test statuses:
--   Only:  run only these tests and other tests marked Only.
--   Run:   run these tests when no tests are marked Only.
--   Skip:  skip these tests.
allTests = [
    (Skip testToSingletonLists),
    (Skip testListMap),
    (Skip testMember),
    (Skip testSelectNApart),
    (Skip testEvalIntExpr),
    (Skip testEvalIdExpr),
    (Skip testEvalMaybeExpr),
    (Skip testPostfixExpr)
  ]


main = do
  mapM_ id tests
  where
    only = onlyTests allTests
    tests = if (length only > 0) then only else runTests allTests
  
