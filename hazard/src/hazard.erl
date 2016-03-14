-module(hazard).
-export([parse/1, eval/1, eval/2, throw_hazard/1, throw_erlang/1, require_file/1, require_file/2]).

eval(String) -> eval(String, []).

eval(String, Binding) ->
  {value, Value, NewBinding} = erl_eval:exprs(parse(String), Binding),
  {Value, NewBinding}.

require_file(Path) ->
  Dirname = filename:dirname(?FILE),
  Paths = [
    filename:join([Dirname, "..", "lib"]),
    filename:join([Dirname, "..", "test", "hazard"])
  ],
  require_file(Path ++ ".hz", Paths).

require_file(Path, []) ->
  hazard_errors:raise(enoent, "could not load file ~ts", [Path]);

require_file(Path, [H|T]) ->
  Filepath = filename:join(H, Path),
  case file:read_file(Filepath) of
    { ok, Binary } -> eval(binary_to_list(Binary), [], Filepath);
    { error, enoent } -> require_file(Path, T);
    { error, Reason } -> hazard_errors:raise(Reason, "could not load file ~ts", [Filepath])
  end.

% Temporary to aid debugging
throw_hazard(String) ->
  erlang:error(io:format("~p~n", [parse(String)])).

% Temporary to aid debugging
throw_erlang(String) ->
  {ok, Tokens, _} = erl_scan:string(String),
  {ok, [Form]} = erl_parse:parse_exprs(Tokens),
  erlang:error(io:format("~p~n", [Form])).

% Parse file and transform tree to erlang bytecode
parse(String) ->
	{ok, Tokens, _} = hazard_lexer:string(String),
	{ok, ParseTree} = hazard_parser:parse(Tokens),
  Transform = fun(X, Acc) -> [transform(X)|Acc] end,
  lists:foldr(Transform, [], ParseTree).

transform({ binary_op, Line, Op, Left, Right }) ->
  {op, Line, Op, transform(Left), transform(Right)};

transform({ unary_op, Line, Op, Right }) ->
  {op, Line, Op, transform(Right)};

transform({ match, Line, Left, Right }) ->
  {match, Line, transform(Left), transform(Right)};

transform({'fun', Line, CLAUSES}) ->
  {'fun', Line, transform(CLAUSES)};

transform({clauses, CLAUSES}) ->
  {clauses, lists:map(fun transform/1, CLAUSES)};

transform({clause, LINE, ARG1, ARG2, OP}) ->
  {clause, LINE, ARG1, ARG2, lists:map(fun transform/1, OP) };

% Match all other expressions
transform(Expr) -> Expr.
