
check_size(N, T) :- 
    length(T, N),
    check_row_length(N,T).

check_row_length(_, []).
check_row_length(N, [H|T]) :-
    length(H,N),
    check_row_length(N, T).

listofNums(Low, High, []) :-
    Low > High.
listofNums(Low, High, [Low|Rest]) :-
    Low =< High,
    Next is Low + 1,
    listofNums(Next, High, Rest).
    
check_row_values(N, Row) :- 
    listofNums(1,N, List),
    sort(Row, Sorted), 
    Sorted == List.

check_all_row_values(N,[]).
check_all_row_values(N,[H|T]) :-
    check_row_values(N,H),
    check_all_row_values(N,T).

check_all_col_values(N, []).
check_all_col_values(N, [H|T]) :-
    check_row_values(N,H),
    check_all_col_values(N,T).

get_head([H|_], H). 
get_tail([_|T], T). 

transpose([], []). 
transpose([[]|_], []).
transpose(Matrix, [H|T]) :-
    maplist(get_head, Matrix, H),
    maplist(get_tail, Matrix, End),
    transpose(End, T).

ntower(N, T, C) :-
    integer(N), N >= 0, 
    check_size(N, T),
    check_all_row_values(N, T),
    transpose(T, Col),
    check_all_col_values(N, Col).

