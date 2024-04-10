#!/usr/bin/env -S swipl
%-*- mode: prolog; -*-

:- module(prj4_sol, [
      sublist_lengths/2,
      same_length_sublists/1,
      fibonacci_sublists/1,
      assoc_lookup/3,
      assoc_replace/3,
      add_to_plus_expr/2,
      named_to_op_expr/2,
      named_expr_eval/2,
      named_expr_to_prefix_tokens/2,
      op_expr_to_prefix_tokens/2
  ]).

%%%%%%%%%%%%%%%%%%%%%%%%%%% sublist_lengths/2 %%%%%%%%%%%%%%%%%%%%%%%%%%%

% #1: 10-points

% sublist_lengths(List, Lengths) should succeed iff List is a list
% containing sub-lists and Lengths is a list having the same length
% as List and whose elements are the lengths of the corresponding
% sub-list in List.  You may assume that all the elements of List
% are sub-lists.
sublist_lengths(_List, _Lengths) :- 'TODO'.

:-begin_tests(sublist_lengths, [blocked('TODO')]).
test(empty, [nondet]) :-
    sublist_lengths([], Lengths), Lengths = [].
test(sublist_lengths1, [nondet]) :-
    sublist_lengths([[a, b]], Lengths), Lengths = [2].
test(sublist_lengths3, [nondet]) :-
    sublist_lengths([[2], [a, b], [x, y, z]], Lengths), Lengths = [1, 2, 3].
test(sublist_lengths_var_list, [nondet]) :-
    sublist_lengths(List, [1, 2, 3]), length(List, 3).
:-end_tests(sublist_lengths).

%%%%%%%%%%%%%%%%%%%%%%%%% same_length_sublists/1 %%%%%%%%%%%%%%%%%%%%%%%%

% #2: 10-points

% same_length_sublists(List): succeed only iff all the sublists in
% List have the same length.  You may assume that all the elements of
% List are sub-lists.  The procedure should succeed for an empty List.
%
% *Hint*: use an auxiliary procedure.
same_length_sublists(_List) :- 'TODO'.

:-begin_tests(same_length_sublists, [blocked('TODO')]).
test(empty, [nondet]) :-
    same_length_sublists([]).
test(empties, [nondet]) :-
    same_length_sublists([[], [], []]).
test(empties_fail, [fail]) :-
    same_length_sublists([[], [2], []]).
test(sublists1, [nondet]) :-
    same_length_sublists([[[a, 2]], [[]], [c]]).
test(sublists1_fail, [fail]) :-
    same_length_sublists([[a], [[]], [c, 2]]).
test(sublists3, [nondet]) :-
    same_length_sublists([[a, [2], 4], [b, 5, [1]], [3, 2, c]]).
test(sublists3_fail, [fail]) :-
    same_length_sublists([[a, 2, 4], [b, 5, 1], [3, [2, c]]]).
:-end_tests(same_length_sublists).


%%%%%%%%%%%%%%%%%%%%%%%%%% fibonacci_sublists/1 %%%%%%%%%%%%%%%%%%%%%%%%%

% #3: 10-points

% fibonacci_sublists(List) should succeed iff List is a list of
% sublists whose lengths have a Fibonacci relationship; i.e.
% length(List[i]) == length(List[i-2]) + length(List[i-1])
% where List[i] is the sublist at index i in List.  You may
% assume that List contains only sublists.  The procedure
% should trivially succeed if the length of List is < 3.
fibonacci_sublists(_List) :- 'TODO'.

:-begin_tests(fibonacci_sublists, [blocked('TODO')]).
test(empty, [nondet]) :-
    fibonacci_sublists([]).
test(zero, [nondet]) :-
    fibonacci_sublists([[]]).
test(one, [nondet]) :-
    fibonacci_sublists([[], [a]]).
test(two, [nondet]) :-
    fibonacci_sublists([[], [a], [c]]).
test(three, [nondet]) :-
    fibonacci_sublists([[], [a], [c], [a, c]]).
test(three_fail, [fail]) :-
    fibonacci_sublists([[], [a], [c], [a, c, c]]).
test(four, [nondet]) :-
    fibonacci_sublists([[], [a], [c], [a, c], [1, 2, 3] ]).
