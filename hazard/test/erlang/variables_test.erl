-module(variables_test).
-include_lib("eunit/include/eunit.hrl").

% TODO Handle parsing of empty strings
% no_assignment_test() ->
%   ?assertEqual({[], []}, hazard:eval("")).

assignment_test() ->
  ?assertEqual({1, [{a, 1}]}, hazard:eval("a = 1")).

multiline_assignment_test() ->
  ?assertEqual({1, [{a, 1}, {b, 1}]}, hazard:eval("a = 1\nb = 1")).

multiple_assignment_test() ->
  ?assertEqual({1, [{a, 1}, {b, 1}]}, hazard:eval("a = b = 1")).

multiple_assignment_with_parens_test() ->
  ?assertEqual({1, [{a, 1}, {b, 1}]}, hazard:eval("a = (b = 1)")).

multiple_assignment_with_left_parens_test() ->
  ?assertEqual({1, [{a, 1}, {b, 1}]}, hazard:eval("(a) = (b = 1)")).

multiple_assignment_with_expression_test() ->
  ?assertEqual({-4, [{a, -4}, {b, -4}]}, hazard:eval("a = (b = -(2 * 2))")).

multiple_assignment_with_binding_expression_test() ->
  ?assertEqual({3, [{a, 3}, {b, 1}]}, hazard:eval("a = (b + 2)", [{b, 1}])).
