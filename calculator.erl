%% calculator.erl
-module(calculator).
-export([start/0, add/2, subtract/2, multiply/2, divide/2, calculate/3,
         sum_list/1, square_list/1, filter_odd/1, sum_list_foldl/1,
         calculator_process/0]).

%%%% Basic Arithmetic Operations %%%%

% Addition
add(A, B) -> A + B.

% Subtraction
subtract(A, B) -> A - B.

% Multiplication
multiply(A, B) -> A * B.

% Division with guard to handle division by zero
divide(_A, 0) ->
    io:format("Error: Division by zero~n"),
    undefined;
divide(A, B) -> A / B.

%%%% Calculate Function with Pattern Matching and Guards %%%%

% Addition
calculate(add, A, B) ->
    Result = add(A, B),
    io:format("~p + ~p = ~p~n", [A, B, Result]),
    Result;

% Subtraction
calculate(subtract, A, B) ->
    Result = subtract(A, B),
    io:format("~p - ~p = ~p~n", [A, B, Result]),
    Result;

% Multiplication
calculate(multiply, A, B) ->
    Result = multiply(A, B),
    io:format("~p * ~p = ~p~n", [A, B, Result]),
    Result;

% Division with guard
calculate(divide, _A, 0) ->
    io:format("Error: Division by zero~n"),
    undefined;
calculate(divide, A, B) ->
    Result = divide(A, B),
    io:format("~p / ~p = ~p~n", [A, B, Result]),
    Result.

%%%% Recursive Functions %%%%

% Sum a list of numbers recursively
sum_list([]) -> 0;
sum_list([Head | Tail]) ->
    Head + sum_list(Tail).

%%%% Using Higher-Order Functions with Lambda Expressions %%%%

% Square each element in a list
square_list(List) ->
    lists:map(fun(X) -> X * X end, List).

% Filter out even numbers (keep odd numbers)
filter_odd(List) ->
    lists:filter(fun(X) -> X rem 2 =/= 0 end, List).

% Sum all elements in a list using foldl
sum_list_foldl(List) ->
    lists:foldl(fun(X, Acc) -> X + Acc end, 0, List).

%%%% Concurrency: Process Creation and Message Passing %%%%

% Start function to initiate the calculator process interactively
start() ->
    calculator_process().

% Calculator process to handle interactive input
calculator_process() ->
    io:format("Welcome to the Erlang Interactive Calculator!~n"),
    io:format("Available operations: add, subtract, multiply, divide~n"),
    io:format("Type 'quit' to exit.~n"),
    loop().

% Loop function to continually prompt the user
loop() ->
    % Prompt for operation
    OperationInput = io:get_line("Enter operation: "),
    Operation = parse_operation(string:trim(OperationInput)),
    case Operation of
        quit ->
            io:format("Goodbye!~n"),
            ok;
        invalid ->
            io:format("Invalid operation. Please try again.~n"),
            loop();
        _ ->
            % Prompt for first number
            AInput = io:get_line("Enter first number: "),
            % Convert input to number
            {A, StatusA} = parse_number(string:trim(AInput)),
            case StatusA of
                error ->
                    io:format("Invalid number. Please try again.~n"),
                    loop();
                ok ->
                    % Prompt for second number
                    BInput = io:get_line("Enter second number: "),
                    {B, StatusB} = parse_number(string:trim(BInput)),
                    case StatusB of
                        error ->
                            io:format("Invalid number. Please try again.~n"),
                            loop();
                        ok ->
                            % Perform calculation
                            calculate(Operation, A, B),
                            loop()
                    end
            end
    end.

% Parse operation input
parse_operation("add") -> add;
parse_operation("subtract") -> subtract;
parse_operation("multiply") -> multiply;
parse_operation("divide") -> divide;
parse_operation("quit") -> quit;
parse_operation(_) -> invalid.

% Parse number input
parse_number(Input) ->
    case string:to_float(Input) of
        {error,no_float} ->
            case string:to_integer(Input) of
                {error,no_integer} ->
                    {0, error};
                {IntValue, _} ->
                    {IntValue, ok}
            end;
        {FloatValue, _} ->
            {FloatValue, ok}
    end.