test(four_fail, [fail]) :-
    fibonacci_sublists([[], [a], [c], [a, c], [1, 2, 3, 4] ]).
test(ten, [nondet]) :-
    fibonacci_sublists([[], [a], [c], [a, c], [1, 2, 3], [1, 2, 3, 4, 5],
			Eight, Thirteen, TwentyOne, ThirtyFour, FiftyFive]),
    length(Eight, 8),
    length(Thirteen, 13),
    length(TwentyOne, 21),
    length(ThirtyFour, 34),
    length(FiftyFive, 55).
test(ten_fail, [fail]) :-
    fibonacci_sublists([[], [a], [c], [a, c], [1, 2, 3], [1, 2, 3, 4, 5],
			Eight, Thirteen, TwentyOne, ThirtyFour, FiftySix]),
    !, %prevent backtracking
    length(Eight, 8),
    length(Thirteen, 13),
    length(TwentyOne, 21),
    length(ThirtyFour, 34),
    length(FiftySix, 56).
test(four_start_22, [nondet]) :-
    fibonacci_sublists([[1, 2], [1, 2], [1, 2, 3, 4], [1, 2, 3, 4, 5, 6]]).
test(four_start_22_fail, [fail]) :-
    fibonacci_sublists([[1, 2], [1, 2], [1, 2, 3, 4], [1, 2, 3, 4, 5]]).
:-end_tests(fibonacci_sublists).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%% assoc_lookup/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% #4: 5-points

% A "association list" is a list of (Key, Value) pairs and can
% be used as a dictionary.

% assoc_lookup(Assoc, Key, Value): succeeds if Value is associated with
% Key in association list Assoc.
% *Restriction*: you may not use recursion.
% *Hint* your solution should simply call a Prolog built-in.
assoc_lookup(_Assoc, _Key, _Value) :- 'TODO'.

:-begin_tests(assoc_lookup, [blocked('TODO')]).
test(empty, [fail]) :-
    assoc_lookup([], key, _Value).
test(first, [nondet]) :-
    assoc_lookup([(key, 42), (a, 22), (b, 33)], key, Value),
    42 = Value.
test(last, [nondet]) :-
    assoc_lookup([(a, 22), (b, 33), (key, 42)], key, Value),
    Value = 42.
test(mid, [nondet]) :-
    assoc_lookup([(a, 22), (key, 42), (b, 33)], key, Value),
    42 = Value.
test(multi, [nondet]) :-
    assoc_lookup([(a, 22), (key, 42), (b, 33), (key, 22) ], key, Value),
    Value = 42.
test(multi_fail, [fail]) :-
    assoc_lookup([(a, 22), (key, 42), (b, 33), (key, 22) ], key, Value),
    43 = Value.
test(bound_value, [nondet]) :-
    assoc_lookup([(a, 22), (key, 42), (b, 33), (key, 22) ], key, 22).
test(unbound_key, [nondet]) :-
    assoc_lookup([(a, 22), (key, 42), (b, 33), (key, 22) ], Key, 33),
    b = Key.
:-end_tests(assoc_lookup).

%%%%%%%%%%%%%%%%%%%%%%%%%%%% assoc_replace/3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% #5: 10-points

% assoc_replace(AtomIntList, Assoc, ListZ): given a list AtomIntList
% containing Prolog atoms and integers, match ListZ with the list
% which is the result of replacing all atoms in AtomIntList with their
% value in assoc-list Assoc.
%
% *Hints*: Use assoc_lookup/3 from your answer to the previous
% exercise and Prolog's built-ins atom(A) which succeeds if A is an
% atom and integer(I) which succeeds if I is an integer.

assoc_replace(_AtomIntList, _Assoc, _ListZ) :- 'TODO'.

:-begin_tests(assoc_replace, [blocked('TODO')]).
test(empty, [nondet]) :-
    assoc_replace([], [(a,22), (b, 33), (c, 42)], Z),
    Z = [].
test(single, [nondet]) :-
    assoc_replace([c], [(a,22), (b, 33), (c, 42)], Z),
    Z = [42].
