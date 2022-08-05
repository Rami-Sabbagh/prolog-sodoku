% Quickstart:

% ?- [tester].
% ?- run_tests.

:- begin_tests(sudoku).

:- use_module(puzzles).
:- use_module(validation).
:- use_module(solution).

:- use_module(board_utils).

test_puzzle_untimed:-
    solved,
    unsolve,
    \+ solved,
    solve,
    solved.

% 2 seconds limit
test_puzzle:- call_with_time_limit(2, test_puzzle_untimed).

% -- ENABLE ONE AT A TIME -- %

:- include('tests_full'). % 1 test

:- end_tests(sudoku).