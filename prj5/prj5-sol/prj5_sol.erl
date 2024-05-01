-module(prj5_sol).
-include_lib("eunit/include/eunit.hrl").
-compile([nowarn_export_all, export_all]).

%---------------------------- Test Control ------------------------------
%% Enabled Tests
%%   comment out -define to deactivate test.
%%   alternatively, enclose deactivated tests within
%%   -if(false). and -endif. lines
%% Enable all tests before submission.
%% The skeleton file is distributed with all tests deactivated
%% by being enclosed within if(false) ... endif directives.

-define(test_rec_poly_eval, enabled).
-define(test_non_rec_poly_eval, enabled).
-define(test_tuple_poly_eval, enabled).
-define(test_assoc_lookup, enabled).
-if(false).
-define(test_id_poly_eval, enabled).
-define(test_server_fn, enabled).
-endif.


%----------------------- Recursive Polynomial Eval ----------------------

% #1: 15-points

% Given a list Coeffs of numbers [ C_0, C_1, C_2, ... ] and a
% number X, rec_poly_eval(Coeffs, X) should return the value of
% the polynomial
%
%   C_0 + C_1*X + C_2*X^2 + C_3*X^3 + ...
%
% where X^i denotes X to the power-of-i.
%
% *Restriction*: Your implementation is required to be tail-recursive.
% *Hint*: Use an auxiliary function.

rec_poly_eval(Coeffs, X) ->
  rec_poly_eval(Coeffs, X, 0, 0).

rec_poly_eval([], _X, _P, Acc) ->
  Acc;
rec_poly_eval([Coeff | Rest], X, P, Acc) ->
  rec_poly_eval(Rest, X, P + 1, Acc + Coeff * math:pow(X, P)).

-ifdef(test_rec_poly_eval).
rec_poly_eval_test_() -> [
  { "poly_empty", ?_assert(rec_poly_eval([], 2) == 0) },
  { "poly_4_1", ?_assert(rec_poly_eval([1], 4) == 1) },
  { "poly_4_1_2", ?_assert(rec_poly_eval([1, 2], 4) == 9) },
  { "poly_4_1_2_3", ?_assert(rec_poly_eval([1, 2, 3], 4) == 57) },
  { "poly_2_1_1_1", ?_assert(rec_poly_eval([1, 1, 1], 2) == 7) },
  { "poly_3_1_2_3_4", ?_assert(rec_poly_eval([1, 2, 3, 4], 3) == 142) }
].
-endif. %test_rec_poly_eval


%--------------------- Non-Recursive Polynomial Eval --------------------

% #2: 20-points

% Given a list Coeffs of numbers [ C_0, C_1, C_2, ... ] and a
% number X, non_rec_poly_eval(Coeffs, X) should return the value of
% the polynomial
%
%   C_0 + C_1*X + C_2*X^2 + C_3*X^3 + ...
%
% where X^i denotes X to the power-of-i.
%
% *Restriction*: Your implementation is not allowed to use recursion.
% *Hint*: Use a list comprehension to compute the terms of the
% polynomial (using list:zip, list:seq() and math:pow())
% followed by a lists:foldl() to sum the terms.

non_rec_poly_eval(Coeffs, X) ->
  Terms = [C * math:pow(X, I) || {C, I} <- lists:zip(Coeffs, lists:seq(0, length(Coeffs) - 1))],
  lists:foldl(fun(Term, Acc) -> Term + Acc end, 0, Terms).


-ifdef(test_non_rec_poly_eval).
non_rec_poly_eval_test_() -> [
  { "poly_empty", ?_assert(non_rec_poly_eval([], 2) == 0) },
  { "poly_4_1", ?_assert(non_rec_poly_eval([1], 4) == 1) },
  { "poly_4_1_2", ?_assert(non_rec_poly_eval([1, 2], 4) == 9) },
  { "poly_4_1_2_3", ?_assert(non_rec_poly_eval([1, 2, 3], 4) == 57) },
  { "poly_2_1_1_1", ?_assert(non_rec_poly_eval([1, 1, 1], 2) == 7) },
  { "poly_3_1_2_3_4", ?_assert(non_rec_poly_eval([1, 2, 3, 4], 3) == 142) }
].
-endif. %test_non_rec_poly_eval


%------------------------- Tuple Polynomial Eval ------------------------

% #3: 10-points

% Given a list TupleCoeffs of pairs { num, Coeff } of the form
% [ { num, C_0 }, { num, C_1 }, { num, C_2 }, ... ] and a
% number X, tuple_poly_eval(TupleCoeffs, X) should return the value of
% the polynomial
%
%   C_0 + C_1*X + C_2*X^2 + C_3*X^3 + ...
%
% where X^i denotes X to the power-of-i.
%
% *Hint*: Your solution can strip the coefficient out of tuple-pair
% and then call any one of the solutions to the two previous exercises.

tuple_poly_eval(TupleCoeffs, X) ->
  Coeffs = [C || { _num, C } <- TupleCoeffs],
  non_rec_poly_eval(Coeffs, X).