test(none, [nondet]) :-
    assoc_replace([77], [(a,22), (b, 33), (c, 42)], Z),
    Z = [77].
test(multi, [nondet]) :-
    assoc_replace([c, a, 8, b, 44], [(a,22), (b, 33), (c, 42)], Z),
    Z = [42, 22, 8, 33, 44].
test(multi_fail, [fail]) :-
    assoc_replace([c, a, d, b, 44], [(a,22), (b, 33), (c, 42)], Z),
    Z = [42, 22, d, 33, 44].
:-end_tests(assoc_replace).

%%%%%%%%%%%%%%%%%%%%%%%%%%% add_to_plus_expr/2 %%%%%%%%%%%%%%%%%%%%%%%%%%

% #6: 10-points

% An add-expr is an integer or of the form add(X, Y), where X and
% Y are add-expr's.  A plus-expr is an integer or of the form +(X, Y),
% where X and Y are plus-expr's (note that +(X, Y) can also be
% written in Prolog as X + Y).
%
% add_to_plus_expr(AddExpr, PlusExpr) should succeed iff PlusExpr
% is the same as AddExpr with each add replaced by +.
%
% *Hint*: the Prolog built-in integer(I) succeeds iff I is an integer.
add_to_plus_expr(_AddExprI, _PlusExpr) :- 'TODO'.

:-begin_tests(add_to_plus_expr, [blocked('TODO')]).
test(int, [nondet]) :-
    add_to_plus_expr(42, Z), Z = 42.
test(add_2_3, [nondet]) :-
    add_to_plus_expr(add(2, 3), Z), Z = 2 + 3.
test(add_add_2_3_add_4_5, [nondet]) :-
    add_to_plus_expr(add(add(2, 3), add(4, 5)), Z), Z = (2 + 3) + (4 + 5).
test(add_add_add_add_1_2_3_4_5, [nondet]) :-
    add_to_plus_expr(add(add(add(add(1, 2), 3), 4), 5), Z),
    Z = 1 + 2 + 3 + 4 + 5.
test(add_add_add_add_1_2_3_4_5_fail, [fail]) :-
    add_to_plus_expr(add(add(add(add(1, 2), 3), 4), 5), Z),
    Z = 1 + 2 + 3 + (4 + 5).
test(add_1_add_2_add_3_add_4_5, [nondet]) :-
    add_to_plus_expr(add(1, add(2, add(3, add(4, 5)))), Z),
    Z = 1 + (2 + (3 + (4 + 5))).

% reversed instantiation patterns
test(rev_int, [nondet]) :-
    add_to_plus_expr(Z, 42), Z = 42.
test(rev_add_2_3, [nondet]) :-
    add_to_plus_expr(Z, 2 + 3), Z = add(2, 3).
test(rev_add_add_2_3_add_4_5, [nondet]) :-
    add_to_plus_expr(Z, (2 + 3) + (4 + 5)), Z = add(add(2, 3), add(4, 5)).
test(rev_add_add_add_add_1_2_3_4_5, [nondet]) :-
    add_to_plus_expr(Z,  1 + 2 + 3 + 4 + 5),
    Z = add(add(add(add(1, 2), 3), 4), 5).
test(rev_add_add_add_add_1_2_3_4_5_fail, [fail]) :-
    add_to_plus_expr(Z, 1 + 2 + 3 + (4 + 5)),
    Z = add(add(add(add(1, 2), 3), 4), 5).
test(rev_add_1_add_2_add_3_add_4_5, [nondet]) :-
    add_to_plus_expr(Z, 1 + (2 + (3 + (4 + 5)))),
    Z = add(1, add(2, add(3, add(4, 5)))).    
:-end_tests(add_to_plus_expr).

%%%%%%%%%%%%%%%%%%%%%%%%%%% named_to_op_expr/2 %%%%%%%%%%%%%%%%%%%%%%%%%%

% #7: 10-points

% A named-expr is either a integer, or is one of add(X, Y) or
% mul(X, Y) where X and Y are named-expr's.  An op-expr
% is an arithmetic expression over integers and binary operators + and
% *.
%
% named_to_op_expr(NamedExpr, OpExpr) should succeed iff OpExpr
% is the same as NamedExpr with each add and mul replaced by
% + and * respectively.
% It should be possible to run this procedure with either one or
% both arguments instantiated.
named_to_op_expr(_NamedExpr, _OpExpr) :- 'TODO'.

