module TestUtils (onlyTests, runTests, SuiteStatus(..)) where

type SuiteFn = IO ()

data SuiteStatus =
  Run SuiteFn |
  Skip SuiteFn |
  Only SuiteFn

onlyTests [] = []
onlyTests ((Only t):tests) = t : onlyTests tests
onlyTests (_:tests) = onlyTests tests

runTests [] = []
runTests ((Run t):tests) = t : runTests tests
runTests (_:tests) = runTests tests

