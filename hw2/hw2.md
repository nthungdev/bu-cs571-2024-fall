# Homework 2

## 1

### 1a

(setq D (cons 1 (cons (cons 2 3) (cons (cons 4 5) ()))))

### 1b

(cdr (car (cdr D)))

## 2

![tree](question-2-image.png)

1. (cons 'c '())
2. (cons 'b (cons 'c '()))
3. (cons 'd '())
4. (cons (cons 'b (cons 'c '())) (cons 'd '()))
5. (cons 'a (cons (cons 'b (cons 'c '())) (cons 'd '())))

// TODO label the tree of numbers

## 3

### 3a

14 bytes

### 3b

12 bytes

### 3c

#### 3c i

offset 196

#### 3c ii

offset 202

#### 3c iii

offset 154

## 4

Check for the number of leading 1's in the byte pointed by p.

If it starts with 10, then this is one of the continuation bytes in the byte array. Skip to the preceding byte and continue checking.

Else, the number of leading 1's indicates the total number of bytes in the byte array.

Now we are at the start of the array and we know how long the array spans, we can convert to Unicode character.

## 5

Arithmetic overflow in C is undefined behavior, there could be 2 possibility:

1. Results in a wrapped around value. In this case we can check whether k is less than either i or j or not. If it does, then we have overflow.
2. Results in a negative number. In this case we can check whether k is < 0 or not. If it does, then we have overflow.

## 6