:-begin_tests(named_to_op_expr, [blocked('TODO')]).
test(int, [nondet]) :-
    NamedExpr = 42, OpExpr = 42,
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.

test(add_2_3, [nondet]) :-
    NamedExpr = add(2, 3), OpExpr = 2 + 3,
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
test(add_add_2_3_add_4_5, [nondet]) :-
    NamedExpr = add(add(2, 3), add(4, 5)), OpExpr = (2 + 3) + (4 + 5),
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
test(add_add_add_add_1_2_3_4_5, [nondet]) :-
    NamedExpr = add(add(add(add(1, 2), 3), 4), 5), OpExpr = 1 + 2 + 3 + 4 + 5,
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
test(add_add_add_add_1_2_3_4_5_fail, [fail]) :-
    NamedExpr = add(add(add(add(1, 2), 3), 4), 5), OpExpr = 1 + 2 + 3 + (4 + 5),
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
test(add_1_add_2_add_3_add_4_5, [nondet]) :-
    NamedExpr = add(1, add(2, add(3, add(4, 5)))),
    OpExpr = 1 + (2 + (3 + (4 + 5))), 
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
		     

test(mul_2_3, [nondet]) :-
    NamedExpr = mul(2, 3), OpExpr = 2 * 3,
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
test(mul_mul_2_3_mul_4_5, [nondet]) :-
    NamedExpr = mul(mul(2, 3), mul(4, 5)), OpExpr = (2 * 3) * (4 * 5),
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
test(mul_mul_mul_mul_1_2_3_4_5, [nondet]) :-
    NamedExpr = mul(mul(mul(mul(1, 2), 3), 4), 5), OpExpr = 1 * 2 * 3 * 4 * 5,
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
test(mul_mul_mul_mul_1_2_3_4_5_fail, [fail]) :-
    NamedExpr = mul(mul(mul(mul(1, 2), 3), 4), 5),
    OpExpr = 1 * 2 * 3 * (4 * 5),
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
test(mul_1_mul_2_mul_3_mul_4_5, [nondet]) :-
    NamedExpr = mul(1, mul(2, mul(3, mul(4, 5)))),
    OpExpr = 1 * (2 * (3 * (4 * 5))),
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.

test(mul_add_1_mul_2_3, [nondet]) :-
    NamedExpr = mul(add(1, 2), 3), OpExpr = (1 + 2) * 3,
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
test(add_1_mul_2_3, [nondet]) :-
    NamedExpr = add(1, mul(2, 3)), OpExpr = 1 + 2*3,
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
test(add_mul_1_2_add_3_4, [nondet]) :-
    NamedExpr = add(mul(1, 2), mul(3, 4)), OpExpr = 1*2 + 3*4,
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.
test(mul_add_1_2_mul_3_4, [nondet]) :-
    NamedExpr = mul(add(1, 2), add(3, 4)), OpExpr = (1 + 2) * (3 + 4),
    named_to_op_expr(NamedExpr, Z),
    Z = OpExpr.

% reversed instantiation patterns
test(rev_int, [nondet]) :-
    NamedExpr = 42, OpExpr = 42,
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.

test(rev_add_2_3, [nondet]) :-
    NamedExpr = add(2, 3), OpExpr = 2 + 3,
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
test(rev_add_add_2_3_add_4_5, [nondet]) :-
    NamedExpr = add(add(2, 3), add(4, 5)), OpExpr = (2 + 3) + (4 + 5),
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
test(rev_add_add_add_add_1_2_3_4_5, [nondet]) :-
    NamedExpr = add(add(add(add(1, 2), 3), 4), 5), OpExpr = 1 + 2 + 3 + 4 + 5,
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
test(rev_add_add_add_add_1_2_3_4_5_fail, [fail]) :-
    NamedExpr = add(add(add(add(1, 2), 3), 4), 5), OpExpr = 1 + 2 + 3 + (4 + 5),
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
test(rev_add_1_add_2_add_3_add_4_5, [nondet]) :-
    NamedExpr = add(1, add(2, add(3, add(4, 5)))),
    OpExpr = 1 + (2 + (3 + (4 + 5))), 
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
		     

