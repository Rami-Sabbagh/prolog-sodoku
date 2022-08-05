:- module(board, [
    title/1, % title(Title)
    dimension/1, % dimension(N)
    cell/3, % cell(row, column, value)
    fixed/2 % fixed(row, column): This cell is not part of the solution.
]).

:-
    dynamic(title/1),
    dynamic(dimension/1),
    dynamic(cell/3),
    dynamic(fixed/2).