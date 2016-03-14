-module(arithmetic_test).
-include_lib("eunit/include/eunit.hrl").

% TODO Arithmetic operations are hardcoded.
% They should instead be implemented using message passing.

% TODO Implement div, res and pow.

integer_sum_test() ->
  ?assertEqual({3,[]}, hazard:eval("1+2")),
  ?assertEqual({6,[]}, hazard:eval("1+2+3")),
  ?assertEqual({6,[]}, hazard:eval("1 + 2 + 3")).

integer_sum_minus_test() ->
  ?assertEqual({-4,[]}, hazard:eval("1-2-3")),
  ?assertEqual({0,[]}, hazard:eval("1+2-3")),
  ?assertEqual({0,[]}, hazard:eval("1 + 2 - 3")).

integer_mult_test() ->
  ?assertEqual({6,[]}, hazard:eval("1*2*3")),
  ?assertEqual({6,[]}, hazard:eval("1 * 2 * 3")).

integer_div_test() ->
  ?assertEqual({0.5,[]}, hazard:eval("1 / 2")),
  ?assertEqual({2.0,[]}, hazard:eval("4 / 2")).

integer_mult_div_test() ->
  ?assertEqual({1.0,[]}, hazard:eval("2*1/2")),
  ?assertEqual({6.0,[]}, hazard:eval("3 * 4 / 2")).

integer_without_parens_test() ->
  ?assertEqual({17,[]}, hazard:eval("3 * 5 + 2")),
  ?assertEqual({17,[]}, hazard:eval("2 + 3 * 5")),
  ?assertEqual({6.0,[]}, hazard:eval("4 / 4 + 5")).

integer_with_parens_test() ->
  ?assertEqual({21,[]}, hazard:eval("3 * (5 + 2)")),
  ?assertEqual({25,[]}, hazard:eval("(2 + 3) * 5")),
  ?assertEqual({0.25,[]}, hazard:eval("4 / (11 + 5)")).

integer_with_unary_test() ->
  ?assertEqual({-1,[]}, hazard:eval("-1")),
  ?assertEqual({1,[]}, hazard:eval("+1")),
  ?assertEqual({-1,[]}, hazard:eval("(-1)")),
  ?assertEqual({1,[]}, hazard:eval("-(1 - 2)")),
  ?assertEqual({1,[]}, hazard:eval("+1")),
  ?assertEqual({3,[]}, hazard:eval("+ 1 + 2")),
  ?assertEqual({-3,[]}, hazard:eval("- 1 + - 2")),
  ?assertEqual({2,[]}, hazard:eval("- 1 * - 2")),
  ?assertEqual({-0.5,[]}, hazard:eval("+ 1 / - 2")).

integer_eol_test() ->
  ?assertEqual({8,[]}, hazard:eval("1 + 2\n3 + 5")),
  ?assertEqual({8,[]}, hazard:eval("1 + 2\n\n\n3 + 5")),
  ?assertEqual({8,[]}, hazard:eval("1 + 2;\n;;\n;3 + 5")).

float_with_parens_and_unary_test() ->
  ?assertEqual({-21.0,[]}, hazard:eval("-3.0 * (5 + 2)")),
  ?assertEqual({25.0,[]}, hazard:eval("(2 + 3.0) * 5")),
  ?assertEqual({0.25,[]}, hazard:eval("4 / (11.0 + 5)")).