test(rev_mul_2_3, [nondet]) :-
    NamedExpr = mul(2, 3), OpExpr = 2 * 3,
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
test(rev_mul_mul_2_3_mul_4_5, [nondet]) :-
    NamedExpr = mul(mul(2, 3), mul(4, 5)), OpExpr = (2 * 3) * (4 * 5),
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
test(rev_mul_mul_mul_mul_1_2_3_4_5, [nondet]) :-
    NamedExpr = mul(mul(mul(mul(1, 2), 3), 4), 5), OpExpr = 1 * 2 * 3 * 4 * 5,
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
test(rev_mul_mul_mul_mul_1_2_3_4_5_fail, [fail]) :-
    NamedExpr = mul(mul(mul(mul(1, 2), 3), 4), 5),
    OpExpr = 1 * 2 * 3 * (4 * 5),
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
test(rev_mul_1_mul_2_mul_3_mul_4_5, [nondet]) :-
    NamedExpr = mul(1, mul(2, mul(3, mul(4, 5)))),
    OpExpr = 1 * (2 * (3 * (4 * 5))),
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.

test(rev_mul_add_1_mul_2_3, [nondet]) :-
    NamedExpr = mul(add(1, 2), 3), OpExpr = (1 + 2) * 3,
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
test(rev_add_1_mul_2_3, [nondet]) :-
    NamedExpr = add(1, mul(2, 3)), OpExpr = 1 + 2*3,
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
test(rev_add_mul_1_2_add_3_4, [nondet]) :-
    NamedExpr = add(mul(1, 2), mul(3, 4)), OpExpr = 1*2 + 3*4,
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.
test(rev_mul_add_1_2_mul_3_4, [nondet]) :-
    NamedExpr = mul(add(1, 2), add(3, 4)), OpExpr = (1 + 2) * (3 + 4),
    named_to_op_expr(Z, OpExpr),
    Z = NamedExpr.

:-end_tests(named_to_op_expr).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% named_expr_eval/2 %%%%%%%%%%%%%%%%%%%%%%%%%

% #8: 10-points

% named_expr_eval(NamedExpr, Value): Value matches the result of evaluating
% named-expr NamedExpr (named-expr is as in the previous question, add
% should add its operands and mul should multiply them).
%
% *Hint*: combine your solution to the previous exercise with is/2.
named_expr_eval(_NamedExpr, _Value) :- 'TODO'.

:-begin_tests(named_expr_eval, [blocked('TODO')]).
test(int, [nondet]) :-
    named_expr_eval(42, 42).

test(add_2_3, [nondet]) :-
    named_expr_eval(add(2, 3), 5).
test(add_add_2_3_add_4_5, [nondet]) :-
    named_expr_eval(add(add(2, 3), add(4, 5)), 14).
test(add_add_add_add_1_2_3_4_5, [nondet]) :-
    named_expr_eval(add(add(add(add(1, 2), 3), 4), 5), 15).
test(add_add_add_add_1_2_3_4_5_fail, [fail]) :-
    named_expr_eval(add(add(add(add(1, 2), 3), 4), 5), 16).
test(add_1_add_2_add_3_add_4_5, [nondet]) :-
    named_expr_eval(add(1, add(2, add(3, add(4, 5)))), 15).

test(mul_2_3, [nondet]) :-
    named_expr_eval(mul(2, 3), 6).
test(mul_mul_2_3_mul_4_5, [nondet]) :-
    named_expr_eval(mul(mul(2, 3), mul(4, 5)), 120).
test(mul_mul_mul_mul_1_2_3_4_5, [nondet]) :-
    named_expr_eval(mul(mul(mul(mul(1, 2), 3), 4), 5), 120).
test(mul_mul_mul_mul_1_2_3_4_5_fail, [fail]) :-
    named_expr_eval(mul(mul(mul(mul(1, 2), 3), 4), 5), 121).