-ifdef(test_tuple_poly_eval).
tuple_poly_eval_test_() -> [
  { "poly_empty", ?_assert(tuple_poly_eval([], 2) == 0) },
  { "poly_4_1", ?_assert(tuple_poly_eval([{num, 1}], 4) == 1) },
  { "poly_4_1_2", ?_assert(tuple_poly_eval([{num, 1}, {num, 2}], 4) == 9) },
  { "poly_4_1_2_3",
    ?_assert(tuple_poly_eval([{num, 1}, {num, 2}, {num, 3}], 4) == 57) },
  { "poly_2_1_1_1",
    ?_assert(tuple_poly_eval([{num, 1}, {num, 1}, {num, 1}], 2) == 7) },
  { "poly_3_1_2_3_4",
    ?_assert(tuple_poly_eval([{num, 1}, {num, 2}, {num, 3}, {num, 4}], 3)
      == 142) }
].
-endif. %test_tuple_poly_eval


%----------------------- Assoc List Lookup ------------------------------

% #4: 15-points

% Lookup the Value of Key in assoc list Assoc list containing
% { Key, Value } pairs.  If not found, return the result of
% calling DefaultFn().
%
% Hint: implement by wrapping lists:keyfind() and using a case
% to pattern-match on the result.

assoc_lookup(Key, Assoc, DefaultFn) ->
  case lists:keyfind(Key, 1, Assoc) of
      {_, Value} -> Value;
      false -> DefaultFn()
  end.

% Lookup the Value of Key in assoc list Assoc list containing
% { Key, Value } pairs.  If not found, return 0.
%
% Hint: wrap assoc_lookup.
assoc_lookup_0(Key, Assoc) ->
  case lists:keyfind(Key, 1, Assoc) of
      {_, Value} -> Value;
      false -> 0
  end.

% Lookup the Value of Key in assoc list Assoc list containing
% { Key, Value } pairs.  If not found, throw an exception
% of the form { not_found Msg } where Msg is a string
% describing the error  (can be built using something like
% format("key ~p not found", [Key]) ).
%
% Hint: wrap assoc_lookup.
assoc_lookup_throw(Key, Assoc) ->
  case lists:keyfind(Key, 1, Assoc) of
      {_, Value} -> Value;
      false -> throw({not_found, format("key ~p not found", [Key])})
  end.

-ifdef(test_assoc_lookup).
assoc_lookup_test_() ->
    Assoc = [ {a, 22}, {b, 33}, {a, 44}, {b, 55}, {c, 66} ],
    [ { "find_first_0", ?_assert(assoc_lookup_0(a, Assoc) =:= 22) },
      { "find_mid_0", ?_assert(assoc_lookup_0(b, Assoc) =:= 33) },
      { "find_last_0", ?_assert(assoc_lookup_0(c, Assoc) =:= 66) },
      { "find_fail_0", ?_assert(assoc_lookup_0(e, Assoc) =:= 0) },
      { "find_first_throw", ?_assert(assoc_lookup_throw(a, Assoc) =:= 22) },
      { "find_mid_throw", ?_assert(assoc_lookup_throw(b, Assoc) =:= 33) },
      { "find_last_throw", ?_assert(assoc_lookup_throw(c, Assoc) =:= 66) },
      { "find_fail_throw",
	?_assertThrow({not_found, _}, assoc_lookup_throw(e, Assoc)) }
    ].

-endif.


%--------------------------- ID Polynomial Eval -------------------------

% #5: 10-points

% Given a list IdCoeffs of pairs { num, C } or { id, Atom} of the form
% and a number X, id_poly_eval(Assoc, IdCoeffs, X) should return the value
% of the polynomial
%
%   C_0 + C_1*X + C_2*X^2 + C_3*X^3 + ...
%
% where X^i denotes X to the power-of-i, and C_i is:
%
%   If IdCoeffs[i] is { num, C }, then C_i is C.
%
%   If IdCoeffs[i] is { id, Atom }, then C_i is
%   assoc_lookup_0(Atom, Assoc).
%
% *Hint*: Your solution should first convert IdCoeffs to a list
% of numbers and then call any one of the solutions to the two
% previous exercises.  Use a local auxiliary function to convert
% an element of IdCoeffs to a number.
id_poly_eval(_Assoc, _IdCoeffs, _X) ->
    'TODO'.


-ifdef(test_id_poly_eval).
id_poly_eval_test_() ->
  Assoc = [ {a, 1}, {b, 2}, {c, 3}, {d, 4} ],
  [
  { "poly_empty", ?_assert(id_poly_eval(Assoc, [], 2) == 0) },
  { "poly_4_1", ?_assert(id_poly_eval(Assoc, [{id, a}], 4) == 1) },
  { "poly_4_1_2", ?_assert(id_poly_eval(Assoc, [{num, 1}, {id, b}], 4) == 9) },
  { "poly_4_1_2_3",
    ?_assert(id_poly_eval(Assoc, [{num, 1}, {id, b}, {id, c}, {id, e}], 4)
     == 57) },
  { "poly_2_1_1_1",
    ?_assert(id_poly_eval(Assoc, [{num, 1}, {num, 1}, {num, 1}], 2) == 7) },
  { "poly_3_1_2_3_4",
    ?_assert(id_poly_eval(Assoc, [{num, 1}, {id, b}, {num, 3}, {id, d}], 3)
      == 142) }
  ].
