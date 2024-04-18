# Homework 3 solutions

## Question 1

### 1a `[0|1].`

### 1b `[0, 1].`

```haskell
0:1:[]
```

This is allowed by Haskell.

### 1c `[0|[1]].`

```haskell
0:1:[]
```

This is allowed by Haskell.

### 1d `[0, [1]].`

This is not allowed by Haskell because lists must be homogeneous.

### 1e `[0|[1|[2|[]]]].`

```haskell
0:1:2[]
```

This is allowed by Haskell.

## Question 2