test(mul_1_mul_2_mul_3_mul_4_5, [nondet]) :-
    named_expr_eval(mul(1, mul(2, mul(3, mul(4, 5)))), 120).

test(mul_add_1_mul_2_3, [nondet]) :-
    named_expr_eval(mul(add(1, 2), 3), 9).
test(add_1_mul_2_3, [nondet]) :-
    named_expr_eval(add(1, mul(2, 3)), 7).
test(add_mul_1_2_add_3_4, [nondet]) :-
    named_expr_eval(add(mul(1, 2), mul(3, 4)), 14).
test(mul_add_1_2_mul_3_4, [nondet]) :-
    named_expr_eval(mul(add(1, 2), add(3, 4)), 21).

:-end_tests(named_expr_eval).

%%%%%%%%%%%%%%%%%%%%% named_expr_to_prefix_tokens/2 %%%%%%%%%%%%%%%%%%%%%

% #9: 15-points

% named_expr_to_prefix_tokens(NamedExpr, PrefixTokens): PrefixTokens is
% a list of the tokens in NamedExpr in prefix notation.
%
% *Hint*: use append/3.
named_expr_to_prefix_tokens(_NamedExpr, _PrefixTokens) :- 'TODO'.

:-begin_tests(named_expr_to_prefix_tokens, [blocked('TODO')]).
test(int, [nondet]) :-
    named_expr_to_prefix_tokens(42, [42]).

test(add_2_3, [nondet]) :-
    named_expr_to_prefix_tokens(add(2, 3), [add, 2, 3]).
test(add_add_2_3_add_4_5, [nondet]) :-
    named_expr_to_prefix_tokens(add(add(2, 3), add(4, 5)),
			 [add, add, 2, 3, add, 4, 5]).
test(add_add_add_add_1_2_3_4_5, [nondet]) :-
    named_expr_to_prefix_tokens(add(add(add(add(1, 2), 3), 4), 5),
			 [add, add, add, add, 1, 2, 3, 4, 5]).
test(add_add_add_add_1_2_3_4_5_fail, [fail]) :-
    named_expr_to_prefix_tokens(add(add(add(add(1, 2), 3), 4), 5), 
			 [add, add, add, 1, 2, 3, 4, 5]).
test(add_1_add_2_add_3_add_4_5, [nondet]) :-
    named_expr_to_prefix_tokens(add(1, add(2, add(3, add(4, 5)))),
			 [add, 1, add, 2, add, 3, add, 4, 5]).

test(mul_2_3, [nondet]) :-
    named_expr_to_prefix_tokens(mul(2, 3), [mul, 2, 3]).
test(mul_mul_2_3_mul_4_5, [nondet]) :-
    named_expr_to_prefix_tokens(mul(mul(2, 3), mul(4, 5)),
			 [mul, mul, 2, 3, mul, 4, 5]).
test(mul_mul_mul_mul_1_2_3_4_5, [nondet]) :-
    named_expr_to_prefix_tokens(mul(mul(mul(mul(1, 2), 3), 4), 5),
			 [mul, mul, mul, mul, 1, 2, 3, 4, 5]).
test(mul_mul_mul_mul_1_2_3_4_5_fail, [fail]) :-
    named_expr_to_prefix_tokens(mul(mul(mul(mul(1, 2), 3), 4), 5), 
			 [mul, mul, mul, 1, 2, 3, 4, 5]).
test(mul_1_mul_2_mul_3_mul_4_5, [nondet]) :-
    named_expr_to_prefix_tokens(mul(1, mul(2, mul(3, mul(4, 5)))),
			 [mul, 1, mul, 2, mul, 3, mul, 4, 5]).

test(mul_add_1_2_3, [nondet]) :-
    named_expr_to_prefix_tokens(mul(add(1, 2), 3), [mul, add, 1, 2, 3]).
test(add_1_mul_2_3, [nondet]) :-
    named_expr_to_prefix_tokens(add(1, mul(2, 3)), [add, 1, mul, 2, 3]).
test(add_mul_1_2_add_3_4, [nondet]) :-
    named_expr_to_prefix_tokens(add(mul(1, 2), mul(3, 4)),
			[add, mul, 1, 2, mul, 3, 4]).
