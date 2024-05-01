# Homework 4 solutions

Name: Hung Nguyen

B-ID: B01037287

## Question 1

C uses nominal equivalence (two types are equivalent iff they have the same name) to compare types while TypeScript uses structural equivalence (two types are equivalent iff they consist of the same type constructor applied to structurally equivalent types).

T1 and T2 have different names, hence the code doesn't compile in C, but they do in TypeScript because they have the same structure.

## Question 2

```text
33 12
33 9
```

When `f()` is called, lexical `a` is initialized (line 5), dynamic `x` is initialized (line 6), then enters `g()`.
When line 13 is executed,
`a` = 33 because `g()` accesses the value of `a` defined in the outer scope at line 1.
`x` = 12 because `g()` accesses the value of `x` defined in `f()` at line 6.

At line 20,
`a` = 33 because `print()` accesses the value of `a` defined in the outer scope at line 1.
`x` = 9 because `print()` accesses the value of `x` set recently by `f()` at line 9.

## Question 3



## Question 4
## Question 5