-endif. %test_id_poly_eval


%---------------------------- Server Function ---------------------------

% #6: 30-points

% server_fn(Assoc, Coeffs) should receive messages Msg from clients and
% respond based on the form of Msg:
%
%    { ClientPid, stop }: the server should send a { self(), stopped }
%    reply to ClientPid and return.
%
%    { ClientPid, set_assoc, Assoc1 }: the server should send a
%    { self(), set_assoc } reply to ClientPid and recurse with Assoc
%    set to Assoc1 and Coeffs unchanged.
%
%    { ClientPid, set_coeffs, Coeffs1 }: the server should send a
%    { self(), set_coeffs } reply to ClientPid and recurse with Assoc
%    unchanged and Coeffs set to Coeffs1.
%
%    { ClientPid, eval, X }: the server should evaluate Result
%    = id_poly_eval(Assoc, Coeffs, X) and send a
%    { self(), eval, Result } reply to ClientPid and recurse with
%    Assoc and Coeffs unchanged.
%
%    Any other message Msg :
%      Use io:format(standard_error, "unknown message ~p~n", [ Msg ])
%      to log an error on standard error and recurse with both Assoc and
%      Coeffs unchanged.

server_fn(_Assoc, _Coeffs) ->
    'TODO'.

-ifdef(test_server_fn).

server_set_assoc(Pid, Assoc) ->
    Pid ! { self(), set_assoc, Assoc },
    receive
	{ Pid, X } ->
	    X
    end.

server_set_coeffs(Pid, Coeffs) ->
    Pid ! { self(), set_coeffs, Coeffs },
    receive
	{ Pid, X } ->
	    X
    end.

server_eval(Pid, X) ->
    Pid ! { self(), eval, X },
    receive
	{ Pid, eval, Z } ->
	    Z
    end.

server_fn_test_() ->
    Assoc1 = [{a, 42}, {b, 2}, {c, 3}, {d, 4}, {x, -1}, {y, -2}, {z, -3}],
    Coeffs1 = [{id, a}, {id, x}, {id, b}, {num, 3}],
    Assoc2 = [{a, 2}, {b, 3}, {c, 8}, {d, 7}, {x, 5}, {y, -3}, {z, 4}],
    Coeffs2 = [{id, x}, {id, c}, {id, d}, {num, 2}, { id, xx}],
     { setup,
       % before tests, create server with Assoc1 and Coeffs1
       fun () -> spawn(prj5_sol, server_fn, [Assoc1, Coeffs1]) end,

       % after tests, stop server.
       fun (Pid) -> Pid ! { self(), stop }, ok end,

       % return tests for server at Pid.
       fun (Pid) ->
         [
	  { "a_0", ?_assert(42.0 == server_eval(Pid, 0)) },
	  { "a_1", ?_assert(46 == server_eval(Pid, 1)) },
	  { "a_4", ?_assert(262 == server_eval(Pid, 4)) },

	  { "ch_assoc_b", ?_assert(set_assoc == server_set_assoc(Pid, Assoc2)) },
	  { "b_0", ?_assert(2 == server_eval(Pid, 0)) },
	  { "b_1", ?_assert(13 == server_eval(Pid, 1)) },
	  { "b_4", ?_assert(262 == server_eval(Pid, 4)) },

	  { "ch_coeffs_c", ?_assert(set_coeffs ==
	                            server_set_coeffs(Pid, Coeffs2)) },
	  { "c_0", ?_assert(5 == server_eval(Pid, 0)) },
	  { "c_1", ?_assert(22 == server_eval(Pid, 1)) },
	  { "c_4", ?_assert(277 == server_eval(Pid, 4)) },
	  % restore original env
	  { "ch_assoc_d", ?_assert(set_assoc == server_set_assoc(Pid, Assoc1)) },
	  { "ch_coeffs_d", ?_assert(set_coeffs ==
	                            server_set_coeffs(Pid, Coeffs1)) },
	  { "d_0", ?_assert(42 == server_eval(Pid, 0)) },
	  { "d_1", ?_assert(46 == server_eval(Pid, 1)) },
	  { "d_4", ?_assert(262 == server_eval(Pid, 4)) }
	 ]
       end
     }.

-endif. % test_server_fn


%------------------------------ Utilities -------------------------------

% Given a format string containing printf-like specifiers like ~p,
% return string resulting from substituting terms from ArgsList for ~p
% specifiers.
%
% For example, format("values are ~p and ~p", [22, {a, 33}])
% will result in the string "values are 22 and {a,33}".
format(Fmt, ArgsList) ->
    lists:flatten(io_lib:format(Fmt, ArgsList)).

% DEBUGGING.
% Use the ?debugFmt(Fmt, ArgsList) macro to produce debugging output
% when running tests.  For example,
%    ?debugFmt("values are ~p and ~p", [22, {a, 33}])
% will output the line
%    values are 22 and {a,33}