test(mul_add_1_2_mul_3_4, [nondet]) :-
    named_expr_to_prefix_tokens(mul(add(1, 2), add(3, 4)),
			[mul, add, 1, 2, add, 3, 4]).
:-end_tests(named_expr_to_prefix_tokens).

%%%%%%%%%%%%%%%%%%%%%%% op_expr_to_prefix_expr/2 %%%%%%%%%%%%%%%%%%%%%%%

% #10: 10-points

% op_to_prefix_expr(OpExpr, PrefixTokens): Given a OpExpr involving
% integers, + and *, set PrefixTokens to a list containing its tokens
% in prefix notation.
%
% *Restriction*: must be implemented using *only* earlier procedures;
% cannot directly use recursion or Prolog built-ins.

op_expr_to_prefix_tokens(_OpExpr, _PrefixTokens) :- 'TODO'.

:-begin_tests(op_expr_to_prefix_tokens, [blocked('TODO')]).
test(int, [nondet]) :-
    op_expr_to_prefix_tokens(42, [42]).

test(add_2_3, [nondet]) :-
    op_expr_to_prefix_tokens(+(2, 3), [+, 2, 3]).
test(add_add_2_3_add_4_5, [nondet]) :-
    op_expr_to_prefix_tokens(+(+(2, 3), +(4, 5)),
			 [+, +, 2, 3, +, 4, 5]).
test(add_add_add_add_1_2_3_4_5, [nondet]) :-
    op_expr_to_prefix_tokens(+(+(+(+(1, 2), 3), 4), 5),
			 [+, +, +, +, 1, 2, 3, 4, 5]).
test(add_add_add_add_1_2_3_4_5_fail, [fail]) :-
    op_expr_to_prefix_tokens(+(+(+(+(1, 2), 3), 4), 5), 
			 [+, +, +, 1, 2, 3, 4, 5]).
test(add_1_add_2_add_3_add_4_5, [nondet]) :-
    op_expr_to_prefix_tokens(+(1, +(2, +(3, +(4, 5)))),
			 [+, 1, +, 2, +, 3, +, 4, 5]).

test(mul_2_3, [nondet]) :-
    op_expr_to_prefix_tokens(*(2, 3), [*, 2, 3]).
test(mul_mul_2_3_mul_4_5, [nondet]) :-
    op_expr_to_prefix_tokens(*(*(2, 3), *(4, 5)),
			 [*, *, 2, 3, *, 4, 5]).
test(mul_mul_mul_mul_1_2_3_4_5, [nondet]) :-
    op_expr_to_prefix_tokens(*(*(*(*(1, 2), 3), 4), 5),
			 [*, *, *, *, 1, 2, 3, 4, 5]).
test(mul_mul_mul_mul_1_2_3_4_5_fail, [fail]) :-
    op_expr_to_prefix_tokens(*(*(*(*(1, 2), 3), 4), 5), 
			 [*, *, *, 1, 2, 3, 4, 5]).
test(mul_1_mul_2_mul_3_mul_4_5, [nondet]) :-
    op_expr_to_prefix_tokens(*(1, *(2, *(3, *(4, 5)))),
			 [*, 1, *, 2, *, 3, *, 4, 5]).

test(mul_add_1_2_3, [nondet]) :-
    op_expr_to_prefix_tokens(*(+(1, 2), 3), [*, +, 1, 2, 3]).
test(add_1_mul_2_3, [nondet]) :-
    op_expr_to_prefix_tokens(+(1, *(2, 3)), [+, 1, *, 2, 3]).
test(add_mul_1_2_add_3_4, [nondet]) :-
    op_expr_to_prefix_tokens(+(*(1, 2), *(3, 4)),
			[+, *, 1, 2, *, 3, 4]).
test(mul_add_1_2_mul_3_4, [nondet]) :-
    op_expr_to_prefix_tokens(*(+(1, 2), +(3, 4)),
			[*, +, 1, 2, +, 3, 4]).
:-end_tests(op_expr_to_prefix_tokens).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% main/0 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

main :-
    current_prolog_flag(argv, Argv),
    (length(Argv, 0) -> run_tests ; run_tests(Argv)).

:-initialization(main, main).


    

  
