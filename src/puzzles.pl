:- module(puzzles, [
    assert_nth0_puzzle/1,
    assert_nth1_puzzle/1
]).

:- use_module(board).

% --------------------

puzzles(Handle):-
    new_table('puzzles.csv', [
        title(string),
        dimension(integer),
        puzzle(string),
        solution(string)
    ], [
        field_separator(0',),
        encoding(utf8)
    ], Handle).

% --------------------

assert_puzzle(Puzzle, Dimension):-
    SideLength is Dimension * Dimension,
    assert_puzzle(Puzzle, SideLength, 0), !.

assert_puzzle(_, SideLength, Offset):- Offset >= (SideLength * SideLength), !.
assert_puzzle(Puzzle, SideLength, Offset):-
    !,
    Column is Offset mod SideLength + 1,
    Row is Offset // SideLength + 1,
    CodeIndex is Offset + 1,
    NextOffset is Offset + 1,
    string_code(CodeIndex, Puzzle, Code),
    assert_puzzle_cell(Code, Row, Column),
    assert_puzzle(Puzzle, SideLength, NextOffset).

assert_puzzle_cell(0'., _, _):- !.
assert_puzzle_cell(Code, Row, Column):-
    !,
    Value is Code - 0'0,
    between(1, 9, Value),
    assertz(cell(Row, Column, Value)),
    assertz(fixed(Row, Column)).

% --------------------

assert_solution(Solution, Dimension):-
    SideLength is Dimension * Dimension,
    assert_solution(Solution, SideLength, 0).

assert_solution(_, SideLength, Offset):- Offset >= (SideLength * SideLength), !.
assert_solution(Solution, SideLength, Offset):-
    !,
    Column is Offset mod SideLength + 1,
    Row is Offset // SideLength + 1,
    CodeIndex is Offset + 1,
    NextOffset is Offset + 1,
    string_code(CodeIndex, Solution, Code),
    assert_solution_cell(Code, Row, Column),
    assert_solution(Solution, SideLength, NextOffset).

assert_solution_cell(Code, Row, Column):-
    !,
    Value is Code - 0'0,
    between(1, 9, Value),
    (fixed(Row, Column) -> cell(Row, Column, Value); assertz(cell(Row, Column, Value))).

% --------------------

assert_puzzle_at(Handle, Pos):-
    read_table_fields(Handle, Pos, _, [
        title(Title),
        dimension(Dimension),
        puzzle(Puzzle),
        solution(Solution)
    ]),
    assertz(title(Title)),
    assertz(dimension(Dimension)),
    assert_puzzle(Puzzle, Dimension),
    assert_solution(Solution, Dimension).

% --------------------

assert_nth1_puzzle(Index):-
    ActualIndex is Index - 1,
    assert_nth0_puzzle(ActualIndex).

assert_nth0_puzzle(Index):-
    puzzles(Handle),
    assert_nth0_puzzle(Index, Handle, 0),!.

assert_nth0_puzzle(0, Handle, Offset):-
    !, assert_puzzle_at(Handle, Offset).

assert_nth0_puzzle(Index, Handle, Offset):-
    read_table_record_data(Handle, Offset, Next, _),
    NextIndex is Index - 1,
    assert_nth0_puzzle(NextIndex, Handle, Next).

