:- module(board_utils, [
    size/1, % size(?S): S is a side's length (sudoku boards are always square).
    in_board/2, % in_board(?Row, ?Column)
    unsolve/0,
    reset_puzzle/0
]).

:- use_module(board).

size(S):-
    dimension(N),
    S is N * N.

in_board(R, C):-
    size(S),
    between(1, S, R),
    between(1, S, C).

unsolve:-
    forall(
        (cell(R, C, _),\+ fixed(R, C)),
        retractall(cell(R, C))
    ).

reset_puzzle:-
    retractall(title(_)),
    retractall(dimension(_)),
    retractall(cell(_,_,_)),
    retractall(fixed(_,_)).
