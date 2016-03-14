-module(function_test).
-include_lib("eunit/include/eunit.hrl").

% TODO Allow functions without body

function_assignment_test() ->
  {_, [{a, Res1}]} = hazard:eval("a = -> 1 + 2"),
  ?assertEqual(3, Res1()),
  {_, [{a, Res2}]} = hazard:eval("a = do 1 + 2"),
  ?assertEqual(3, Res2()).

function_nested_assignment_test() ->
  {_, [{a, Res1}]} = hazard:eval("a = -> -> 1 + 2"),
  ResF1 = Res1(),
  ?assertEqual(3, ResF1()),
  {_, [{a, Res2}]} = hazard:eval("a = do -> 1 + 2"),
  ResF2 = Res2(),
  ?assertEqual(3, ResF2()),
  {_, [{a, Res3}]} = hazard:eval("a = -> do 1 + 2"),
  ResF3 = Res3(),
  ?assertEqual(3, ResF3()),
  {_, [{a, Res4}]} = hazard:eval("a = do -> 1 + 2"),
  ResF4 = Res4(),
  ?assertEqual(3, ResF4()).

function_assignment_new_line_test() ->
  {_, [{a, Res1}]} = hazard:eval("a = ->\n1 + 2\nend"),
  ?assertEqual(3, Res1()),
  {_, [{a, Res2}]} = hazard:eval("a = do\n1 + 2\nend"),
  ?assertEqual(3, Res2()).

function_nested_assignment_new_line_test() ->
  {_, [{a, Res1}]} = hazard:eval("a = -> ->\n1 + 2\nend "),
  ResF1 = Res1(),
  ?assertEqual(3, ResF1()),
  {_, [{a, Res2}]} = hazard:eval("a = do\n-> 1 + 2\nend "),
  ResF2 = Res2(),
  ?assertEqual(3, ResF2()).

function_as_clojure_test() ->
  {_, [{a, Res1}|_]} = hazard:eval("b = 1; a = -> b + 2"),
  ?assertEqual(3, Res1()),
  {_, [{a, Res2}|_]} = hazard:eval("b = 1; a = do b + 2"),
  ?assertEqual(3, Res2()).
